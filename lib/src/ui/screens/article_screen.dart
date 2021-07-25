import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/customized_shimmers.dart';
import '../widgets/error_dialog.dart';
import '../../utils/enums.dart';
import '../../models/article/article.dart';
// import '../../providers/posts.dart';
import '../../utils/utils.dart';

class ArticleScreen extends StatefulWidget {
  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  late UiState _uiState;
  bool _hasLoaded = false;
  late Article article;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // if(!_hasLoaded) {
    //   loadData().then((_) {
    //     _hasLoaded = true;
    //   });
    // }
  }


  Future<void> loadData() async {
    if(_uiState == UiState.isLoading) return;
    setState(() => _uiState = UiState.isLoading);

    // try {
    //   String postSlug = ModalRoute.of(context)!.settings.arguments as String;

    //   article = await Provider.of<Posts>(context, listen: false).getArticleBySlug(postSlug);
      
    //   setState(() => _uiState = UiState.hasData);
       
    // } catch (error) {
    //   setState(() => _uiState = UiState.hasError);

    // }
  }

  @override
  Widget build(BuildContext context) {

    return buildDataWidget();
  }

  Widget buildDataWidget() {   
    var mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if(article.imageUrl != null)
            (kIsWeb) 
                  ? Image.asset('images/20210717201740_233e2dfae3b67847fc8ce21845a138ce.jpeg')
                  : CachedNetworkImage(
                    imageUrl: article.imageUrl!,
                    placeholder: (_, __) => CenteredCircularProgressIndicator(),
                    fit: BoxFit.cover,
                    width: mediaQuery.size.width,
                    height: mediaQuery.size.width * 0.6,
                  ),

          const SizedBox(height: 18,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  article.author,
                  style: Theme.of(context).textTheme.body2
                ),

                const SizedBox(height: 12,),

                Text(
                  article.title,
                  style: Theme.of(context).textTheme.headline!.copyWith(
                    fontFamily: FONT_MONTSERRAT,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                
                const SizedBox(height: 12,),

                Text(article.formattedDate),

                const SizedBox(height: 12,),

                Divider(),
                
                if(article.description != null)
                  Html(
                    data: article.description,
                    // showImages: true,
                    // useRichText: true,
                    // renderNewlines: true,
                    // defaultTextStyle: TextStyle(
                    //   fontSize: 15,
                    //   fontFamily: FONT_MONTSERRAT,
                    //   fontWeight: FontWeight.w500,
                    // ),
                  ),

                if(article.description != null)
                  const SizedBox(height: 12,),

                if(article.content != null)
                  Html(
                    data: article.content,
                    // showImages: true,
                    // useRichText: true,
                    // renderNewlines: true,
                    // defaultTextStyle: TextStyle(
                    //   fontSize: 15,
                    //   fontFamily: FONT_MONTSERRAT,
                    //   fontWeight: FontWeight.w500,
                    // ),
                  ),
                  
                const SizedBox(height: 12,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}