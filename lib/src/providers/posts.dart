import 'package:flutter/material.dart';

import '../api/api_repository.dart';
import '../models/article/article.dart';
import '../models/category/category.dart';
import '../models/magazine/magazine.dart';
import '../models/audio/audio.dart';
import '../models/responses/response_posts/response_posts.dart';
import '../models/responses/response_categories/response_categories.dart';
import '../utils/enums.dart';
import '../utils/utils.dart';
import '../models/post/post.dart';
import '../models/responses/response_article_screen/category_layout.dart';
import '../ui/screens/album_screen.dart';

class Posts with ChangeNotifier {
  final _repository = ApiRepository();
  final List<Post> _pinnedPosts = [];
  final List<Post> _latestPosts = [];
  // final List<Post> _pinnedPosts = [];
  // final List<Post> _latestPosts = [];
  final List<CategoryLayout> _categories = [];
  late Category _category;
  bool _isLoading = false;
  bool hasLoaded = false;

  Future<bool> deepLinkNavigator(BuildContext context, Uri link) async {
    try {
      if(link.pathSegments.length < 1) 
        return false;
      
      final String deepLinkSlug = link.pathSegments[0];

      PostType type = await _repository.fetchPostTypeBySlug(deepLinkSlug);

      switch(type) {
        case PostType.Article:
          Navigator.of(context).pushNamed(ROUTE_ARTICLE_SCREEN, arguments: deepLinkSlug);
          break;
        case PostType.Event:
          Navigator.of(context).pushNamed(ROUTE_EVENT_SCREEN, arguments: deepLinkSlug);
          break;
        case PostType.Magazine:
          Navigator.of(context).pushNamed(ROUTE_MAGAZINE_SCREEN, arguments: deepLinkSlug);
          break;
        case PostType.Audio:
          Navigator.of(context).pushNamed(ROUTE_AUDIO_SCREEN, arguments: deepLinkSlug);
          break;
        case PostType.Video:
          Navigator.of(context).pushNamed(ROUTE_VIDEO_SCREEN, arguments: deepLinkSlug);
          break;
        case PostType.Album:
          Navigator.of(context).pushNamed(AlbumScreen.route, arguments: deepLinkSlug);
          break;
        case PostType.Unknown:
          return false;
          break;
      }

      return true;

    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<void> loadArticleScreenData() async {
    if(_isLoading) return;
    _isLoading = true;

    try {
      final response = await _repository.fetchArticleScreenData();

      _pinnedPosts..clear()..addAll(response.pinnedPosts!.toList());
      _latestPosts..clear()..addAll(response.latestPosts!.toList());
      _categories..clear()..addAll(response.categories);

      hasLoaded = true;

    } catch (error) {
      hasLoaded = false;
      throw error;

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<CategoryLayout> get categories => _categories.where((c) => c.category.posts!.isNotEmpty).toList();
  List<Post> get pinnedPosts => [..._pinnedPosts];
  List<Post> get latestPosts => [..._latestPosts];

  Future<ResponsePosts> getLatestArticlePosts() async {
    if(_category == null)
      return await _repository.fetchLatestArticlePosts();
    else
      return await _repository.fetchLatestArticlePostsByCategory(_category.slug);
  }

  Future<ResponsePosts> getLatestArticlePostsByCategory(String slug) async {
    return await _repository.fetchLatestArticlePostsByCategory(slug);
  }

  Future<ResponsePosts> getLatestAudioPosts() async {
    return await _repository.fetchLatestAudioPosts();
  }

  Future<ResponsePosts> getNextPagePosts(ResponsePosts post) async {
    return await _repository.fetchNextPagePosts(post);
  }


  Future<ResponsePosts> getLatestMagazinePosts() async {
    return await _repository.fetchLatestMagazinePosts();
  }

  Future<Article> getArticleBySlug(String slug) async {
    return await _repository.fetchArticleBySlug(slug);
  }

  Future<Magazine> getMagazineBySlug(String slug) async {
    return await _repository.fetchMagazineBySlug(slug);
  }

  Future<Audio> getAudioBySlug(String slug) async {
    return await _repository.fetchAudioBySlug(slug);
  }
 
  Future<ResponsePosts> getLatestPinnedArticlePosts() async {
    return await _repository.fetchLatestPinnedArticlePosts();
  }

  Future<ResponseCategories> getCategories() async {
    return await _repository.fetchCategories();
  }

  void setCategory(Category category) {
    _category = category;
    notifyListeners();
  }

}