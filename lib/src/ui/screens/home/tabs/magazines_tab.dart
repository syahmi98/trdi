import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../models/post/post.dart';
import '../../../../models/responses/response_posts/response_posts.dart';
// import '../../../../providers/posts.dart';
import '../../../widgets/centered_circular_progress_indicator.dart';
import '../../../../utils/utils.dart';
// import '../../../widgets/error_dialog.dart';
import '../../../../utils/enums.dart';

class MagazinesTab extends StatefulWidget {
  const MagazinesTab({required Key key}) : super(key: key);

  @override
  _MagazinesTabState createState() => _MagazinesTabState();
}

class _MagazinesTabState extends State<MagazinesTab> {
  ScrollController _scrollController = ScrollController();
  late ResponsePosts _responsePosts;
  List<Post> _posts = [];
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
    return buildDataWidget();
  }

  Widget buildDataWidget() {
     var rawData = _getRawData();

    List<Post> _posts = rawData.map((post) {
      post['meta_description'] = 'example';
      post['keywords'] = 'example';
      return Post.fromJson(post);
    }).toList();
    
    
    return Column(
      children: <Widget>[
        if (_posts.length != 0)
          Expanded(
            child: _buildWidgetLatestMagazines(),
          ),
      ],
    );
  }

  Widget _buildWidgetLatestMagazines() {
    var rawData = _getRawData();

    List<Post> _posts = rawData.map((post) {
      post['meta_description'] = 'example';
      post['keywords'] = 'example';
      return Post.fromJson(post);
    }).toList();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 4 / 5),
      itemCount: _posts.length,
      itemBuilder: (ctx, i) {
        Post magazine = _posts[i];

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 10,
            child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(ROUTE_MAGAZINE_SCREEN, arguments: magazine.slug);
              },
              splashFactory: InkSplash.splashFactory,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: GridTile(
                  child: magazine.imageUrl == null
                      ? Container()
                      : (kIsWeb)
                          ? Image.asset(
                              'images/20210421123440_273a46ab713bb85d8e51e5a1c36e1f5d.jpeg')
                          : CachedNetworkImage(
                          imageUrl: magazine.imageUrl!,
                          placeholder: (ctx, url) =>
                              CenteredCircularProgressIndicator(),
                          fit: BoxFit.cover),
                  footer: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: [
                        Colors.black87,
                        Colors.black38,
                        Colors.grey.withOpacity(0),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [0.0, 0.8, 1.0],
                    )),
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      magazine.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.body2!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _getRawData() {

    return [
      {
        "id": 10622,
        "slug": "warta-darul-iman-bil-12021",
        "title": "Warta Darul Iman Bil 1 2021",
        "name_file": "2021/04/20210421123440_273a46ab713bb85d8e51e5a1c36e1f5d",
        "extension_file": "jpg",
        "visiblity_date_seconds": 1618979520,
        "created_by": "Husaif Mamat",
        "view": 175
      },
      {
        "id": 9730,
        "slug": "warta-darul-iman-bil-16",
        "title": "Warta Darul Iman Bil 16",
        "name_file": "2021/01/20210119162406_f1ace1d975754f26d447c32f5f7857aa",
        "extension_file": "jpg",
        "visiblity_date_seconds": 1611042780,
        "created_by": "Husaif Mamat",
        "view": 305
      },
      {
        "id": 9444,
        "slug": "ebook-belanjawan-terengganu-2021",
        "title": "E-Book Belanjawan Terengganu 2021",
        "name_file": "2021/01/20210119154510_b0f77cb92be6718f140d2ab4ad9182a7",
        "extension_file": "jpg",
        "visiblity_date_seconds": 1608686340,
        "created_by": "Mr Syed Halim",
        "view": 165
      },
      {
        "id": 9348,
        "slug": "warta-darul-iman-bil-15",
        "title": "Warta Darul Iman Bil 15",
        "name_file": "2020/12/20201214112856_09ebea4a8ed3c9f9a8a6ca7f3024bc80",
        "extension_file": "jpg",
        "visiblity_date_seconds": 1607916000,
        "created_by": "Husaif Mamat",
        "view": 203
      }
    ];
  }
}
