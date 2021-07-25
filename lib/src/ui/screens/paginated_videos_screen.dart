import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/post/post.dart';
import '../../models/responses/response_videos/response_videos.dart';
import '../../providers/videos.dart';
import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/error_dialog.dart';
import '../../utils/enums.dart';
import '../../utils/utils.dart';

class PaginatedVideoScreen extends StatefulWidget {
  @override
  _PaginatedVideoScreenState createState() => _PaginatedVideoScreenState();
}

class _PaginatedVideoScreenState extends State<PaginatedVideoScreen> {
  ScrollController _scrollController;
  ResponseVideos _responseVideos;
  String _categorySlug;
  UiState _uiState;
  bool _hasLoaded = false;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(() {
      if(_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        if(_uiState != UiState.isLoading && _responseVideos.meta.currentPage != _responseVideos.meta.lastPage) {
          loadData(nextPage: true);
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    if(!_hasLoaded) {
      loadData().then((_) => 
        _hasLoaded = true
      );
    }
    
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  Future<void> loadData({nextPage: false}) async {
    if(_uiState == UiState.isLoading) return;

    if(nextPage == true) {
      if(_responseVideos == null) return;
      if(_responseVideos.links.next == null) return;
    }

    _categorySlug = ModalRoute.of(context).settings.arguments;
    final provider = Provider.of<Videos>(context, listen: false);

    if(!nextPage && provider.isVideosLoadedForCategory(slug: _categorySlug)) return;

    setState(() => _uiState = UiState.isLoading);
      

    try {
      _responseVideos = await provider.loadPaginatedVideos(_categorySlug, nextPage: nextPage);
      setState(() => _uiState = UiState.hasData);

    } catch (error) {
      setState(() =>_uiState = UiState.hasError);
    }
  }

  Widget _buildErrorScreen() {
    return ErrorDialog(
      onTap: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: _uiState == UiState.hasError
        ? _buildErrorScreen()
        : _buildDataScreen(),
    );
  }

  Widget _buildDataScreen() {
    return Consumer<Videos>(
      builder: (context, provider, child) {
        final posts = provider.getLoadedVideosOfCategory(_categorySlug);

        return Column(
          children: <Widget>[
            if(posts.length != 0)
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  controller: _scrollController,
                  itemCount: posts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3/4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (ctx, i) {
                    Post post = posts[i];
                    return GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(ROUTE_VIDEO_SCREEN, arguments: post.slug),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: post.imageUrl == null ? "" : post.imageUrl,
                                  placeholder: (ctx, url) => CenteredCircularProgressIndicator(),
                                  fit: BoxFit.cover,
                                  width: double.maxFinite,
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  //color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  )
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      post.title,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                    Spacer(),
                                    Text(
                                      post.formattedDate,
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.body1.color.withOpacity(.45), //Colors.black45
                                      ),
                                    )
                                  ]
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            
            if(_uiState == UiState.isLoading)
              if(posts.length == 0)
                Expanded(child: CenteredCircularProgressIndicator(),)
              else
                CenteredCircularProgressIndicator(),
          ],
        );
      }
    );
  }


}