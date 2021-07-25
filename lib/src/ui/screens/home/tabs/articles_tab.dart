import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../models/post/post.dart';
import '../../../../models/responses/response_article_screen/category_layout.dart';
// import '../../../../providers/posts.dart';

import '../../../widgets/card_information_widget.dart';
import '../../../widgets/error_dialog.dart';
import '../../../widgets/floating_card.dart';
import '../../../widgets/list_tile_information_widget.dart';
import '../../../widgets/news_headline_post_widget.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/utils.dart';

class ArticlesTab extends StatefulWidget {
  const ArticlesTab({Key? key}) : super(key: key);

  @override
  _ArticlesTabState createState() => _ArticlesTabState();
}

class _ArticlesTabState extends State<ArticlesTab> {
  late UiState _uiState;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadData({bool reload = false}) async {}

  void _openPost(String slug) {
    Navigator.of(context).pushNamed(ROUTE_ARTICLE_SCREEN, arguments: slug);
  }

  @override
  Widget build(BuildContext context) {
    return _buildDataScreen();
  }

  Widget _buildDataScreen() {
    var data = _getRawData();

    List<Map<String, Object>> _pinnedPosts = data['pinned']['posts'];
    List<Post> pinnedPosts = _pinnedPosts.map((post) {
      post['meta_description'] = 'example';
      post['keywords'] = 'example';
      return Post.fromJson(post);
    }).toList();

    List<Map<String, dynamic>> _categories = data['categories'];
    List<CategoryLayout> categories = _categories.map((category) {

      List<Map<String, Object>> _posts = category['category']['posts'];

      List<Post> posts = _posts.map((post) {
        post['meta_description'] = 'example';
        post['keywords'] = 'example';
        return Post.fromJson(post);
      }).toList();

      // category['category']['posts'] = posts;
      return CategoryLayout.fromJson(category);
    }).toList();

    List<Map<String, Object>> _latestPosts = data['latest']['posts'];
    List<Post> latestPosts = _latestPosts.map((post) {
      post['meta_description'] = 'example';
      post['keywords'] = 'example';
      return Post.fromJson(post);
    }).toList();

    var _headlinePost = data['pinned']['posts'].removeAt(0);
    // _headlinePost['keywords'] = 'example';
    // _headlinePost['meta_description'] = 'example';

    Post headlinePost = Post.fromJson(_headlinePost);

    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          if (headlinePost != null)
            SliverToBoxAdapter(
              child: NewsHeadlinePost(
                post: headlinePost,
                onTap: () => _openPost(headlinePost.slug),
              ),
            ),
          if (pinnedPosts.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: pinnedPosts.map((post) {
                    return FloatingCard(
                      post: post as Post,
                      onTap: () => _openPost((post as Post).slug),
                    );
                  }).toList(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Divider(),
            ),
          ],
          if (latestPosts.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Terkini",
                          style: Theme.of(context).textTheme.display1!.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        Spacer(),
                        Material(
                          type: MaterialType.transparency,
                          child: InkWell(
                            onTap: () => Navigator.of(context)
                                .pushNamed(ROUTE_PAGINATED_ARTICLES_SCREEN),
                            child: Container(
                              color: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                "View All",
                                textAlign: TextAlign.end,
                                style: Theme.of(context)
                                    .textTheme
                                    .body2!
                                    .copyWith(
                                        color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildPostVerticalListView(
                      (latestPosts), LayoutStyle.VerticalScroll),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Divider(),
            ),
          ],
          ...categories.map((categoryLayout) {
            final category = categoryLayout.category;
            final layoutStyle = categoryLayout.layoutStyle;
            final layoutTheme = categoryLayout.layoutTheme;

            return SliverToBoxAdapter(
              child: Theme(
                data: layoutTheme == LayoutTheme.Light
                    ? Theme.of(context)
                    : darkTheme,
                child: Container(
                  color: layoutTheme == LayoutTheme.Light
                      ? Theme.of(context).canvasColor
                      : darkTheme.canvasColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              category.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .display1!
                                  .copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: layoutTheme == LayoutTheme.Light
                                        ? null
                                        : Colors.white,
                                  ),
                            ),
                            Spacer(),
                            Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                onTap: () => Navigator.of(context).pushNamed(
                                    ROUTE_PAGINATED_ARTICLES_SCREEN,
                                    arguments: category.slug),
                                child: Container(
                                  color: Colors.transparent,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Text(
                                    "View All",
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context)
                                        .textTheme
                                        .body2
                                        ?.copyWith(
                                            color:
                                                Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (layoutStyle == LayoutStyle.PageView)
                        _buildPostPageView(category.posts!)
                      else if (layoutStyle == LayoutStyle.GridView)
                        _buildPostGridView(category.posts!)
                      else if (layoutStyle == LayoutStyle.HorizontalScroll)
                        _buildPostHorizontalListView(category.posts!)
                      else
                        _buildPostVerticalListView(
                            category.posts!, categoryLayout.layoutStyle),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          })
        ],
      ),
    );
  }

  Widget _buildPostHorizontalListView(List<Post> posts) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: posts.map((post) {
          return FloatingCard(
            post: post,
            onTap: () => _openPost(post.slug),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPostVerticalListView(List<Post> posts, LayoutStyle layoutStyle) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: posts.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final post = posts[index];

        return ListTileInformation(
          post: post,
          onTap: () => _openPost(post.slug),
          imageOnTheRight: layoutStyle != LayoutStyle.LeftImageVerticalScroll,
        );
      },
    );
  }

  Widget _buildPostPageView(List<Post> posts) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: posts.length,
        controller: PageController(viewportFraction: 1),
        itemBuilder: (context, index) {
          final post = posts[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CardInformation(
              post: post,
              onTap: () => _openPost(post.slug),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostGridView(List<Post> posts) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: posts.length,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.65),
      itemBuilder: (context, index) {
        final post = posts[index];

        return FloatingCard(
          post: post,
          onTap: () => _openPost(post.slug),
        );
      },
    );
  }

  dynamic _getRawData() {
    return {
      "pinned": {
        "posts": [
          {
            "id": 11325,
            "slug": "polis-pantau-pergerakan-masuk-kenderaan-ke-terengganu",
            "title":
                "'Jangan Rentas Masuk Terengganu Tanpa Alasan Kukuh' - Polis",
            "name_file":
                "2021/07/20210717201740_233e2dfae3b67847fc8ce21845a138ce",
            "extension_file": "jpeg",
            "visiblity_date_seconds": 1626520680,
            "created_by": "Mastura Jamal Din",
            "view": 2348
          },
          {
            "id": 11314,
            "slug": "dun-terengganu-bersidang-13-september",
            "title": "DUN Terengganu Bersidang 13 September",
            "name_file":
                "2021/07/20210715211124_14f3dffee0f07fc594474bab67aff56c",
            "extension_file": "jpg",
            "visiblity_date_seconds": 1626353340,
            "created_by": "Husaif Mamat",
            "view": 661
          },
          {
            "id": 11312,
            "slug": "presiden-pas-dibenar-keluar-ijn-berkuliah-dhuha-esok",
            "title": "Presiden PAS Dibenar Keluar IJN, Berkuliah Dhuha Esok",
            "name_file":
                "2021/07/20210715183847_c8045a8e551791e475e3aa42b697b377",
            "extension_file": "jpg",
            "visiblity_date_seconds": 1626345360,
            "created_by": "Husaif Mamat",
            "view": 1312
          },
        ]
      },
      "latest": {
        "posts": [
          {
            "id": 11322,
            "slug": "10-menara-telekomunikasi-sedang-dinaik-taraf",
            "title": "10 Menara Telekomunikasi Sedang Dinaik Taraf",
            "name_file":
                "2021/07/20210717130259_17fa2f570b544f2bb5b6677073539f99",
            "extension_file": "jpg",
            "visiblity_date_seconds": 1626527940,
            "created_by": "Fakrusy Syakirin Ahmad Sabri",
            "view": 118
          },
          {
            "id": 11326,
            "slug": "jangan-biar-sejarah-aidilfitri-berulang-kembali",
            "title": "'Jangan Biar Sejarah Aidilfitri Berulang Kembali'",
            "name_file":
                "2021/07/20210717205046_40000bb22288632365574ae0d245b50b",
            "extension_file": "jpeg",
            "visiblity_date_seconds": 1626525900,
            "created_by": "Mastura Jamal Din",
            "view": 282
          },
          {
            "id": 11323,
            "slug": "sarapan-pagi-percuma-untuk-penduduk-memerlukan",
            "title": "Sarapan Pagi Percuma Untuk Penduduk Memerlukan",
            "name_file":
                "2021/07/20210717140922_fce31b736253b01fc279bd06e79f1369",
            "extension_file": "jpg",
            "visiblity_date_seconds": 1626525240,
            "created_by": "Pok Abbas",
            "view": 108
          },
        ]
      },
      "categories": [
        {
          "category": {
            "id": 21,
            "title": "Sukan",
            "slug": "sukan",
            "post_count": 826,
            "posts": [
              {
                "id": 11318,
                "slug":
                    "azreen-zulkhairie-terima-insentif-rm30000-dari-kerajaan",
                "title": "Azreen, Zulkhairie Terima Insentif RM30,000",
                "name_file":
                    "2021/07/20210717085623_586e5ddb77edb29cbe08f9b1cb44a398",
                "extension_file": "jpg",
                "visiblity_date_seconds": 1626491880,
                "created_by": "Mohd Irsyadi Abu Bakar",
                "view": 207
              },
              {
                "id": 11313,
                "slug": "terengganu-tambah-100-peratus-elaun-atlet-sukma",
                "title": "Terengganu Tambah 100 Peratus Elaun Atlet SUKMA",
                "name_file":
                    "2021/07/20210715190728_882423cf8d5c4d39cec1721f060b46ab",
                "extension_file": "jpg",
                "visiblity_date_seconds": 1626345900,
                "created_by": "Mohd Irsyadi Abu Bakar",
                "view": 310
              },
              {
                "id": 11291,
                "slug": "terengganu-kongsi-resipi-bangunkan-sukan-negara",
                "title": "Terengganu Kongsi 'Resipi' Bangunkan Sukan Negara",
                "name_file":
                    "2021/07/20210714165107_187b9fa928ed5f36e02a75fe814ba3fa",
                "extension_file": "jpg",
                "visiblity_date_seconds": 1626252480,
                "created_by": "Fakrusy Syakirin Ahmad Sabri",
                "view": 105
              },
              {
                "id": 11275,
                "slug": "terengganu-fc-perkemas-rentak-empat-aksi-persahabatan",
                "title":
                    "Terengganu FC Perkemas Rentak Empat Aksi Persahabatan",
                "name_file":
                    "2021/07/20210713091450_8769453419f3a41cadd6876a03017797",
                "extension_file": "jpg",
                "visiblity_date_seconds": 1626138540,
                "created_by": "Nur 'Afini Yahaya",
                "view": 143
              },
              {
                "id": 11230,
                "slug": "jangan-kecewa-terengganu-fc",
                "title": "Jangan Kecewa Terengganu FC!",
                "name_file":
                    "2021/07/20210708152347_e1710b0b3d996d791ee43f1cac12f316",
                "extension_file": "jpeg",
                "visiblity_date_seconds": 1625718600,
                "created_by": "Mohd Irsyadi Abu Bakar",
                "view": 282
              },
              {
                "id": 11174,
                "slug":
                    "harrif-salleh-kongsi-duit-menang-lumba-basikal-dengan-masyarakat",
                "title":
                    "Harrif Salleh Kongsi Duit Menang Lumba Basikal Dengan Masyarakat",
                "name_file":
                    "2021/07/20210703183832_b88854facb4cb3bf4f9122e073991fcb",
                "extension_file": "jpeg",
                "visiblity_date_seconds": 1625314260,
                "created_by": "Mohd Irsyadi Abu Bakar",
                "view": 990
              },
              {
                "id": 11172,
                "slug": "atlet-para-terengganu-gembira-terima-vaksin",
                "title": "Atlet Para Terengganu Gembira Terima Vaksin",
                "name_file":
                    "2021/07/20210703182402_a17745381d713974ad0f1c39913f5810",
                "extension_file": "jpeg",
                "visiblity_date_seconds": 1625305980,
                "created_by": "Mohd Irsyadi Abu Bakar",
                "view": 88
              },
              {
                "id": 11077,
                "slug": "ratu-pecut-terengganu-berlari-ke-olimpik-2020",
                "title": "Ratu Pecut Terengganu 'Berlari' Ke Olimpik 2020",
                "name_file":
                    "2021/06/20210626141018_d1084b1b078e54556aec87c80e30f7cc",
                "extension_file": "jpg",
                "visiblity_date_seconds": 1624700340,
                "created_by": "Mohd Irsyadi Abu Bakar",
                "view": 1443
              }
            ]
          },
          "layout": {"name": "HorizontalScroll", "theme": "dark"}
        },
        {
          "category": {
            "id": 16,
            "title": "Pelancongan",
            "slug": "pelancongan",
            "post_count": 455,
            "posts": [
              {
                "id": 11103,
                "slug": "pemulih-cukai-pelancongan-perkhidmatan-dikecualikan",
                "title":
                    "PEMULIH : Cukai Pelancongan, Perkhidmatan Dikecualikan",
                "name_file":
                    "2021/06/20210629180635_6bc4f4542ba23c53bb64de4e9b3250e5",
                "extension_file": "jpg",
                "visiblity_date_seconds": 1624960080,
                "created_by": "Mastura Jamal Din",
                "view": 78
              },
              {
                "id": 11088,
                "slug":
                    "rm118100-untuk-bantu-pengusaha-pelancongan-tasik-kenyir",
                "title":
                    "RM118,100 Untuk Bantu Pengusaha Pelancongan Tasik Kenyir",
                "name_file":
                    "2021/06/20210627144102_567deae0b528da463565535851dfc6e6",
                "extension_file": "jpg",
                "visiblity_date_seconds": 1624775880,
                "created_by": "Mastura Jamal Din",
                "view": 349
              },
              {
                "id": 10984,
                "slug":
                    "cadang-utamakan-vaksin-kepada-pemain-industri-pelancongan",
                "title":
                    "Cadang Utamakan Vaksin Kepada Pemain Industri Pelancongan",
                "name_file":
                    "2021/06/20210615150159_fbc97af323e1b5057346fa441a11922e",
                "extension_file": "jpeg",
                "visiblity_date_seconds": 1623759420,
                "created_by": "Fakrusy Syakirin Ahmad Sabri",
                "view": 251
              },
              {
                "id": 10981,
                "slug": "pengayuh-beca-gembira-kerajaan-bagi-rm200-sebulan",
                "title": "Pengayuh Beca Gembira Kerajaan Bagi RM200 Sebulan",
                "name_file":
                    "2021/06/20210614224237_2694ac3ec39d7311f952c0e2ccbbd604",
                "extension_file": "jpeg",
                "visiblity_date_seconds": 1623738540,
                "created_by": "Fakrusy Syakirin Ahmad Sabri",
                "view": 229
              },
              {
                "id": 10980,
                "slug":
                    "pengayuh-beca-pemandu-bot-penambang-terima-elaun-rm200-sebulan",
                "title":
                    "Pengayuh Beca, Pemandu Bot Penambang Terima Elaun RM200 Sebulan",
                "name_file":
                    "2021/06/20210614181059_409b7fc98fb1a6f51cfa0ad3ed417e44",
                "extension_file": "jpeg",
                "visiblity_date_seconds": 1623674760,
                "created_by": "Fakrusy Syakirin Ahmad Sabri",
                "view": 773
              },
              {
                "id": 10770,
                "slug":
                    "pelita-raya-kampung-budaya-terpadam-sambutan-masih-luar-biasa",
                "title":
                    "Pelita Raya Kampung Budaya 'Terpadam', Sambutan Masih Luar Biasa",
                "name_file":
                    "2021/05/20210510121937_cbdf8baeb5e2845579f83002bfb1d077",
                "extension_file": "jpeg",
                "visiblity_date_seconds": 1620619680,
                "created_by": "Fakrusy Syakirin Ahmad Sabri",
                "view": 270
              },
              {
                "id": 10754,
                "slug": "pelita-raya-kembalikan-suasana-nostalgia",
                "title": "Pelita Raya, Kembalikan Suasana Nostalgia",
                "name_file":
                    "2021/05/20210508125735_3c5b5817bb0a51a359fb7785574e28a3",
                "extension_file": "jpeg",
                "visiblity_date_seconds": 1620449280,
                "created_by": "Fakrusy Syakirin Ahmad Sabri",
                "view": 185
              },
            ]
          },
          "layout": {"name": "LeftImageVerticalScroll", "theme": "dark"}
        },
      ]
    };
  }
}
