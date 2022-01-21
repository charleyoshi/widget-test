import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({Key? key}) : super(key: key);

  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  Future<void> _checkPermission() async {
    //Check for a permission:
    // To check if the location aka GPS is on
    final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
    final isGpsOn = serviceStatus == ServiceStatus.enabled;

    if (!isGpsOn) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('GPS is not on'),
        duration: Duration(seconds: 3),
        // action: SnackBarAction(
        //   label: 'ACTION',
        //   onPressed: () {},
        // ),
      ));
      print('Turn on location services before requesting permission.');
      return;
    }

    // Request a permission:
    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      // TODO: show location
      print('Permission granted');
    } else if (status == PermissionStatus.denied) {
      // show dialog again, keep asking for permission
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text('Location Permission'),
                content: Text('Content'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Deny'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    child: Text('Settings'),
                    onPressed: () => openAppSettings(),
                  ),
                ],
              ));
      print(
          'Permission denied. Show a dialog and again ask for the permission');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print(status); //PermissionStatus.permanentlyDenied
      // show SnackBar: Go to settings if you still want to use this service.
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'is permanently denied. Go to settings if you still want to use this service.'),
        duration: Duration(seconds: 3),
        // action: SnackBarAction(
        //   label: 'ACTION',
        //   onPressed: () {},
        // ),
      ));

      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text('Location Permission'),
                content: Text('Content'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Deny'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    child: Text('Settings'),
                    onPressed: () => openAppSettings(),
                  ),
                ],
              ));

      // await openAppSettings();
    } else {
      // restricted
      // show SnackBar: Go to settings if you want to use this service.
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'is restricted. Go to settings if you still want to use this service.'),
        duration: Duration(seconds: 3),
        // action: SnackBarAction(
        //   label: 'ACTION',
        //   onPressed: () {},
        // ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: _checkPermission,
              child: Text('Check Permission'),
            ),
          ),
          Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.location_city),
                    title: Text("Location"),
                    onTap: () async {
                      var status = await Permission.location.status;
                      if (status.isGranted) {
                        print('status.isGranted');
                      } else if (status.isDenied) {
                        // We didn't ask for permission yet.
                        // print('status.isDenied');
                      } else {
                        print(status);

                        // restricted or permanentlyDenied
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoAlertDialog(
                                  title: Text('Location Permission'),
                                  content: Text('Content'),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      child: Text('Deny'),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                    CupertinoDialogAction(
                                      child: Text('Settings'),
                                      onPressed: () => openAppSettings(),
                                    ),
                                  ],
                                ));
                      }
                    }),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => {Navigator.pop(context)},
            ),
          ),
        ],
      ),
    );
  }
}
