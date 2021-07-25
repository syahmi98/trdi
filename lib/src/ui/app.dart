import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

// import 'screens/about_screen.dart';
// import 'screens/album_screen.dart';
// import 'screens/event_screen.dart';
// import 'screens/gallery_screen.dart';
// import 'screens/video_screen.dart';
// import 'screens/paginated_videos_screen.dart';
// import 'screens/live_screen.dart';
import 'screens/article_screen.dart';
import 'screens/home/home_screen.dart';
// import 'screens/paginated_articles_screen.dart';
// import 'screens/magazine_screen.dart';
// import 'screens/audio_screen.dart';
// import 'screens/calendar_screen.dart';
import '../providers/albums.dart';
import '../providers/version_check.dart';
import '../providers/posts.dart';
import '../providers/videos.dart';
import '../providers/events.dart';
import '../providers/audio_handler.dart';
import '../utils/utils.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  final Dio _dio = Dio();
  final player = AudioPlayer();

  late Uri _notificationUri;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addObserver(this);
    initOneSignal();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    player.stop();
    player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) player.stop();
  }

  Future<void> initOneSignal() async {
    if (!mounted) return;

    final oneSignalId = await _getOneSignalId(_dio);

    final _settings = {
      OSiOSSettings.autoPrompt: true,
      OSiOSSettings.inAppLaunchUrl: true,
    };

    // await OneSignal.shared.init(
    //   oneSignalId,
    //   iOSSettings: _settings,
    // );

    // await OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);

    // OneSignal.shared.setNotificationOpenedHandler((notification) {
      // final url = notification.notification.payload.launchUrl;

      // if(notification.notification.appInFocus) {
        Provider.of<Posts>(context, listen: false).deepLinkNavigator(context, Uri.parse('/article-screen'));

      // } else if(url != null) {
      //   _notificationUri = Uri.parse(url);
      // }
    // });
  }

  Future<String> _getOneSignalId(Dio dio) async {
    // if(!mounted) return null;
    try {
      final response = await dio.get("$API_BASE_URL/onesignal-id");
      return response.data["onesignal_id"];
    } catch (error) {
      // print(error);
      //throw error;
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Posts>(create: (_) => Posts()),
        ChangeNotifierProvider<Videos>(create: (_) => Videos()),
        ChangeNotifierProvider<Events>(create: (_) => Events()),
        ChangeNotifierProvider<AudioHandler>(
            create: (_) => AudioHandler(player)),
        ChangeNotifierProvider<AppVersionCheck>(
            create: (_) => AppVersionCheck()),
        ChangeNotifierProvider<Albums>(create: (_) => Albums()),
      ],
      child: MaterialApp(
        title: APP_NAME,
        //darkTheme: darkTheme,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          accentColor: Colors.deepPurpleAccent,
          textTheme: Theme.of(context).textTheme.copyWith(
                display1: Theme.of(context).textTheme.display1!.copyWith(
                      color: Colors.black,
                    ),
              ),
        ),
        home: HomeScreen(),
        routes: {
          ROUTE_ARTICLE_SCREEN: (ctx) => ArticleScreen(),
          // ROUTE_MAGAZINE_SCREEN: (ctx) => MagazineScreen(),
          // ROUTE_VIDEO_SCREEN: (ctx) => VideoScreen(),
          // ROUTE_PAGINATED_ARTICLES_SCREEN: (ctx) => PaginatedArticlesScreen(),
          // ROUTE_PAGINATED_VIDEOS_SCREEN: (ctx) => PaginatedVideoScreen(),
          // ROUTE_LIVE_VIDEO_SCREEN: (ctx) => LiveScreen(),
          // ROUTE_AUDIO_SCREEN: (ctx) => AudioScreen(),
          // ROUTE_EVENT_SCREEN: (ctx) => EventScreen(),
          // ROUTE_ABOUT_SCREEN: (ctx) => AboutScreen(),
          // AlbumScreen.route: (ctx) => AlbumScreen(),
          // GalleryScreen.route: (ctx) => GalleryScreen(),
          // CalendarScreen.route: (ctx) => CalendarScreen(),
          // SingleImageScreen.route: (ctx) => SingleImageScreen(),
        },
      ),
    );
  }
}
