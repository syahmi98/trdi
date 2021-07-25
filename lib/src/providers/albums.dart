import 'package:flutter/foundation.dart';

import '../api/api_repository.dart';
import '../models/album/album.dart';
import '../models/post/post.dart';
import '../models/responses/response_posts/response_posts.dart';

class Albums with ChangeNotifier {
  final _repository = ApiRepository();
  final List<Post> _albums = [];
  late ResponsePosts _responsePosts;
  bool _isLoading = false;
  bool hasLoaded = false;

  Future<void> loadData({bool reload: false}) async {
    if (_isLoading) return;
    _isLoading = true;

    try {
      _responsePosts = await _repository.fetchLatestAlbumPosts();

      if (reload) _albums.clear();

      _albums.addAll(_responsePosts.posts!.toList());

      hasLoaded = true;
    } catch (error) {
      hasLoaded = false;
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadNextPage() async {
    if (_isLoading) return;
    _isLoading = true;

    try {
      _responsePosts = await _repository.fetchNextPagePosts(_responsePosts);
      _albums.addAll(_responsePosts.posts!.toList());
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Album> getAlbumBySlug(String slug) async {
    return await _repository.fetchAlbumBySlug(slug);
  }

  ResponsePosts get responsePost => _responsePosts;
  List<Post> get albums => _albums;
}
