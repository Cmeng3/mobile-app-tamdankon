import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';
import 'package:tamdan_kon_mobile_flutter/models/driver_screen_model.dart';

class BusUnavailableScreen extends StatefulWidget {
  const BusUnavailableScreen({
    super.key, 
    required this.onRootScreenChange,
    required this.driverId,
    required this.onUpdateDriverState,
    required this.onTriggerParentSnackbar,
  });

  // for trigger root-screen change
  final void Function(String currentrootScreen) onRootScreenChange;
  //
  final int driverId;
  final void Function() onUpdateDriverState;
  final void Function(String message, Color color) onTriggerParentSnackbar;

  @override
  State<BusUnavailableScreen> createState() => _BusUnavailableScreenState();
}

class _BusUnavailableScreenState extends State<BusUnavailableScreen> {
  
  late DriverScreenModel driverScreenModel = DriverScreenModel(
    triggerDriverSnackBar: widget.onTriggerParentSnackbar,
    onUpdateDriverState: widget.onUpdateDriverState,
    onRootScreenChange: widget.onRootScreenChange,
  );

  @override
  void initState() {
    super.initState();
    driverScreenModel.startGetStreamOfBusTimer(widget.driverId);
  }

  @override
  void dispose() {
    driverScreenModel.getBusAssociationTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              'Tamdan Kon',
              color: const Color.fromARGB(255, 3, 3, 80),
              fontSize: 50,
              fontWeight: true,
            ),
            SizedBox(height: 30),
            Icon(Icons.bus_alert, size: 100),
            SizedBox(height: 20),
            AppText(
              'Oppp... Driver have no bus!',
              color: const Color.fromARGB(175, 0, 0, 0),
              fontWeight: true,
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                widget.onRootScreenChange('login_screen');
              },
              child: AppText(
                'Back',
                color: const Color.fromARGB(255, 3, 3, 80),
                fontWeight: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
