import 'dart:async';

import '../../providers/audio_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AudioPlayerWidget extends StatefulWidget {
  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Consumer<AudioHandler>(
      builder: (context, provider, child) {
        final player = provider.player;
        final currentAudio = provider.audio;
        final currentlyPlayingFile = provider.file;

        if(currentAudio == null || currentlyPlayingFile == null)
          return Container();

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          color: Colors.black87,
          child: ListTile(
            dense: true,
            leading: CachedNetworkImage(
              imageUrl: currentAudio.imageUrl!,
              height: mediaQuery.size.width * 0.12,
              width:  mediaQuery.size.width * 0.12,
              fit: BoxFit.contain,
            ),
            title: Row(
              children: <Widget>[
                Expanded(
                  child: AudioSlider(),
                ),
                StreamBuilder<Duration>(
                  stream: player.onDurationChanged,
                  builder: (context, snapshot) {
                    if (snapshot.data == null)
                      return Container(
                        height: 0,
                        width: 0,
                      );

                    final duration = snapshot.data;

                    return StreamBuilder<Duration>(
                      stream: player.onAudioPositionChanged,
                      builder: (context, snapshot) {
                        if(snapshot.data == null)
                          return Container(
                            height: 0,
                            width: 0,
                          );
                        
                        final position = snapshot.data;

                        return Text(
                          "${Duration(seconds: duration!.inSeconds-position!.inSeconds).toString().split(".").first.padLeft(7, "0")}",
                          style: TextStyle(color: Colors.white70),
                        );

                      },
                    );
                  },
                ),
              ],
            ),
            /*title: Row(
              children: [
                Expanded(
                  child: Text(
                    currentlyPlayingFile.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ThemeData.dark().textTheme.body2.copyWith(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                
                StreamBuilder<Duration>(
                  stream: player.onDurationChanged,
                  builder: (context, snapshot) {
                    if (snapshot.data == null)
                      return Container(
                        height: 0,
                        width: 0,
                      );

                    final duration = snapshot.data;

                    return StreamBuilder<Duration>(
                      stream: player.onAudioPositionChanged,
                      builder: (context, snapshot) {
                        if(snapshot.data == null)
                          return Container(
                            height: 0,
                            width: 0,
                          );
                        
                        final position = snapshot.data;

                        return Text(
                          "${Duration(seconds: duration.inSeconds-position.inSeconds).toString().split(".").first.padLeft(7, "0")}",
                          style: TextStyle(color: Colors.white70),
                        );

                      },
                    );
                  },
                ),
              ],
            ), */
            //subtitle: AudioSlider(),
            trailing: provider.playerState == PlayerState.PLAYING 
              ? IconButton(
                  icon: Icon(
                    Icons.pause,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () => provider.pause(),
                )

              : IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () => provider.resume(),
              ),
          ),
        );
      },
    );
  }
}

class AudioSlider extends StatefulWidget {
  @override
  _AudioSliderState createState() => _AudioSliderState();
}

class _AudioSliderState extends State<AudioSlider> {
  double max = 0, current = 0;
  late StreamSubscription positionSubscription, durationSubscription;

  @override
  void initState() {
    super.initState();

    durationSubscription = Provider.of<AudioHandler>(context, listen: false).player.onDurationChanged.listen((value) {
      max = value.inSeconds.roundToDouble();
      setState(() {});
    });

    positionSubscription = Provider.of<AudioHandler>(context, listen: false).player.onAudioPositionChanged.listen((value) {
      current = value.inSeconds.roundToDouble();
      setState(() {});
    });

  }

  @override
  void dispose() {
    positionSubscription.cancel();
    durationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioHandler>(
      builder: (context, provider, child) {
        return Slider(
          value: current > max ? 0.0 : current,
          max: max,
          min: 0.0,
          onChanged: (value) {
            current = value;
          },
          onChangeEnd: (value) {
            provider.player.seek(Duration(seconds: value.toInt()));
          },
        );
      }
    );
  }
}