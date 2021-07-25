// import 'package:trdi/src/ui/screens/home/tabs/albums_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trdi/src/ui/screens/home/tabs/albums_tab.dart';
import 'package:trdi/src/ui/screens/home/tabs/audios_tab.dart';
import 'package:trdi/src/ui/screens/home/tabs/magazines_tab.dart';

import '../../../utils/utils.dart';
// import '../calendar_screen.dart';
import './tabs/articles_tab.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageStorageBucket _bucket = PageStorageBucket();

  final List<Map<String, dynamic>> _pages = [
    {
      "page": const ArticlesTab(key: PageStorageKey("Articles")),
      "title": "Article",
      "icon": Icons.radio_button_checked
    }, {
      "page": AlbumsTab(key: const PageStorageKey("Album")),
      "title": "Album",
      "icon": Icons.photo_library
    }, {
      "page": AudiosTab(key: const PageStorageKey("Audios")),
      "title": "Audio",
      "icon": Icons.audiotrack
    }, {
      "page": const MagazinesTab(key: PageStorageKey("Magazine")),
      "title": "Magazine",
      "icon": Icons.book
    }
  ];

  int _selectedPageIndex = 0;

  void _selectedPage(int index) async {
    if (index == _selectedPageIndex) return;

    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      drawer: buildDrawer(context),
      appBar: buildAppBar(context, actions: [
        //_buildLiveFlatButton(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.date_range),
          tooltip: "Events",
        ),
      ]),
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageStorage(
              child: _pages[_selectedPageIndex]["page"],
              bucket: _bucket,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedPageIndex,
          onTap: _selectedPage,
          items: _pages.map((page) {
            return _buildNavigationBarItem(
                iconData: page["icon"], title: page["title"]);
          }).toList()),
    ));
  }

  BottomNavigationBarItem _buildNavigationBarItem(
      {required IconData iconData, required String title}) {
    return BottomNavigationBarItem(
        icon: Icon(iconData), label: title);
  }
}
