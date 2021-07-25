import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../../utils/enums.dart';
import '../../providers/audio_handler.dart';
import '../../providers/posts.dart';
import '../../models/audio/audio.dart';
import '../../utils/utils.dart';
import '../widgets/audio_player_widget.dart';
import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/error_dialog.dart';


class AudioScreen extends StatefulWidget {
  @override
  _AudioScreenState createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  UiState _uiState;
  bool _hasLoaded = false;
  Audio audio;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!_hasLoaded) {
      loadData().then((_) {
        _hasLoaded = true;
      });
    }
  }

  Future<void> loadData() async {
    if(_uiState == UiState.isLoading) return;
    setState(() => _uiState = UiState.isLoading);

    try {
      String postSlug = ModalRoute.of(context).settings.arguments as String;

      audio = await Provider.of<Posts>(context, listen: false).getAudioBySlug(postSlug);
      
      setState(() => _uiState = UiState.hasData);
       
    } catch (error) {
      setState(() => _uiState = UiState.hasError);

    }
  }

  Widget buildErrorWidget() => ErrorDialog(
    onTap: () => Navigator.of(context).pop(),
  );
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: _uiState == UiState.hasError
        ? buildErrorWidget()
        : _uiState == UiState.isLoading
          ? CenteredCircularProgressIndicator()
          : AudioWidget(audio)
    );
  }
}

class AudioWidget extends StatefulWidget {
  final Audio _audio;

  AudioWidget(this._audio);

  @override
  _AudioWidgetState createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> with SingleTickerProviderStateMixin {
  AnimationController _sizeController;
  bool _bottomMediaPlayerShown = false;

  @override
  void initState() {
    super.initState();
    _sizeController = AnimationController(
      vsync: this,
      duration: AudioHandler.duration,
    );

    widget._audio.audios.sort((a, b) => a.order.compareTo(b.order));

    final provider = Provider.of<AudioHandler>(context, listen: false);

    if(provider.playerState == AudioPlayerState.PAUSED || provider.playerState == AudioPlayerState.PLAYING)
      _showBottomMediaPlayer();
  }

  void _closeBottomMediaPlayer() {
    if(_bottomMediaPlayerShown) {
      _sizeController.reverse();
      _bottomMediaPlayerShown = false;
    }
  }

  void _showBottomMediaPlayer() {
    if(!_bottomMediaPlayerShown) {
      _sizeController.forward();
      _bottomMediaPlayerShown = true;
    }
  }

  @override
  void dispose() {
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Audio audio = widget._audio;
    
    return Column(
      children: <Widget> [
        Expanded(
          child: Consumer<AudioHandler>(
            builder: (context, provider, child) {
              return CustomScrollView(
                slivers: <Widget>[
                  if(audio.imageUrl != null)
                    SliverToBoxAdapter(
                      child: CachedNetworkImage(
                        imageUrl: audio.imageUrl,
                        placeholder: (ctx, url) => CenteredCircularProgressIndicator(),
                      ),
                    ),
                  
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        audio.title,
                        style: Theme.of(context).textTheme.headline.copyWith(
                          fontWeight: FontWeight.w900
                        ),
                      ),
                    ),
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate.fixed(audio.audios.asMap().map((index, audioFile) {
                        return MapEntry(index, Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: provider.file.id == audioFile.id 
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,

                                  width: 2,
                                )
                              ),
                              child: ListTile(
                                onTap: () async {
                                  await Provider.of<AudioHandler>(context, listen: false).play(audio, audioFile);
                                },                      
                                title: Text(
                                  audioFile.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: provider.file.id == audioFile.id ? Theme.of(context).primaryColor : Colors.black
                                  ),
                                ),
                                trailing: audioFile.duration == null ? null : Text(
                                  Duration(microseconds: (audioFile.duration * 1000000).round()).toString().split(".").first.padLeft(7, "0"),
                                  style: Theme.of(context).textTheme.body1,
                                ),
                              ),
                            ),
                            if(index != audio.audios.length-1)
                              Divider(),
                          ],
                        ));
                      }).values.toList()),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 6),
                          if(audio.description != null)
                            Html(
                              data: audio.description,
                              showImages: true,
                              useRichText: true,
                              renderNewlines: true,
                              defaultTextStyle: TextStyle(
                                fontSize: 18
                              ),
                            ),

                          if(audio.content != null)
                            Html(
                              data: audio.content,
                              showImages: true,
                              useRichText: true,
                              renderNewlines: true,
                              defaultTextStyle: TextStyle(
                                fontSize: 18
                              ),
                            ),
                          
                          
                          SizedBox(height: 6),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Consumer<AudioHandler>(
          builder: (context, provider, child) {
            if(provider.playerState == null)
              _closeBottomMediaPlayer();

            else {
              switch(provider.playerState) {
                case AudioPlayerState.PAUSED:
                case AudioPlayerState.PLAYING:
                  _showBottomMediaPlayer();
                  break;
                case AudioPlayerState.STOPPED:
                case AudioPlayerState.COMPLETED:
                  _closeBottomMediaPlayer();
                  break;
              }
            }

            return child;
          },
          child: SizeTransition(
            sizeFactor: _sizeController,
            child: AudioPlayerWidget(),
          ),
        ),
      ],
    );
  }
}