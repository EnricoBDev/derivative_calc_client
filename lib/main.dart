import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:derivative_calculator/screens/home_screen.dart';
import 'package:derivative_calculator/screens/ip_addr_form_screen.dart';
import 'package:derivative_calculator/shared_prefs_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/home": (context) => Home(),
        "/ipconf": (context) => IpAddressForm()
      },
      home: FutureBuilder(
          future: chooseNextScreen(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data as Widget;
            } else {
              return Container(
                  color: Colors.white,
                  child: const SpinKitPouringHourGlassRefined(
                      color: Colors.black));
            }
          })));
}

Future<Widget> chooseNextScreen() async {
  String ipAddr = await PrefsHelper.getIp();

  if (ipAddr == "") {
    return IpAddressForm();
  } else {
    return Home();
  }
}
