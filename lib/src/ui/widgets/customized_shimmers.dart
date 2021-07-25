import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomizedShimmers extends StatelessWidget {
  const CustomizedShimmers({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.white,
      child: child
    );
  }
}