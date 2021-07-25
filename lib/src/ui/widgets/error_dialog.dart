import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  ErrorDialog({
    this.title = "Makluman",
    this.errorMessage = "Permintaan anda tidak dapat dilaksanakan pada waktu ini",
    this.buttonText = "Kembali",
    required this.onTap
  });

  final String errorMessage;
  final String buttonText;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
    width: double.infinity,
    child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.headline,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(errorMessage),
          SizedBox(height: 16),
          RaisedButton(
            onPressed: onTap,
            child: Text(buttonText),
          )
        ],
    ),
  );
  }
}