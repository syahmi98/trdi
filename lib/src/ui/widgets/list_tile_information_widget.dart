import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/post/post.dart';

class ListTileInformation extends StatelessWidget {
  const ListTileInformation({
    Key? key, 
    this.imageOnTheRight = true,
    required this.post, 
    required this.onTap
  }) : super(key: key);

  final bool imageOnTheRight;
  final Post post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Material(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if(!imageOnTheRight) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: (kIsWeb)
                      ? Image.asset('images/20210717201740_233e2dfae3b67847fc8ce21845a138ce.jpeg', fit: BoxFit.contain, width : 300)
                      : CachedNetworkImage(
                    imageUrl: post.imageUrl ?? "",
                    fit: BoxFit.cover,
                    height: mediaQuery.size.width * 0.2,
                    width: mediaQuery.size.width * 0.2,
                  ),
                ),
                
                SizedBox(width: 24),
              ],

              Expanded(
                child: Container(
                  height: mediaQuery.size.width * 0.2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        post.title,
                        overflow: TextOverflow.ellipsis,
                        textScaleFactor: 1.1,
                        maxLines: MediaQuery.of(context).size.height <= 960.0 ? 3 : 4,
                        style: Theme.of(context).textTheme.body2!.copyWith(
                          fontWeight: FontWeight.w900
                        ),
                      ),
                      Spacer(),
                      Text(
                        post.formattedDate,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.body1!.color!.withOpacity(.45), //Colors.black45,
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              if(imageOnTheRight) ...[
                SizedBox(width: 24,),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: (kIsWeb) 
                  ? Image.asset('images/20210717201740_233e2dfae3b67847fc8ce21845a138ce.jpeg', fit: BoxFit.contain, width: 300)
                  : CachedNetworkImage(
                    imageUrl: post.imageUrl ?? "",
                    fit: BoxFit.cover,
                    height: mediaQuery.size.width * 0.2,
                    width: mediaQuery.size.width * 0.2,
                  ),
                )
              ],
            ],
          ),
        )
      ),
    );
  }
}