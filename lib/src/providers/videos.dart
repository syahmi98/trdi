import 'package:flutter/foundation.dart' as foundation;

import '../models/category/video_category.dart';
import '../models/responses/response_videos/response_videos.dart';
import '../models/video/video.dart';
import '../api/api_repository.dart';
import '../models/responses/response_categories/response_categories.dart';

class Videos with foundation.ChangeNotifier {
  final _apiRepository = ApiRepository();
  final List<VideoCategory> _categories = [];
  final Map<String, dynamic> _livestream = {};
  final Map<String, Map<String, dynamic>> _loadedVideos = {};
  bool _isLoading = false;
  bool hasLoaded = false;

  Future<void> loadVideoScreenData() async {
    if(_isLoading) return;
    _isLoading = true;

    try {
      final response = await _apiRepository.fetchVideoScreenData();

      _categories..clear()..addAll(response.categories);
      _livestream..clear()..addAll(response.livestream);

      hasLoaded = true;

    } catch (error) {
      hasLoaded = false;
      throw error;

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<VideoCategory> get categories => _categories;
  Map<String, dynamic> get livestream => _livestream;
  bool isVideosLoadedForCategory({String? slug}) {
    return _loadedVideos.containsKey(slug);
  }

  List<Video> getLoadedVideosOfCategory(String slug) {
    if(!isVideosLoadedForCategory(slug: slug))
      return [];

    return _loadedVideos[slug]!['videos'];
  }

  Future<ResponseVideos> loadPaginatedVideos(String categorySlug, {nextPage = false}) async {
    // if(nextPage && !_loadedVideos.containsKey(categorySlug)) return null;

    try {
      ResponseVideos response;

      if(nextPage)
        response = await _apiRepository.fetchNextPageVideos(_loadedVideos[categorySlug]!['current_response']);
      else
        response = await _apiRepository.fetchVideosByCategory(categorySlug);

      final videos = response.videos;

      if(_loadedVideos.containsKey(categorySlug)) {
        videos!.addAll(_loadedVideos[categorySlug]!['videos']);
      }

      _loadedVideos[categorySlug] = {
        'current_response': response,
        'videos': videos
      };

      notifyListeners();

      return response;

    } catch (error) {
      throw(error);
    }
  }

  Future<Video> fetchVideoBySlug(String slug) async {
    return await _apiRepository.fetchVideoBySlug(slug);
  }

  Future<ResponseCategories> fetchSubCategories() async {
    return await _apiRepository.fetchVideoSubCategories();
  }
  /*
  Future<ResponseCategories> fetchPlayLists() async {
    try {
      final response = await _apiRepository.fetchVideosPlayLists();

      return ResponseCategories(categories: [])..categories.addAll(
        response.videos.map((playlist) => 
          new Category(id: playlist.id, slug: "IS-A-PLAYLIST", title: playlist.videoTitle)
        ).toList()
      );

    } catch (error) {
      throw error;
    }
  }

  Future<ResponseCategories> mediatorFetchSubCategoriesAndPlayLists() async {
    try {
      final subCategoryResponse = await fetchSubCategories();
      final playListResponse = await fetchPlayLists();

      subCategoryResponse.categories.addAll(playListResponse.categories);
      return subCategoryResponse;

    } catch (error) {
      throw error;
    }
  }

  Future<ResponseYoutubeVideos> fetchVideosByMediatorPlayListAndCategory(Category category) async {
    if(category.slug == "IS-A-PLAYLIST")
      return await fetchVideosByPlayList(category.id);

    return await fetchVideosByCategory(category.slug);
  }

  Future<ResponseYoutubeVideos> fetchVideosByPlayList(int playlistId) async {
    return await _apiRepository.fetchVideosByPlayList(playlistId);
  }

  Future<ResponseYoutubeVideos> fetchVideosByCategory(String category) async {
    return await _apiRepository.fetchVideosByCategory(category);
  }*/

}