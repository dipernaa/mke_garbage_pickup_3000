import 'package:flutter/material.dart';

import 'package:mke_garbage_pickup_3000/screens/street_form.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MKE Garbage Pickup 3000',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyStreetForm(),
    );
  }
}

