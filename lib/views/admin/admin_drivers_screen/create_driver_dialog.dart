import 'package:flutter/material.dart';

class CreateDriverDialog extends StatefulWidget {
  const CreateDriverDialog({
    super.key, 
    required this.onValidateForm,
    required this.onSavedField,
    required this.onGetBuses,
    required this.onCreateDriver,
  });

  final String? Function(String? input, String field) onValidateForm;
  final void Function(String? input, String field) onSavedField;
  final Future<List<dynamic>> Function() onGetBuses;
  final void Function() onCreateDriver;

  @override
  State<CreateDriverDialog> createState() => _CreateDriverDialogState();
}

class _CreateDriverDialogState extends State<CreateDriverDialog> {
  final _formKey = GlobalKey<FormState>();

  String? selectedBus;
  // store all available bus
  List<dynamic> buses = [];
  //
  bool isLoading = true;
  // get all bus
  void getAllBuses() async{
    buses = await widget.onGetBuses();
    buses = List<dynamic>.from(buses.where((bus) => bus['driver_id'] == 0));
    if(buses.isNotEmpty){
       selectedBus = buses[0]['id'].toString();
    }
   
    print(buses);
    isLoading = false;
    setState(() {});
  }
  
  @override
  void initState() {
    super.initState();
    getAllBuses();
    
  }

  @override
  Widget build(BuildContext context) {
    return isLoading? const Center(child: CircularProgressIndicator()): Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Header
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: const Icon(
                        Icons.person_add,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Create Driver Account",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// Driver Name
                TextFormField(
                  validator: (String? input){
                    return widget.onValidateForm(input, 'name');
                  },
                  onSaved: (String? input) {
                    widget.onSavedField(input, 'name');
                  },
                  decoration: InputDecoration(
                    labelText: "Driver Name",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// Email
                TextFormField(
                  validator: (String? input){
                    return widget.onValidateForm(input, 'email');
                  },
                  onSaved: (String? input) {
                    widget.onSavedField(input, 'email');
                  },
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// Phone Number
                TextFormField(
                  validator: (String? input){
                    return widget.onValidateForm(input, 'phone_number');
                  },
                  onSaved: (String? input) {
                    widget.onSavedField(input, 'phone_number');
                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// Password
                TextFormField(
                  validator: (String? input){
                    return widget.onValidateForm(input, 'password');
                  },
                  onSaved: (String? input) {
                    widget.onSavedField(input, 'password');
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// Bus Selection
                DropdownButtonFormField<String>(
                  value: selectedBus,
                  decoration: InputDecoration(
                    labelText: "Assign Bus",
                    prefixIcon: const Icon(Icons.directions_bus),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: [
                    ...buses.map((bus) => DropdownMenuItem(
                        value: bus['id'].toString(),
                        child: Text('Bus ${bus['id']}'),
                      ))
                  ],
                  onSaved: (String? input) {
                    widget.onSavedField(input, 'bus');
                  },
                  onChanged: (value) {
                    setState(() {
                      selectedBus = value!;
                    });
                  },
                ),

                const SizedBox(height: 24),

                /// Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Create Driver Account
                            _formKey.currentState!.save();
                            widget.onCreateDriver();
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: const Text("Create"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}