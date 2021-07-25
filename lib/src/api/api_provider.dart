import 'dart:convert';

import 'package:trdi/src/models/album/album.dart';
import 'package:trdi/src/models/responses/response_article_screen/response_article_screen.dart';
import 'package:trdi/src/models/responses/response_video_screen/response_video_screen.dart';
import 'package:trdi/src/models/responses/response_videos/response_videos.dart';
import 'package:trdi/src/models/video/video.dart';
import 'package:trdi/src/providers/device_info_provider.dart';
import 'package:dio/dio.dart';
import '../models/article/article.dart';
import '../models/category/category.dart';
import '../models/magazine/magazine.dart';
import '../models/responses/response_posts/response_posts.dart';
import '../models/responses/response_categories/response_categories.dart';
import '../models/responses/response_videos/response_youtube_videos.dart';
import '../models/audio/audio.dart';
import '../models/event/event.dart';
import '../utils/utils.dart';
import '../utils/enums.dart';

class ApiProvider {
  static final DeviceInfoProvider _deviceInfoProvider = DeviceInfoProvider();

  final Dio _dio = Dio(BaseOptions(
    baseUrl: "$API_BASE_URL",
  ));

  void printError(error, StackTrace trace) {
    print("Exception: $error with stacktrace: $trace");
  }

  Future<Map<String, dynamic>> getLatestVersion() async {
    try {
      final response = await _dio.get("/current-version");
      return response.data;
    } catch (error) {
      rethrow;
    }
  }

  Future<PostType> getPostTypeBySlug(String slug) async {
    try {
      final response = await _dio.get("/type/$slug");
      String type = response.data["type"];

      switch (type) {
        case "Article":
          return PostType.Article;
        case "Audio":
          return PostType.Audio;
        case "Magazine":
          return PostType.Magazine;
        case "Event":
          return PostType.Event;
        case "Album":
          return PostType.Album;
        default:
          return PostType.Unknown;
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<ResponsePosts> getLatestArticlePosts() async {
    try {
      final response = await _dio.get("/articles");
      return ResponsePosts.fromJson(response.data);
    } catch (error, trace) {
      printError(error, trace);
      //return ResponsePosts.withError(error);
      throw error;
    }
  }

  Future<ResponsePosts> getLatestAudioPosts() async {
    try {
      final response = await _dio.get("/audios");
      return ResponsePosts.fromJson(response.data);
    } catch (error, trace) {
      printError(error, trace);
      throw error;
    }
  }

  Future<ResponsePosts> getLatestAlbumPosts() async {
    try {
      final response = await _dio.get("/albums");
      return ResponsePosts.fromJson(response.data);
    } catch (error, trace) {
      printError(error, trace);
      throw error;
    }
  }

  Future<Map<String, dynamic>> getLatestLiveVideo() async {
    try {
      final response = await _dio.get("/live");
      return response.data;
    } catch (error, trace) {
      printError(error, trace);
      throw error;
    }
  }

  Future<ResponseVideoScreen> getVideoScreenData() async {
    try {
      final response = await _dio.get("/video-screen");
      return ResponseVideoScreen.fromJson(response.data);
    } catch (error, trace) {
      printError(error, trace);
      throw error;
    }
  }

  Future<ResponseArticleScreen> getArticleScreenData() async {
    try {
      final response = await _dio.get("/article-screen");
      return ResponseArticleScreen.fromJson(response.data);
    } catch (error, trace) {
      printError(error, trace);
      throw error;
    }
  }

  Future<List<Event>> getEvents({int? month, int? year}) async {
    try {
      final List<Event> events = [];
      var response;

      if (month == null) {
        response = await _dio.get("/events");
      } else {
        int seconds = DateTime(year!, month).millisecondsSinceEpoch ~/ 1000;
        response = await _dio.get("/events/list/$seconds");
      }

      if (response.data == null || response.data["events"] == null) return [];

      (response.data["events"] as List)
          .forEach((map) => events.add(Event.fromJson(map)));

      return events;
    } catch (error, trace) {
      printError(error, trace);
      throw error;
    }
  }

  Future<ResponseVideos> getVideosByCategory(String categorySlug) async {
    try {
      final response = await _dio.get("/$categorySlug/videos");
      return ResponseVideos.fromJson(response.data);
    } catch (error, trace) {
      printError(error, trace);
      throw error;
    }
  }

  Future<ResponseVideos> getNextPageVideos(ResponseVideos videos) async {
    try {
      final response = await _dio.get(videos.links.next);
      return ResponseVideos.fromJson(response.data);
    } catch (error, trace) {
      printError(error, trace);
      throw error;
    }
  }

  Future<ResponsePosts> getNextPagePosts(ResponsePosts post) async {
    try {
      final response = await _dio.get(post.links.next);
      return ResponsePosts.fromJson(response.data);
    } catch (error, trace) {
      printError(error, trace);
      //return ResponsePosts.withError(error);
      throw error;
    }
  }

  Future<Article> getArticleBySlug(String slug) async {
    String deviceDataParameters =
        await _deviceInfoProvider.getDeviceDataAsParameters();

    try {
      print("/articles/$slug?$deviceDataParameters");
      final response = await _dio.get("/articles/$slug?$deviceDataParameters");
      return Article.fromJson(response.data);
    } catch (error, trace) {
      printError(error, trace);
      throw error;
    }
  }

  Future<Audio> getAudioBySlug(String slug) async {
    String deviceDataParameters =
        await _deviceInfoProvider.getDeviceDataAsParameters();

    try {
      print("/audios/$slug?$deviceDataParameters");
      final response = await _dio.get("/audios/$slug?$deviceDataParameters");
      return Audio.fromJson(response.data);
    } catch (error, trace) {
      printError(error, trace);
      throw error;
    }
  }

  Future<Album> getAlbumBySlug(String slug) async {
    String deviceDataParameters =
        await _deviceInfoProvider.getDeviceDataAsParameters();

    try {
      print("/albums/$slug?$deviceDataParameters");
      final response = await _dio.get("/albums/$slug?$deviceDataParameters");
      return Album.fromJson(response.data);
    } catch (error, trace) {
      printError(error, trace);
      throw error;
    }
  }

  Future<Magazine> getMagazineBySlug(String slug) async {
    String deviceDataParameters =
        await _deviceInfoProvider.getDeviceDataAsParameters();

    try {
      print("/magazines/$slug?$deviceDataParameters");
      final response = await _dio.get("/magazines/$slug?$deviceDataParameters");
      return Magazine.fromJson(response.data);
    } catch (error, trace) {
      printError(error, trace);
      throw error;
    }
  }

  Future<Video> getVideoBySlug(String slug) async {
    String deviceDataParameters =
        await _deviceInfoProvider.getDeviceDataAsParameters();

    try {
      print("/videos/$slug?$deviceDataParameters");
      final response = await _dio.get("/videos/$slug?$deviceDataParameters");
      return Video.fromJson(response.data);
    } catch (error, trace) {
      printError(error, trace);
      throw error;
    }
  }

  Future<Event> getEventBySlug(String slug) async {
    String deviceDataParameters =
        await _deviceInfoProvider.getDeviceDataAsParameters();

    try {
      print("/events/$slug?$deviceDataParameters");
      final response = await _dio.get("/events/$slug?$deviceDataParameters");
      return Event.fromJson(response.data);
    } catch (error, trace) {
      printError(error, trace);
      throw error;
    }
  }

  Future<ResponsePosts> getLatestMagazinePosts() async {
    try {
      final response = await _dio.get("/magazines");
      return ResponsePosts.fromJson(response.data);
    } catch (error, trace) {
      printError(error, trace);
      return ResponsePosts.withError(error.toString());
    }
  }

  Future<ResponsePosts> getLatestPinnedArticlePosts() async {
    try {
      final response = await _dio.get("/articles/pinned");
      return ResponsePosts.fromJson(response.data);
    } catch (error, trace) {
      printError(error, trace);
      return ResponsePosts.withError(error.toString());
    }
  }

  Future<ResponsePosts> getLatestArticlePostsByCategory(String category) async {
    try {
      final response = await _dio.get("/$category/articles");
      return ResponsePosts.fromJson(response.data);
    } catch (error, trace) {
      printError(error, trace);
      return ResponsePosts.withError(error.toString());
    }
  }

  Future<ResponseCategories> getCategories() async {
    try {
      final response = await _dio.get("/categories");
      final categories = ResponseCategories.fromJson(response.data);

      categories.categories.removeRange(0, 4);
      categories.categories
          .removeWhere((category) => category.totalPostCount == 0);
      categories.categories.insert(0, const Category(title: "All", slug: "all"));

      return categories;
    } catch (error, trace) {
      printError(error, trace);
      return ResponseCategories.withError(error.toString());
    }
  }

  Future<ResponseCategories> getVideoSubCategories() async {
    try {
      final response = await _dio.get("/video/categories");
      return ResponseCategories.fromJson(response.data);
    } catch (error, trace) {
      printError(error, trace);
      return ResponseCategories.withError(error.toString());
    }
  }
  /*
  
  Future<ResponseYoutubeVideos> getVideosByCategory(String category) async {
    try {
      final response = await _dio.get("/$category/videos");
      return ResponseYoutubeVideos.fromJson(response.data);

    } catch (error, trace) {
      printError(error, trace);
      return ResponseYoutubeVideos.withError(error);
    }
  }

  Future<ResponseYoutubeVideos> getVideoPlayLists() async {
    try {
      final response = await _dio.get("/video/playlists");
      return ResponseYoutubeVideos.fromJson(response.data);

    } catch (error, trace) {
      printError(error, trace);
      return ResponseYoutubeVideos.withError(error);
    }
  }

  Future<ResponseYoutubeVideos> getVideosByPlayList(int playlist) async {
    try {
      final response = await _dio.get("/videos/$playlist");
      return ResponseYoutubeVideos.fromJson(response.data);

    } catch (error, trace) {
      printError(error, trace);
      return ResponseYoutubeVideos.withError(error);
    }
  }*/
}
