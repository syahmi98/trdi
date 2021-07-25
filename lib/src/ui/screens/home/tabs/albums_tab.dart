import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

// import '../../../widgets/centered_circular_progress_indicator.dart';
import '../../../../models/post/post.dart';
import '../../../widgets/customized_shimmers.dart';
// import '../../../widgets/error_dialog.dart';
import '../../../../models/responses/response_posts/response_posts.dart';
import '../../../../utils/enums.dart';
// import '../../gallery_screen.dart';

class AlbumsTab extends StatefulWidget {
  AlbumsTab({required Key key}) : super(key: key);

  @override
  _AlbumsTabState createState() => _AlbumsTabState();
}

class _AlbumsTabState extends State<AlbumsTab> {
  ScrollController _scrollController = ScrollController();
  late ResponsePosts _responsePosts;
  late UiState _uiState;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDataScreen();
  }

  Widget _buildDataScreen() {
    var mediaQuery = MediaQuery.of(context);

    var rawData = _getRawData();

    List<Post> _posts = rawData.map((post) {
      post['meta_description'] = 'example';
      post['keywords'] = 'example';
      return Post.fromJson(post);
    }).toList();

    return Column(
      children: <Widget>[
        if (_posts.isNotEmpty)
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
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            elevation: 4,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Stack(
                                children: <Widget>[
                                  GridTile(
                                    child: album.imageUrl == null
                                        ? Container()
                                        : (kIsWeb)
                                            ? Image.asset(
                                                'images/20210629234131_f8aeb0353959d940ba0657996c83e76f.jpeg')
                                            : CachedNetworkImage(
                                                imageUrl: album.imageUrl!,
                                                // placeholder: (ctx, url) =>
                                                //     CenteredCircularProgressIndicator(),
                                                fit: BoxFit.cover),
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
                                              stops: [0.7, 0.93, 1])),
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        "${album.title}",
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .body2!
                                            .copyWith(
                                              fontSize: Theme.of(context)
                                                      .textTheme
                                                      .body2!
                                                      .fontSize! +
                                                  2,
                                              color: Colors.white,
                                            ),
                                      ),
                                    ),
                                  ),
                                  Material(
                                      type: MaterialType.transparency,
                                      child: InkWell(onTap: () => {}))
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 3),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 2),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    color: Theme.of(context)
                                        .textTheme
                                        .body1
                                        !.color
                                        !.withOpacity(.45),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    album.formattedDate,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .body1
                                          !.color
                                          !.withOpacity(.45), //Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 3),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(
                                      Icons.person,
                                      color: Theme.of(context)
                                          .textTheme
                                          .body1
                                          !.color
                                          !.withOpacity(.45),
                                    ),
                                    SizedBox(width: 6),
                                    Flexible(
                                        child: Text(
                                      album.author,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .body1
                                            !.color
                                            !.withOpacity(.45), //Colors.black45,
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ));
              },
            ),
          ),
      ],
    );
  }

  List<Map<String, dynamic>> _getRawData() {
    return [
      {
        "id": 11186,
        "slug": "OKU-cacat-penglihatan-terima-suntikan-vaksin",
        "title": "OKU cacat penglihatan terima suntikan vaksin",
        "name_file": "2021/07/20210704175101_bc4591a703719dd5991c2401816573ec",
        "extension_file": "jpg",
        "visiblity_date_seconds": 1625391780,
        "created_by": "Tengku Syamim Tengku Ismail",
        "view": 27
      },
      {
        "id": 11122,
        "slug":
            "Lukisan-Mural-Berlatar-belakangkan-Suasana-Kampung-Sekitar-1980an-Pada-Dinding-rumah",
        "title":
            "Lukisan Mural Berlatar belakangkan Suasana Kampung Sekitar 1980-an Pada Dinding rumah",
        "name_file": "2021/06/20210629234131_f8aeb0353959d940ba0657996c83e76f",
        "extension_file": "jpg",
        "visiblity_date_seconds": 1624981020,
        "created_by": "Tengku Syamim Tengku Ismail",
        "view": 99
      },
      {
        "id": 10767,
        "slug": "Terengganu-Bertadarus-2021",
        "title": "Terengganu Bertadarus 2021",
        "name_file": "2021/05/20210509135302_4c3b1e70ed9977e8d982adf24a581b71",
        "extension_file": "jpg",
        "visiblity_date_seconds": 1620538620,
        "created_by": "Ammar  Rozlan",
        "view": 76
      },
      {
        "id": 10750,
        "slug":
            "Pelita-Raya-Beautiful-Terengganu-2021-di-Kampung-BudayaTerengganuKompleks-Muzium-Negeri-Terengganu",
        "title":
            "Pelita Raya Beautiful Terengganu 2021 di Kampung Budaya,Terengganu,Kompleks Muzium Negeri Terengganu",
        "name_file": "2021/05/20210507001130_dba8361ae917e45dddda50a2243c8669",
        "extension_file": "jpg",
        "visiblity_date_seconds": 1620317280,
        "created_by": "Tengku Syamim Tengku Ismail",
        "view": 38
      }
    ];
  }
}
