import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/enums.dart';
import '../../models/post/post.dart';
import '../../models/responses/response_posts/response_posts.dart';
import '../../providers/posts.dart';
import '../../utils/utils.dart';
import '../widgets/centered_circular_progress_indicator.dart';

class PaginatedArticlesScreen extends StatefulWidget {

  @override
  _PaginatedArticlesScreenState createState() => _PaginatedArticlesScreenState();
}

class _PaginatedArticlesScreenState extends State<PaginatedArticlesScreen> {
  ScrollController _scrollController = ScrollController();
  ResponsePosts _responsePosts;
  List<Post> _posts = [];
  UiState _uiState;
  bool _hasLoaded = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if(_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        if(_uiState != UiState.isLoading && _responsePosts.meta.currentPage != _responsePosts.meta.lastPage) {
          _loadMorePosts(context);
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!_hasLoaded) {
      _loadData().then((_) => _hasLoaded = true);
    }
  }

  Future<void> _loadData() async {
    if(_uiState == UiState.isLoading) return;
    setState(() => _uiState = UiState.isLoading);    
    try {
      String categorySlug = ModalRoute.of(context).settings.arguments;

      var response;

      if(categorySlug == null)
        response = await Provider.of<Posts>(context, listen: false).getLatestArticlePosts();
      else
        response = await Provider.of<Posts>(context, listen: false).getLatestArticlePostsByCategory(categorySlug);

      _responsePosts = response;
      _posts.addAll(response.posts);

      setState(() => _uiState = UiState.hasData);

    } catch (error) {
      print(error);
      setState(() => _uiState = UiState.hasError);
    }

  }

  void _loadMorePosts(BuildContext context) async {
    if(_responsePosts.links.next == null) return;
    if(_uiState == UiState.isLoading) return;
    
    setState(() => _uiState = UiState.isLoading);

    try {
      _responsePosts = await Provider.of<Posts>(context, listen: false).getNextPagePosts(_responsePosts);
      _posts.addAll(_responsePosts.posts);

      setState(() => _uiState = UiState.hasData);

    } catch (error) {
      _uiState = UiState.hasError;

    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        children: <Widget>[
          if(_posts.length != 0)
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  controller: _scrollController,
                  itemCount: _posts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3/4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (ctx, i) {
                    Post post = _posts[i];
                    return GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(ROUTE_ARTICLE_SCREEN, arguments: post.slug),
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
                                  imageUrl: post.imageUrl ?? "",
                                  placeholder: (ctx, url) => CenteredCircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        const Icon(Icons.error, size: 45),
                                        const SizedBox(height: 2),
                                        const Text("No Image")
                                      ],
                                    ),
                                  ),
                                  fit: BoxFit.cover,
                                  width: double.maxFinite,
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  )
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: LayoutBuilder(
                                        builder: (context, constraint) {
                                          return Text(
                                            "${post.title}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: (constraint.maxHeight / Theme.of(context).textTheme.body2.fontSize).floor(),
                                            style: Theme.of(context).textTheme.body2,
                                          );
                                        }
                                      ),
                                    ),
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
            ),

          if(_uiState == UiState.isLoading)
            if(_posts.length == 0) 
              Expanded(
                child: CenteredCircularProgressIndicator(),
              )
            else
              CenteredCircularProgressIndicator(),
        ],
      ),
    );
  }
}