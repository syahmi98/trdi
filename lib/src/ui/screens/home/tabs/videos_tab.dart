import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../providers/videos.dart';
import '../../../widgets/card_information_widget.dart';
import '../../../widgets/error_dialog.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/utils.dart';


class VideosTab extends StatefulWidget {
  VideosTab({Key key}) : super(key: key);
  
  @override
  _VideosTabState createState() => _VideosTabState();
}

class _VideosTabState extends State<VideosTab> with AutomaticKeepAliveClientMixin {
  final _maximumVideosToShow = 8;
  final _viewPortFraction = 1.0;
  Map<int, PageController> _pageControllers = {};
  UiState _uiState;
  bool _hasFormatExceptionError = false;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  @override
  void dispose() {
    _pageControllers.forEach((id, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> loadData({bool reload = false}) async {
    if(_uiState == UiState.isLoading && !_hasFormatExceptionError) return;
    setState(() => _uiState = UiState.isLoading);

    final provider = Provider.of<Videos>(context, listen: false);

    try {
      if(reload || !provider.hasLoaded) {
        await provider.loadVideoScreenData();
      }

      setState(() => _uiState = UiState.hasData);

    } on DioError catch(error) {
      if(error.type == DioErrorType.DEFAULT) {
        if(error.message.contains("FormatException: Unexpected end of input")) {
          _hasFormatExceptionError = true;
          loadData();
        } else {
          setState(() => _uiState = UiState.hasError);
        }
      } else {
        setState(() => _uiState = UiState.hasError);

      }

    } catch (error) {
      setState(() => _uiState = UiState.hasError);
    } finally {
      _hasFormatExceptionError = false;
    }
  }

  String formatHtml(String html) {
    return "<iframe src=\"https://www.facebook.com/plugins/video.php?href=$html%2F&width=1920\" width=\"1920\" height=\"1080\"/>";
  }

  Widget _buildLoadingScreen() {
    return Container(
      color: ThemeData.dark().canvasColor,
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Shimmer.fromColors(
                baseColor: Colors.grey,
                highlightColor: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      color: Colors.white, 
                      height: 20,
                      width: 100,
                    ),
                    SizedBox(height: 16,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: 16/9,
                        child: Container(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 8,),
                    Container(
                      color: Colors.white, 
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),

            ...List<Widget>.generate(3, (index) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: index != 0 ? null : BorderRadius.vertical(
                    top: Radius.circular(12)
                  )
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.white,
                  child: Column(
                    children: [
                      if(index == 0) SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          color: Colors.white,
                          height: 20,
                        ),
                      ),
                      AspectRatio(
                        aspectRatio: 1.5,
                        child: PageView.builder(
                          itemCount: 2,
                          controller: PageController(viewportFraction: _viewPortFraction),
                          itemBuilder: (context, i) {
                            return Container(
                              color: Colors.white,
                              margin: const EdgeInsets.all(16),
                            );
                          }, 
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList()
          ],
        ),
      ),
    );
  }

  Widget _buildLiveViewWidget(Videos provider) {
    if(provider.livestream["embed_html"] == null)
      return SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      color: ThemeData.dark().canvasColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Live TV",
            style: Theme.of(context).textTheme.headline.copyWith(
              color: ThemeData.dark().textTheme.body1.color,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 16,),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16/9,
              child: LayoutBuilder(
                builder: (context, constraints) => Stack(
                  children: [
                    Positioned(  
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: HtmlWidget(
                        formatHtml(provider.livestream["embed_html"]), 
                        bodyPadding: EdgeInsets.zero,
                        webView: true,
                      ),
                    ),
                    Container(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed(ROUTE_LIVE_VIDEO_SCREEN),
                      ),
                    )
                  ]
                ),
              ),
            ),
          ),
          SizedBox(height: 8,),
          if(provider.livestream["title"] != null)
            Text(
              provider.livestream["title"],
              style: Theme.of(context).textTheme.subhead.copyWith(
              color: ThemeData.dark().textTheme.body1.color,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen() {
    return ErrorDialog(
      buttonText: "Cuba Semula",
      onTap: () => loadData(reload: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    super.build(context);

    switch(_uiState) {
      
      case UiState.isLoading:
        return _buildLoadingScreen();
        break;
      case UiState.hasError:
        return _buildErrorScreen();
        break;
      case UiState.hasData:
      return _buildDataScreen();
        break;
    }
  }

  Widget _buildDataScreen() {
    var mediaQuery = MediaQuery.of(context);

    return RefreshIndicator(
      onRefresh: () => loadData(reload: true),
      child: Container(
        color: ThemeData.dark().canvasColor,
        child: Consumer<Videos>(
          builder: (context, provider, child) {
            final categories = provider.categories.where((c) => c.videos.isNotEmpty).toList();

            return CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: _buildLiveViewWidget(provider),
                ),

                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                      final category = categories[index]..videos;

                      if(!_pageControllers.containsKey(category.id))
                        _pageControllers[category.id] = PageController(
                          keepPage: true,
                          viewportFraction: _viewPortFraction
                        );

                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: index != 0 ? null : BorderRadius.vertical(
                            top: Radius.circular(12)
                          )
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          children: [
                            Row(
                              children: <Widget>[
                                SizedBox(width: 16),
                                Text(
                                  category.title,
                                  style: Theme.of(context).textTheme.title.copyWith(
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                                Spacer(),
                                FlatButton(
                                  onPressed: () => Navigator.of(context).pushNamed(ROUTE_PAGINATED_VIDEOS_SCREEN, arguments: category.slug),
                                  child: Text(
                                    "VIEW ALL",
                                    style: Theme.of(context).textTheme.button.copyWith(
                                      color: Theme.of(context).primaryColor
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                              ],
                            ),
                            AspectRatio(
                              aspectRatio: 1.5,
                              child: PageView.builder(
                                itemCount: category.videos.length > _maximumVideosToShow ? _maximumVideosToShow : category.videos.length,
                                controller: _pageControllers[category.id],
                                itemBuilder: (context, i) {
                                  final video = category.videos[i];

                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CardInformation(
                                      post: video,
                                      onTap: () => Navigator.of(context).pushNamed(ROUTE_VIDEO_SCREEN, arguments: video.slug),
                                    ),
                                  );
                                }, 
                              ),
                            ),
                          ],
                        ),
                      );
                    }, childCount: categories.length
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

/*
return GestureDetector(
                                    onTap: () => Navigator.of(context).pushNamed(ROUTE_VIDEO_SCREEN, arguments: video.slug),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Material(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.transparent,
                                        elevation: 1.0,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 2,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl: video.imageUrl == null ? "" : video.imageUrl,
                                                  placeholder: (ctx, url) => Container(
                                                    color: Theme.of(context).cardColor,
                                                    child: CenteredCircularProgressIndicator()
                                                  ),
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                ),
                                              ),
                                            ),

                                            Expanded(
                                              child: Container(
                                                alignment: Alignment.topLeft,
                                                padding: const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).cardColor,
                                                  borderRadius: BorderRadius.only(
                                                    bottomLeft: Radius.circular(10),
                                                    bottomRight: Radius.circular(10),
                                                  )
                                                ),
                                                child: Text(
                                                  video.title,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                  style: Theme.of(context).textTheme.title,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ); */