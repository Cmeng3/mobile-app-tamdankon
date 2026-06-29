import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';

class BusInfoAlertDialog extends StatelessWidget {
  const BusInfoAlertDialog({
    super.key,
    required this.title,
    required this.titleColor,
    required this.content,
    required this.contentImage,
  });

  final String title;
  final Color titleColor;
  final String content;
  final Widget contentImage;


  @override
  Widget build(context) {
    return AlertDialog(
      title: AppText(title, color: titleColor, fontSize: 18, fontWeight: true,),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(content, color: Colors.black),
          contentImage,
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          }, 
          child: AppText('got it!')
        )
      ],
    );
  }
}