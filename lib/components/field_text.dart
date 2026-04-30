import 'package:flutter/material.dart';

// FieldText is design for styling the label of text input in 2 main style:
// required-style text
// non-required-style text
class FieldText extends StatelessWidget {
  const FieldText(this.data, {super.key, this.isRequired = false});

  final String data;
  final bool isRequired;

  @override
  Widget build(context) {
    return Text.rich(
      TextSpan(
        text: data,
        children: [
          isRequired
              ? TextSpan(text: '*', style: TextStyle(color: Colors.red))
              : TextSpan(),
        ],
      ),
    );
  }
}
