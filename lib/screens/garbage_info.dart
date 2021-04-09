import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:mke_garbage_pickup_3000/api/garbage_data.dart';
import 'package:mke_garbage_pickup_3000/models/user_street_info.dart';

class MyGarbageInfo extends StatefulWidget {
  final UserStreetInfo userStreetInfo;

  MyGarbageInfo({Key? key, required this.userStreetInfo}) : super(key: key);

  @override
  _MyGarbageInfo createState() => _MyGarbageInfo();
}

class _MyGarbageInfo extends State<MyGarbageInfo> {
  late Future<String> futureGarbageInfoData;

  @override
  void initState() {
    super.initState();
    futureGarbageInfoData = fetchGarbageInfoData(widget.userStreetInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Garbage Info'),
      ),
      body: FutureBuilder<String>(
        future: futureGarbageInfoData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Html(
                  data: snapshot.data ?? '',
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}