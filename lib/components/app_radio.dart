import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';

class AppRadio extends StatefulWidget {
  const AppRadio({super.key, required this.getLocationChoice});
  //
  final void Function(String choice) getLocationChoice;

  @override
  State<AppRadio> createState() => _AppRadioState();
}

class _AppRadioState extends State<AppRadio> {
  String? selectedValue = 'none';
 

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RadioListTile<String>(
          title: const AppText('Driver Phone', color: Colors.black),
          value: 'driver',
          groupValue: selectedValue,
          onChanged: (value) {
            widget.getLocationChoice(value!);
            setState(() {
              selectedValue = value;
            });
          },
        ),
        RadioListTile<String>(
          title: const AppText('Iot Device', color: Colors.black),
          value: 'Iot',
          groupValue: selectedValue,
          onChanged: (value) {
            widget.getLocationChoice(value!);
            setState(() {
              selectedValue = value;
            });
          },
        ),
      ],
    );
  }
}