import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/field_text.dart';

class CreateParentDialog extends StatefulWidget {
  const CreateParentDialog({
    super.key, 
    required this.onValidatedForm,
    required this.onGetSave,
    required this.onCreateParentAccount,
    required this.formKey,
    required this.onGetAllBus,
  });

   //
  final String? Function(String? input, String field) onValidatedForm;
  final void Function() onCreateParentAccount;
  final void Function(String? input, String field) onGetSave;
  final GlobalKey<FormState> formKey;
  final Future<List<dynamic>> Function() onGetAllBus;

  @override
  State<CreateParentDialog> createState() => _CreateParentDialogState();
}

class _CreateParentDialogState extends State<CreateParentDialog> {

  // 
  bool isLoading = false;
  late List<dynamic> buses;

  String selectedSex = 'M';
  late String selectedBusNumber;

  // get all specific bus
  void getBuses() async{
    isLoading = true;
    buses = await widget.onGetAllBus();
    selectedBusNumber = buses[0].toString();
    isLoading = false;
    setState(() {
      
    });
  }
  //
  @override 
  void initState() {
    super.initState();
    getBuses();

  }
  @override
  Widget build(BuildContext context) {
    return isLoading? const Center(child: CircularProgressIndicator()) : Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(
          maxHeight: 700,
        ),
        child: Form(
          key: widget.formKey,
          child: Column(
            children: [
              const Row(
                children: [
                  Icon(Icons.person_add),
                  SizedBox(width: 8),
                  Text(
                    'Create Parent Account',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FieldText('parent name', isRequired: true,),
                      TextFormField(
                        validator: (String? data) {
                          return widget.onValidatedForm(data, 'parent_name');
                        },
                        onSaved: (String? data) {
                          widget.onGetSave(data, 'parent_name');
                        },
                        decoration: const InputDecoration(
                          hintText: 'Parent Name',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16),
                      FieldText('Email', isRequired: true,),
                      TextFormField(
                        validator: (String? data) {
                          return widget.onValidatedForm(data, 'email');
                        },
                        onSaved: (String? data) {
                          widget.onGetSave(data, 'email');
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16),
                      FieldText('phone-number', isRequired: true,),
                      TextFormField(
                        validator: (String? data) {
                          return widget.onValidatedForm(data, 'phone_number');
                        },
                        onSaved: (String? data) {
                          widget.onGetSave(data, 'phone_number');
                        },
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Phone Number',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16),
                      FieldText('student name', isRequired: true,),
                      TextFormField(
                        validator: (String? data) {
                          return widget.onValidatedForm(data, 'student_name');
                        },
                        onSaved: (String? data) {
                          widget.onGetSave(data, 'student_name');
                        },
                        decoration: const InputDecoration(
                          hintText: 'Student Name',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16),
                      FieldText('latitude, longitude'),
                      TextFormField(
                        validator: (String? data) {
                          return widget.onValidatedForm(data, 'location');
                        },
                        onSaved: (String? data) {
                          widget.onGetSave(data, 'location');
                        },
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: 'Example: 10.12234, 101.0923',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        onSaved: (String? data) {
                          widget.onGetSave(data, 'sex');
                        },
                        value: selectedSex,
                        decoration: const InputDecoration(
                          labelText: 'Sex',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'M',
                            child: Text('Male'),
                          ),
                          DropdownMenuItem(
                            value: 'F',
                            child: Text('Female'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedSex = value!;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        onSaved: (String? data) {
                          widget.onGetSave(data, 'bus');
                        },
                        value: selectedBusNumber,
                        decoration: const InputDecoration(
                          labelText: 'Bus Number',
                          border: OutlineInputBorder(),
                        ),
                        items:  [
                          ...buses.map((bus) =>  
                            DropdownMenuItem(
                              value: bus.toString(),
                              child: Text('Bus $bus'),
                            )
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedBusNumber = value!;
                          });
                        },
                      ),

                      const SizedBox(height: 16),
                      FieldText('password', isRequired: true,),
                      TextFormField(
                        validator: (String? data) {
                          return widget.onValidatedForm(data, 'password');
                        },
                        onSaved: (String? data) {
                          widget.onGetSave(data, 'password');
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Password',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.lock),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async{
                        // Create Parent Account API
                        isLoading = true;
                        setState(() {});
                        if(widget.formKey.currentState!.validate()){
                           widget.formKey.currentState!.save();
                           widget.onCreateParentAccount();
                           Navigator.pop(context);
                        }
                        isLoading = false;
                        setState(() {});
                       
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Create'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}