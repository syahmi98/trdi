import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../models/audio/audio.dart';
import '../../../../models/post/post.dart';
import '../../../../models/responses/response_posts/response_posts.dart';
import '../../../../providers/audio_handler.dart';
import '../../../../providers/posts.dart';
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
  ScrollController _scrollController;
  ResponsePosts _responsePosts;
  List<Post> _posts = [];
  Post _selectedPost;
  UiState _uiState;

  @override
  void initState() {
    super.initState();

    loadData();

    _scrollController = ScrollController()..addListener(() {
      if(_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        if(_uiState != UiState.isLoading && _responsePosts.meta.currentPage != _responsePosts.meta.lastPage) {
          if(mounted)
            loadData(nextPage: true);
        }
      }
    });
  }

  Future<void> loadData({nextPage: false}) async {
    if(_uiState == UiState.isLoading) return;
    if(nextPage == true && (_responsePosts == null || _responsePosts.links.next == null)) return;

    if(mounted)
      setState(() => _uiState = UiState.isLoading);

    try {
      var response;

      if(nextPage)
        response = await Provider.of<Posts>(context, listen: false).getNextPagePosts(_responsePosts);
      else
        response = await Provider.of<Posts>(context, listen: false).getLatestAudioPosts();

      _responsePosts = response;
      _posts.addAll(response.posts);

      if(_selectedPost == null)
        _selectedPost = _posts[0];

      if(mounted)
        setState(() => _uiState = UiState.hasData);

    } catch (error) {
      if(mounted)
        setState(() => _uiState = UiState.hasError);
    }
  }

  void _selectPost(Post post) {
    if(_selectedPost == post) return;
    
    if(mounted)
      setState(() => _selectedPost = post);

      print(_selectedPost.slug);
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  Widget _buildErrorWidget() => ErrorDialog(
    buttonText: "Cuba Semula",
    onTap: () => loadData(),
  );

  Widget _buildLoadingWidget() {
    return CenteredCircularProgressIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return _uiState == UiState.hasError
      ? _buildErrorWidget()
      : _uiState == UiState.isLoading
        ? _buildLoadingWidget()
        : _buildDataWidget();
  }

  Widget _buildDataWidget() {
    final mediaQuery = MediaQuery.of(context);

    return Column(
      children: <Widget>[
        SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: AspectRatio(
            aspectRatio: 2.8,
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => VerticalDivider(),
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                Post post = _posts[index];
                return Material(
                  child: InkWell(
                    onTap: () => _selectPost(post),
                    child: Container(
                      width: mediaQuery.size.width/5,
                      child: Column(
                        children: <Widget>[
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: _selectedPost == post ? BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0
                              ) : BorderSide.none,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: post.imageUrl ?? "",
                                fit: BoxFit.cover,
                                height: mediaQuery.size.width/6,
                                width: mediaQuery.size.width/6,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Text(
                                  post.title,
                                  maxLines: (constraints.maxHeight / Theme.of(context).textTheme.body2.fontSize).floor(),
                                  style: Theme.of(context).textTheme.body2.copyWith(
                                    color: _selectedPost == post 
                                      ? Theme.of(context).primaryColor 
                                      : Theme.of(context).textTheme.body2.color
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                );
                              },
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }, 
            )
          ),
        ),
        SizedBox(height: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12)
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 15,
                )
              ]
            ),
            child: AudioScreen(
              key: ValueKey(_selectedPost.id),
              slug: _selectedPost.slug
            ),
          ),
        ),
      ],
    );
  }
}

class AudioScreen extends StatefulWidget {
  const AudioScreen({
    key: Key,
    @required this.slug
  }) : super(key: key);
  final String slug;

  @override
  _AudioScreenState createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  UiState _uiState;
  Audio audio;

  @override
  void initState() {
    super.initState();

    loadData();

  }

  Future<void> loadData() async {
    if(_uiState == UiState.isLoading) return;
    
    if(mounted)
      setState(() => _uiState = UiState.isLoading);

    try {
      audio = await Provider.of<Posts>(context, listen: false).getAudioBySlug(widget.slug);

      if(mounted)
        setState(() => _uiState = UiState.hasData);

    } catch (error) {

      if(mounted)
        setState(() => _uiState = UiState.hasError);

    }
  }

  Widget buildErrorWidget() => ErrorDialog(
    buttonText: "Cuba Semula",
    onTap: loadData,
  );


  @override
  Widget build(BuildContext context) {
    return _uiState == UiState.hasError
      ? buildErrorWidget()
      : _uiState == UiState.isLoading
        ? buildLoadingWidget()
        : AudioWidget(audio);
  }

  Widget buildLoadingWidget() {
    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.white,
                height: 25,
                width: mediaQuery.size.width * 0.6,
              ),
              SizedBox(height: 6),
              Container(
                color: Colors.white,
                height: 15,
                width: mediaQuery.size.width * 0.3,
              ),
              SizedBox(height: 6),
              ...List<Widget>.generate(6, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
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
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        audio.title,
                        style: Theme.of(context).textTheme.subhead.copyWith(
                          fontWeight: FontWeight.w900
                        ),
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
                            size: Theme.of(context).textTheme.body1.fontSize,
                            color: Theme.of(context).textTheme.body1.color.withOpacity(.45),
                          ),
                          SizedBox(width: 6),
                          Text(
                            audio.formattedDate,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.body1.color.withOpacity(.45), //Colors.black45,
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(
                            Icons.person,
                            size: Theme.of(context).textTheme.body1.fontSize,
                            color: Theme.of(context).textTheme.body1.color.withOpacity(.45),
                          ),
                          SizedBox(width: 6),
                          Text(
                            audio.author,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.body1.color.withOpacity(.45), //Colors.black45,
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
                      delegate: SliverChildListDelegate.fixed(audio.audios.asMap().map((index, audioFile) {
                        return MapEntry(index, Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: provider.file?.id == audioFile.id 
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
                                    fontWeight: FontWeight.w500,
                                    color: provider.file?.id == audioFile.id
                                      ? Theme.of(context).primaryColor
                                      : Colors.black
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
                                fontSize: 16
                              ),
                            ),

                          if(audio.content != null)
                            Html(
                              data: audio.content,
                              showImages: true,
                              useRichText: true,
                              renderNewlines: true,
                              defaultTextStyle: TextStyle(
                                fontSize: 16
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