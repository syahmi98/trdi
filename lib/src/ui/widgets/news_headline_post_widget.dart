import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:trdi/src/models/post/post.dart';
import 'package:trdi/src/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NewsHeadlinePost extends StatelessWidget {
  const NewsHeadlinePost({
    required this.post, 
    required this.onTap
  });
  
  final Post post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    var gradientColor = Theme.of(context).primaryColorDark;
    final mediaQuery = MediaQuery.of(context);

    if(mediaQuery.platformBrightness == Brightness.dark)
      gradientColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: mediaQuery.size.height/2,
        width: mediaQuery.size.width,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              child: (kIsWeb) 
              // ?  Image.asset(post.ImageUrl)
              ?  Image.asset("images/20210717201740_233e2dfae3b67847fc8ce21845a138ce.jpeg")
              : CachedNetworkImage(
                imageUrl: post.imageUrl ?? "",
                fit: BoxFit.cover,
                height: mediaQuery.size.width,
              ),
            ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    gradientColor,
                    gradientColor,
                    Colors.grey.withOpacity(0),
                  ],
                  stops: [
                    0.0,
                    0.2,
                    1.0
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              child: Container(
                width: mediaQuery.size.width,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    Stack(
                      children: <Widget>[
                        Text(
                          post.title,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline!.copyWith(
                            fontWeight: FontWeight.w900
                          ),
                        ),
                        Positioned(
                          bottom: 3,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                            child: new Text(
                              post.title, 
                              style: Theme.of(context).textTheme.headline!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      post.formattedDate,
                      style: Theme.of(context).textTheme.body2!.copyWith(
                        color: Colors.white
                      )
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}