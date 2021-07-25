import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CenteredCircularProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isAndroid = Platform.isAndroid;

    return Center(
      child: isAndroid ? CircularProgressIndicator() : CupertinoActivityIndicator(),
    );
  }
}