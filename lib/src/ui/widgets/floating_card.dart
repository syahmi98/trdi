import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'centered_circular_progress_indicator.dart';
import '../../models/post/post.dart';

class FloatingCard extends StatelessWidget {
  const FloatingCard({Key? key, required this.post, required this.onTap}) : super(key: key);
  final Post post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          width: mediaQuery.size.width/2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if(post.imageUrl != null) ...[
                  Card(
                    elevation: 4,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: (kIsWeb)
                      ? Image.asset('images/20210717201740_233e2dfae3b67847fc8ce21845a138ce.jpeg')
                      : CachedNetworkImage(
                        imageUrl: post.imageUrl as String,
                        placeholder: (ctx, url) => Container(height: mediaQuery.size.width/3, child: CenteredCircularProgressIndicator()),
                        fit: BoxFit.cover,
                        height: mediaQuery.size.width/3,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ]
              else 
                Card(
                  elevation: 4,
                  child: Container(
                    height: mediaQuery.size.width/3,
                  ),
                ),

              SizedBox(height: 12),

              Text(
                post.title,
                style: Theme.of(context).textTheme.title?.copyWith(
                  fontSize: Theme.of(context).textTheme.title?.fontSize
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
              ),
              SizedBox(height: 12),
              Text(
                post.formattedDate,
                style: TextStyle(
                  color: Theme.of(context).textTheme.body1?.color?.withOpacity(.45), //Colors.black45
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}