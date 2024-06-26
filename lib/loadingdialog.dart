import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  LoadingDialog({this.message});

  final String? message;



  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      key: key,
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 30,),
         CircularProgressIndicator(),
          SizedBox(height: 12,),
          Container(
            padding: EdgeInsets.all(18),
            child: Center(
              child: Text(
                'Please wait....',
                style: TextStyle(
                  fontSize: 12
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
