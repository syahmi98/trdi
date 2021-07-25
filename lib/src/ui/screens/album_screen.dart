import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/customized_shimmers.dart';
import '../widgets/error_dialog.dart';
import '../../models/post/post.dart';
import '../../models/responses/response_posts/response_posts.dart';
import '../../utils/utils.dart';
import '../../providers/albums.dart';
import '../../utils/enums.dart';
import 'gallery_screen.dart';

class AlbumScreen extends StatefulWidget {
  static const route = "/album-screen";

  AlbumScreen({Key? key}) : super(key: key);

  @override
  _AlbumScreenState createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  ScrollController _scrollController = ScrollController();
  late ResponsePosts _responsePosts;
  late UiState _uiState;

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

    final provider = Provider.of<Albums>(context, listen: false);

    try {
      if(nextPage)
        await provider.loadNextPage();
      else {
        if(!provider.hasLoaded)
          await provider.loadData();
      }

      _responsePosts = provider.responsePost;

      if(mounted)
        setState(() => _uiState = UiState.hasData);


    } catch (error) {
      if(mounted)
        setState(() => _uiState = UiState.hasError);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildErrorWidget() => ErrorDialog(
    onTap: () => Navigator.of(context).pop(),
  );

  Widget _buildLoadingWidget() {
    final mediaQuery = MediaQuery.of(context);
    return ListView.separated(
      itemCount: 10,
      padding: const EdgeInsets.all(16),
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        return CustomizedShimmers(
          child: AspectRatio(
            aspectRatio: 1.5,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Container(
                      height: 20,
                      width: mediaQuery.size.width * 0.3,
                      color: Colors.white,
                    ),
                    Spacer(),
                    Container(
                      height: 20,
                      width: mediaQuery.size.width * 0.3,
                      color: Colors.white,
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              "Lensa TRDI",
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Expanded(
            child: _uiState == UiState.hasError
              ? _buildErrorWidget()
              : _buildDataWidget(),
          )
        ],
      ),
    );
  }

  Widget _buildDataWidget() {
    var mediaQuery = MediaQuery.of(context);

    return Consumer<Albums>(
      builder: (context, provider, child) {
        final _posts = provider.albums;
        return Column(
          children: <Widget>[
            if(_posts.length != 0)
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  separatorBuilder: (context, index) => Divider(), 
                  itemCount: _posts.length,
                  itemBuilder: (context, index) {
                    Post album = _posts[index];

                    return AspectRatio(
                      aspectRatio: 1.5,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 4,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Stack(
                                  children: <Widget>[
                                    GridTile(
                                      child: album.imageUrl == null 
                                        ? Container() 
                                        : (kIsWeb) 
                                          ? Image.asset('images/20210717201740_233e2dfae3b67847fc8ce21845a138ce.jpeg')
                                          : CachedNetworkImage(
                                              imageUrl: album.imageUrl ?? '',
                                              placeholder: (ctx, url) => CenteredCircularProgressIndicator(),
                                              fit: BoxFit.cover
                                            ),
                                      footer: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black87,
                                              Colors.black12,
                                              Colors.grey.withOpacity(0),
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            stops: [
                                              0.5,
                                              0.9,
                                              1
                                            ]
                                          )
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        child: Text(
                                          "${album.title}",
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.body2!.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Material(
                                      type: MaterialType.transparency,
                                      child: InkWell(
                                        onTap: () => Navigator.of(context).pushNamed(
                                          GalleryScreen.route,
                                          arguments: album.slug
                                        )
                                      )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 3),
                          Row(
                            children: <Widget>[
                              SizedBox(width: 2),
                              Icon(
                                Icons.date_range,
                                color: Theme.of(context).textTheme.body1!.color!.withOpacity(.45),
                              ),
                              SizedBox(width: 6),
                              Text(
                                album.formattedDate,
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.body1!.color!.withOpacity(.45), //Colors.black45,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.person,
                                color: Theme.of(context).textTheme.body1!.color!.withOpacity(.45),
                              ),
                              SizedBox(width: 6),
                              Text(
                                album.author,
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.body1!.color!.withOpacity(.45), //Colors.black45,
                                ),
                              ),
                              SizedBox(width: 2),
                            ],
                          ),
                        ],
                      )
                    );

                  }, 
                ),
              ),

            if(_uiState == UiState.isLoading)
              if(_posts.length == 0)
                  Expanded(child: _buildLoadingWidget())
              else
                CenteredCircularProgressIndicator()

          ],
        );
      },
    );
  }
}