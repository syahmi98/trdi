import 'package:trdi/src/models/album/album.dart';
import 'package:trdi/src/models/responses/response_article_screen/response_article_screen.dart';
import 'package:trdi/src/models/responses/response_video_screen/response_video_screen.dart';
import 'package:trdi/src/models/responses/response_videos/response_videos.dart';
import 'package:trdi/src/models/video/video.dart';

import './api_provider.dart';
import '../models/article/article.dart';
import '../models/magazine/magazine.dart';
import '../models/responses/response_posts/response_posts.dart';
import '../models/responses/response_categories/response_categories.dart';
import '../models/responses/response_videos/response_youtube_videos.dart';
import '../models/event/event.dart';
import '../models/audio/audio.dart';
import '../utils/enums.dart';

class ApiRepository {
  final _apiProvider = ApiProvider();

  Future<PostType> fetchPostTypeBySlug(String slug) =>
    _apiProvider.getPostTypeBySlug(slug);

  Future<Map<String, dynamic>> fetchLatestVersion() =>
    _apiProvider.getLatestVersion();

  Future<ResponsePosts> fetchLatestArticlePosts() =>
    _apiProvider.getLatestArticlePosts();

  Future<ResponseVideoScreen> fetchVideoScreenData() =>
    _apiProvider.getVideoScreenData() as Future<ResponseVideoScreen>;

  Future<ResponseArticleScreen> fetchArticleScreenData() =>
    _apiProvider.getArticleScreenData() as Future<ResponseArticleScreen>;

  Future<ResponsePosts> fetchLatestAudioPosts() =>
    _apiProvider.getLatestAudioPosts();

  Future<ResponsePosts> fetchLatestAlbumPosts() =>
    _apiProvider.getLatestAlbumPosts();

  Future<Map<String, dynamic>> fetchLatestLiveVideo() => 
    _apiProvider.getLatestLiveVideo();

  Future<ResponseVideos> fetchNextPageVideos(ResponseVideos videos) =>
    _apiProvider.getNextPageVideos(videos) as Future<ResponseVideos>;

  Future<ResponseVideos> fetchVideosByCategory(String categorySlug) =>
    _apiProvider.getVideosByCategory(categorySlug) as Future<ResponseVideos>;

  Future<ResponsePosts> fetchNextPagePosts(ResponsePosts post) =>
    _apiProvider.getNextPagePosts(post);

  Future<List<Event>> fetchEvents({int? year, int? month}) =>
    _apiProvider.getEvents(year: year, month: month);

  Future<Article> fetchArticleBySlug(String slug) =>
    _apiProvider.getArticleBySlug(slug);

  Future<Audio> fetchAudioBySlug(String slug) =>
    _apiProvider.getAudioBySlug(slug);

  Future<Album> fetchAlbumBySlug(String slug) =>
    _apiProvider.getAlbumBySlug(slug) as Future<Album>;

  Future<Video> fetchVideoBySlug(String slug) =>
    _apiProvider.getVideoBySlug(slug) as Future<Video>;

  Future<Magazine> fetchMagazineBySlug(String slug) =>
    _apiProvider.getMagazineBySlug(slug);  

  Future<Event> fetchEventBySlug(String slug) =>
    _apiProvider.getEventBySlug(slug);

  Future<ResponsePosts> fetchLatestMagazinePosts() =>
    _apiProvider.getLatestMagazinePosts();

  Future<ResponsePosts> fetchLatestPinnedArticlePosts() =>
    _apiProvider.getLatestPinnedArticlePosts();

  Future<ResponsePosts> fetchLatestArticlePostsByCategory(String category) =>
    _apiProvider.getLatestArticlePostsByCategory(category);

  Future<ResponseCategories> fetchCategories() =>
    _apiProvider.getCategories();

  Future<ResponseCategories> fetchVideoSubCategories() =>
    _apiProvider.getVideoSubCategories();
  /*
  Future<ResponseYoutubeVideos> fetchVideosByCategory(String category) =>
    _apiProvider.getVideosByCategory(category);

  Future<ResponseYoutubeVideos> fetchVideosPlayLists() =>
    _apiProvider.getVideoPlayLists();

  Future<ResponseYoutubeVideos> fetchVideosByPlayList(int playlistId) =>
    _apiProvider.getVideosByPlayList(playlistId);
  */
}