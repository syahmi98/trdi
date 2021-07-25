import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../models/audio/audio.dart';
import '../../../../models/post/post.dart';
import '../../../../models/responses/response_posts/response_posts.dart';
import '../../../../providers/audio_handler.dart';
// import '../../../../providers/posts.dart';
import '../../../../utils/enums.dart';
import '../../../widgets/centered_circular_progress_indicator.dart';
import '../../../widgets/error_dialog.dart';
import '../../../widgets/audio_player_widget.dart';

class AudiosTab extends StatefulWidget {
  AudiosTab({key: Key}) : super(key: key);

  @override
  _AudiosTabState createState() => _AudiosTabState();
}

class _AudiosTabState extends State<AudiosTab> {
  ScrollController _scrollController = ScrollController();
  late ResponsePosts _responsePosts;
  List<Post> _posts = [];
  late Post _selectedPost;
  late UiState _uiState;
  bool _postCoversPage = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData({nextPage: false}) async {
    var rawData = _getRawData();

    List<Post> _posts = rawData.map((post) {
      post['meta_description'] = 'example';
      post['keywords'] = 'example';
      return Post.fromJson(post);
    }).toList();
    
    _selectedPost = _posts[0];
      
  }

  void _selectPost(Post post) {
    if (_selectedPost == post) return;
    if (mounted) setState(() => _selectedPost = post);

    print(_selectedPost.slug);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDataWidget();
  }

  Widget _buildDataWidget() {
    final mediaQuery = MediaQuery.of(context);

    return Column(
      children: <Widget>[
        Expanded(
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    SizedBox(height: mediaQuery.size.height * 0.01),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: mediaQuery.size.height * 0.18),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ListView.separated(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) =>
                                VerticalDivider(width: 0),
                            itemCount: _posts.length,
                            itemBuilder: (context, index) {
                              Post post = _posts[index];
                              return Material(
                                type: MaterialType.transparency,
                                child: InkWell(
                                  onTap: () => _selectPost(post),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    width: mediaQuery.size.width / 5,
                                    child: Column(
                                      children: <Widget>[
                                        Card(
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            side: _selectedPost == post
                                                ? BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    width: 2.0)
                                                : BorderSide.none,
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: (kIsWeb)
                                              ? Image.asset('images/a6a92fcdb79652f9764b30d238a4b267.jpeg')
                                              : CachedNetworkImage(
                                                imageUrl: post.imageUrl ?? "",
                                                fit: BoxFit.cover,
                                                height: mediaQuery.size.width / 6,
                                                width: mediaQuery.size.width / 6,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: LayoutBuilder(
                                              builder: (context, constraints) {
                                                return Text(
                                                  post.title,
                                                  maxLines:
                                                      (constraints.maxHeight /
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .fontSize!)
                                                          .floor(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .body2!
                                                      .copyWith(
                                                          color: _selectedPost ==
                                                                  post
                                                              ? Theme.of(
                                                                      context)
                                                                  .primaryColor
                                                              : Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .body2!
                                                                  .color),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                );
                                              },
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )),
                    ),
                    SizedBox(height: mediaQuery.size.height * 0.1),
                  ],
                ),
              ),
              NotificationListener<DraggableScrollableNotification>(
                onNotification: (notification) {
                  if (notification.extent < notification.maxExtent &&
                      !_postCoversPage) return false;

                  if (notification.extent >= notification.maxExtent) {
                    setState(() => _postCoversPage = true);
                  } else {
                    setState(() => _postCoversPage = false);
                  }

                  return false;
                },
                child: DraggableScrollableSheet(
                  expand: true,
                  maxChildSize: 1,
                  initialChildSize: 0.75,
                  minChildSize: 0.75,
                  builder: (context, controller) => Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: _postCoversPage
                            ? null
                            : BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12)),
                        boxShadow: [
                          if (!_postCoversPage)
                            BoxShadow(
                              blurRadius: 15,
                            )
                        ]),
                    child: AudioScreen(
                        scrollController: controller,
                        key: ValueKey(_selectedPost.id),
                        slug: _selectedPost.slug),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Map<String, Object>> _getRawData() {
    return [
      {
        "id": 7649,
        "slug": "rasmi-kerajaan",
        "title": "Rasmi Kerajaan",
        "name_file": "c174a3595e0b219af697378df18b13b4",
        "extension_file": "jpg",
        "visiblity_date_seconds": 1595304540,
        "created_by": "Mohd Saiful Iqbal Azib",
        "view": 1427
      },
      {
        "id": 6925,
        "slug": "nasyeed",
        "title": "Nasyeed",
        "name_file": "a6a92fcdb79652f9764b30d238a4b267",
        "extension_file": "jpg",
        "visiblity_date_seconds": 1588262880,
        "created_by": "Mr Syed Halim",
        "view": 981
      }
    ];
  }
}

class AudioScreen extends StatefulWidget {
  const AudioScreen(
      {key = Key, required this.scrollController, required this.slug})
      : super(key: key);

  final ScrollController scrollController;
  final String slug;

  @override
  _AudioScreenState createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _sizeController;
  late UiState _uiState;
  late Audio audio;

  bool _bottomMediaPlayerShown = false;

  @override
  void initState() {
    super.initState();

    _sizeController = AnimationController(
      vsync: this,
      duration: AudioHandler.duration,
    );

    final provider = Provider.of<AudioHandler>(context, listen: false);

    if (provider.playerState == PlayerState.PAUSED ||
        provider.playerState == PlayerState.PLAYING)
      _showBottomMediaPlayer(override: true);
  }

  @override
  void dispose() {
    _sizeController.dispose();
    super.dispose();
  }

  void _closeBottomMediaPlayer() {
    if (_bottomMediaPlayerShown) {
      _sizeController.reverse();
      _bottomMediaPlayerShown = false;
    }
  }

  void _showBottomMediaPlayer({bool override = false}) {
    if (!_bottomMediaPlayerShown) {
      if (override)
        _sizeController.value = 1;
      else
        _sizeController.forward();

      _bottomMediaPlayerShown = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: AudioWidget(audio, widget.scrollController),
        ),
        Consumer<AudioHandler>(
          builder: (context, provider, child) {
            if (provider.playerState == null)
              _closeBottomMediaPlayer();
            else {
              switch (provider.playerState) {
                case PlayerState.PAUSED:
                case PlayerState.PLAYING:
                  _showBottomMediaPlayer();
                  break;
                case PlayerState.STOPPED:
                case PlayerState.COMPLETED:
                  _closeBottomMediaPlayer();
                  break;
              }
            }

            return child!;
          },
          child: SizeTransition(
            sizeFactor: CurvedAnimation(
              curve: Curves.easeInOutExpo,
              parent: _sizeController,
            ),
            child: AudioPlayerWidget(),
          ),
        ),
      ],
    );
  }

}

class AudioWidget extends StatefulWidget {
  AudioWidget(this._audio, this.controller);

  final ScrollController controller;
  final Audio _audio;

  @override
  _AudioWidgetState createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  @override
  void initState() {
    super.initState();
    widget._audio.audios.sort((a, b) => a.order.compareTo(b.order));
  }

  @override
  Widget build(BuildContext context) {
    Audio audio = widget._audio;

    return Consumer<AudioHandler>(
      builder: (context, provider, child) {
        return CustomScrollView(
          controller: widget.controller,
          slivers: <Widget>[
            SliverPadding(padding: const EdgeInsets.only(top: 16)),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  audio.title,
                  style: Theme.of(context)
                      .textTheme
                      .subhead!
                      .copyWith(fontWeight: FontWeight.w900),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.only(left: 12, bottom: 12),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.date_range,
                      size: Theme.of(context).textTheme.body1!.fontSize,
                      color: Theme.of(context)
                          .textTheme
                          .body1!
                          .color!
                          .withOpacity(.45),
                    ),
                    SizedBox(width: 6),
                    Text(
                      audio.formattedDate,
                      style: TextStyle(
                        color: Theme.of(context)
                            .textTheme
                            .body1!
                            .color!
                            .withOpacity(.45), //Colors.black45,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(
                      Icons.person,
                      size: Theme.of(context).textTheme.body1!.fontSize,
                      color: Theme.of(context)
                          .textTheme
                          .body1!
                          .color!
                          .withOpacity(.45),
                    ),
                    SizedBox(width: 6),
                    Text(
                      audio.author,
                      style: TextStyle(
                        color: Theme.of(context)
                            .textTheme
                            .body1!
                            .color!
                            .withOpacity(.45), //Colors.black45,
                      ),
                    ),
                    SizedBox(width: 2),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverList(
                delegate: SliverChildListDelegate.fixed(audio.audios
                    .asMap()
                    .map((index, audioFile) {
                      return MapEntry(
                          index,
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                  color: provider.file.id == audioFile.id
                                      ? Theme.of(context).primaryColor
                                      : Colors.black,
                                  width: 2,
                                )),
                                child: ListTile(
                                  onTap: () async {
                                    await Provider.of<AudioHandler>(context,
                                            listen: false)
                                        .play(audio, audioFile);
                                  },
                                  title: Text(
                                    audioFile.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: provider.file.id == audioFile.id
                                            ? Theme.of(context).primaryColor
                                            : Colors.black),
                                  ),
                                  trailing: audioFile.duration == null
                                      ? null
                                      : Text(
                                          Duration(
                                                  microseconds:
                                                      (audioFile.duration *
                                                              1000000)
                                                          .round())
                                              .toString()
                                              .split(".")
                                              .first
                                              .padLeft(7, "0"),
                                          style:
                                              Theme.of(context).textTheme.body1,
                                        ),
                                ),
                              ),
                              if (index != audio.audios.length - 1) Divider(),
                            ],
                          ));
                    })
                    .values
                    .toList()),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 6),
                    if (audio.description != null)
                      Html(
                        data: audio.description,
                        // showImages: true,
                        // useRichText: true,
                        // renderNewlines: true,
                        // style: TextStyle(
                        //   fontSize: 16
                        // ),
                      ),
                    if (audio.content != null)
                      Html(
                        data: audio.content,
                        // showImages: true,
                        // useRichText: true,
                        // renderNewlines: true,
                        // style: TextStyle(
                        //   fontSize: 16
                        // ),
                      ),
                    SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
