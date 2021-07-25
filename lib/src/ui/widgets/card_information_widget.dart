import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'centered_circular_progress_indicator.dart';
import '../../models/post/post.dart';

class CardInformation extends StatelessWidget {
  const CardInformation({Key? key, required this.post, required this.onTap}) : super(key: key);
  final Post post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      elevation: 4, 
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: (kIsWeb) 
                  ? Image.asset('images/20210717201740_233e2dfae3b67847fc8ce21845a138ce.jpeg')
                  : CachedNetworkImage(
                      imageUrl: post.imageUrl ?? "",
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(  
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))
                  ),
                  width: double.infinity,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Text(
                        post.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: (constraints.maxHeight / 12).floor(),
                        style: Theme.of(context).textTheme.title?.copyWith(
                          fontSize: Theme.of(context).textTheme.title?.fontSize
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(10),
            ),
          )
        ],
      ),
    );
  }
}