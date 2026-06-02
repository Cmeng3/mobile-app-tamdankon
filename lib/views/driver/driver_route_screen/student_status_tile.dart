import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';

class StudentStatusTile extends StatelessWidget{
  StudentStatusTile({
    super.key,
    required this.name,
    required this.status,
    this.latitude,
    this.longitude,
  });

  final String name;
  final String status;
  double? latitude;
  double? longitude;

  @override
  Widget build(context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () { print('student is tap');},
      child:Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: status == 'present' ? const Color.fromARGB(38, 76, 175, 80) : (status == 'absent' ?  const Color.fromARGB(38, 244, 67, 54) : const Color.fromARGB(38, 255, 152, 0)),
                child: Icon(
                  Icons.person,
                  color: status == 'present' ? const Color.fromARGB(255, 76, 175, 80) : (status == 'absent' ?  const Color.fromARGB(255, 244, 67, 54) : const Color.fromARGB(255, 255, 152, 0)),
                ),
              ),
        
              const SizedBox(width: 14),
        
              Expanded(
                child: AppText(
                  name,
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: true,
                ),
              ),
        
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: status == 'present' ? const Color.fromARGB(38, 76, 175, 80) : (status == 'absent' ?  const Color.fromARGB(38, 244, 67, 54) : const Color.fromARGB(38, 255, 152, 0)),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: AppText(
                  status == 'pending' ? 'won\'t attend' : status,
                  color: status == 'present' ? const Color.fromARGB(255, 76, 175, 80) : (status == 'absent' ?  const Color.fromARGB(255, 244, 67, 54) : const Color.fromARGB(255, 255, 152, 0)),
                  fontSize: 12,
                  fontWeight: true,
                ),
              ),
            ],
          ),
        ),
    );
  }
}