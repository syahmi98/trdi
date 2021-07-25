import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../utils/enums.dart';
import '../../api/api_repository.dart';
import '../widgets/centered_circular_progress_indicator.dart';

class LiveScreen extends StatefulWidget {
  @override
  _LiveScreenState createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  UiState _uiState;
  String videoHtml;  

  @override
  void initState() {
    super.initState();
    _uiState = UiState.isLoading;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,

    ]).then((_) async {

      try {
        String html = (await ApiRepository().fetchLatestLiveVideo())["embed_html"];

        var size = window.physicalSize;

        print(size.width);
          
        String formattedHtml = "<iframe src=\"https://www.facebook.com/plugins/video.php?href=$html%2F&width=1920\" width=\"1920\" height=\"1080\"/>";

        setState(() {
          videoHtml = formattedHtml;
          _uiState = UiState.hasData;
        });

      } catch (error) {
        print(error);
        setState(() {
          _uiState = UiState.hasError;
        });
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text("An error occurred"),
            content: Text("An error has occurred, please try again"),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          ),
        
        ).then((_) {
          Navigator.of(context).pop();
        });
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    SystemChrome.setEnabledSystemUIOverlays([
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ]);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return Scaffold(
      backgroundColor: Colors.black,
      body: _uiState == UiState.hasError
        ? Container()
        : _uiState == UiState.isLoading
          ? CenteredCircularProgressIndicator()
          : Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: HtmlWidget(
                        videoHtml, 
                        bodyPadding: EdgeInsets.zero,
                        tableCellPadding: EdgeInsets.zero,
                        webView: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
    );
  }
}