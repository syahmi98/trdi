// MAIN

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share/share.dart';
import 'package:trdi/src/models/post/post.dart';

// MAIN SETTINGS
const APP_NAME = "TRDI News App";

// SCREEN ROUTES
const ROUTE_ARTICLE_SCREEN = "/article-screen";
const ROUTE_MAGAZINE_SCREEN = "/magazine-screen";
const ROUTE_PAGINATED_ARTICLES_SCREEN = "/paginated-articles-screen";
const ROUTE_PAGINATED_VIDEOS_SCREEN = "/paginated-videos-screen";
const ROUTE_LIVE_VIDEO_SCREEN = "/live-video-screen";
const ROUTE_VIDEO_SCREEN = "/video-screen";
const ROUTE_AUDIO_SCREEN = "/audio-screen";
const ROUTE_EVENT_SCREEN = "/event-screen";
const ROUTE_ABOUT_SCREEN = "/about-screen";

// FONTS
const FONT_MONTSERRAT = "Montserrat";

const LOCALHOST_MODE = false;  
const LOCALHOST_LAPTOP = false;

// APIs
/*const BASE_URL = "http://trdi.my";
const API_BASE_URL = "$BASE_URL/updi2/public/api";
const IMAGE_UPLOAD_URL = "$BASE_URL/updi/files/upload";
const FILE_UPLOAD_URL = "$BASE_URL/updi/files/upload";
*/

String get LOCALHOST_IP =>
  LOCALHOST_LAPTOP ? "192.168.42.139:8000" : "192.168.1.6:8000";

String get BASE_URL =>
  LOCALHOST_MODE ? "http://$LOCALHOST_IP" : "https://trdi.my";
  
String get API_BASE_URL =>
  LOCALHOST_MODE ? "$BASE_URL/api" : "https://api.trdi.my/api";

String get IMAGE_UPLOAD_URL =>
  LOCALHOST_MODE ? "$BASE_URL/files/upload" : "$BASE_URL/files/upload";

String get FILE_UPLOAD_URL =>
  LOCALHOST_MODE ? "$BASE_URL/files/upload" : "$BASE_URL/files/upload";

Drawer buildDrawer(BuildContext context) {
  return Drawer(
    elevation: 4,
    child: Column(
      children: <Widget>[
        Container(
          color: Colors.black,
          child: DrawerHeader(
            child:Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: <Widget>[
              ListTile(
                onTap: () => AppSettings.openAppSettings(),
                leading: Icon(Icons.notifications),
                title: Text("Notifications"),
              ),
              ListTile(
                onTap: () => Navigator.of(context).popAndPushNamed(ROUTE_ABOUT_SCREEN),
                leading: Icon(Icons.supervisor_account),
                title: Text("About Us"),
              ),
              ListTile(
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

AppBar buildAppBar(BuildContext context, {Post? share, List<Widget> actions = const []}) {
  final appBar = AppBar(
    backgroundColor: Colors.black54,
    //iconTheme: IconThemeData(color: Colors.black),
    centerTitle: true,
    title: SvgPicture.asset(
      "assets/images/trdi3.svg",
      height: kToolbarHeight,
      fit: BoxFit.cover,
    ),
    actions: [ 
      ...actions
    ],
  );

  return appBar;
}

Container get eventIcon {
  return Container(
    decoration: const BoxDecoration(
      color: Colors.deepOrangeAccent,
    ),
    margin: const EdgeInsets.only(right: 2),
    height: 4,
    width: 4,
  );
}

ThemeData get darkTheme {
  return ThemeData.dark().copyWith(
    primaryColor: Colors.teal,
    accentColor: Colors.deepPurpleAccent,
    textTheme: ThemeData.dark().textTheme.copyWith(
      display1: ThemeData.dark().textTheme.display1?.copyWith(
        color: Colors.white,
      )
    ),
  );
}
