import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/customized_shimmers.dart';
import '../widgets/error_dialog.dart';
import '../../models/video/video.dart';
import '../../providers/videos.dart';
import '../../utils/enums.dart';
import '../../utils/utils.dart';

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  YoutubePlayerController _youtubeController;

  bool _isReady = false;
  int _volume = 100;

  Video _videoArticle;
  UiState _uiState;
  bool _hasLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!_hasLoaded) {
      loadVideoArticle().then((_) {
        _hasLoaded = true;
      });
    }
  }

  Future<void> loadVideoArticle() async {
    if(_uiState == UiState.isLoading) return;
    setState(() => _uiState = UiState.isLoading);

    try {
      String slug = ModalRoute.of(context).settings.arguments as String;
      final response = await Provider.of<Videos>(context, listen: false).fetchVideoBySlug(slug);
      _videoArticle = response;

      final uri = Uri.parse(_videoArticle.link);

      _youtubeController = YoutubePlayerController(
        initialVideoId: uri.pathSegments.last,
      );


      setState(() => _uiState = UiState.hasData);

    } catch(error) {
      print(error);
      setState(() => _uiState = UiState.hasError);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildErrorScreen() {
    return ErrorDialog(
      onTap: () => Navigator.of(context).pop(),
    );
  }

  Widget _buildLoadingScreen() {
    return  CustomizedShimmers(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16/9,
              child: Container(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 18,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 20,
                    width: 150,
                    color: Colors.white,
                  ),

                  const SizedBox(height: 12,),

                  Container(
                    height: 40,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12,),

                  Container(
                    height: 20,
                    width: 100,
                    color: Colors.white,
                  ),

                  const SizedBox(height: 12,),

                  Divider(),

                  ...List<Widget>.generate(5, (_) {
                    return Container(
                      color: Colors.white,
                      height: 20,
                    );
                  }),                  

                  const SizedBox(height: 12,),
  
                  ...List<Widget>.generate(5, (_) {
                    return Container(
                      color: Colors.white,
                      height: 20,
                    );
                  }),                  

                  const SizedBox(height: 12,),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, share: _videoArticle),
      body: _uiState == UiState.hasError
        ? _buildErrorScreen()
        : _uiState == UiState.isLoading
          ? _buildLoadingScreen()
          : _buildDataScreen(),
    );
  }
  
  Widget _buildDataScreen() {
    return ListView(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 16/9,
          child: Stack(
            children: <Widget>[
              YoutubePlayer(
                controller: _youtubeController,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.amber,
                progressColors: ProgressBarColors(
                  playedColor: Theme.of(context).primaryColor,
                  handleColor: Theme.of(context).accentColor,
                  bufferedColor: Theme.of(context).primaryColorDark
                ),
                onReady: () {
                  setState(() {
                    _isReady = true;
                    _youtubeController.setVolume(_volume);
                    _youtubeController.play();
                  });
                },
              ),
              if(!_isReady)
                Container(
                  color: Theme.of(context).canvasColor,
                  child: CenteredCircularProgressIndicator(),
                ),
            ],  
          ),
        ),

        const SizedBox(height: 18,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _videoArticle.author,
                style: Theme.of(context).textTheme.body2
              ),

              const SizedBox(height: 12,),

              Text(
                _videoArticle.title,
                style: Theme.of(context).textTheme.headline.copyWith(
                  fontFamily: FONT_MONTSERRAT,
                  fontWeight: FontWeight.w800,
                ),
              ),
              
              const SizedBox(height: 12,),

              Text(_videoArticle.formattedDate),

              const SizedBox(height: 12,),

              Divider(),
              
              if(_videoArticle.description != null)
                Html(
                  data: _videoArticle.description,
                  showImages: true,
                  useRichText: true,
                  renderNewlines: true,
                  defaultTextStyle: TextStyle(
                    fontSize: 15,
                    fontFamily: FONT_MONTSERRAT,
                    fontWeight: FontWeight.w500,
                  ),
                ),

              if(_videoArticle.description != null)
                const SizedBox(height: 12,),

              if(_videoArticle.content != null)
                Html(
                  data: _videoArticle.content,
                  showImages: true,
                  useRichText: true,
                  renderNewlines: true,
                  defaultTextStyle: TextStyle(
                    fontSize: 15,
                    fontFamily: FONT_MONTSERRAT,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
              const SizedBox(height: 12,),
            ],
          ),
        ),
      ],
    );
  }
}