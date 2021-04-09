import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mke_garbage_pickup_3000/api/street_data.dart';
import 'package:mke_garbage_pickup_3000/models/street_form_data.dart';
import 'package:mke_garbage_pickup_3000/models/user_street_info.dart';
import 'package:mke_garbage_pickup_3000/screens/garbage_info.dart';

class MyStreetForm extends StatefulWidget {
  MyStreetForm({Key? key}) : super(key: key);

  @override
  _MyStreetForm createState() => _MyStreetForm();
}

class _MyStreetForm extends State<MyStreetForm> {
  late Future<StreetFormData> futureStreetFormData;
  final _formKey = GlobalKey<FormState>();

  String? _addressNumber;
  String? _direction;
  String? _streetName;
  String? _suffix;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    futureStreetFormData = fetchStreetFormData();
  }

  _loadPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      _addressNumber = sharedPreferences.getString('addressNumber');
      _direction = sharedPreferences.getString('direction');
      _streetName = sharedPreferences.getString('streetName');
      _suffix = sharedPreferences.getString('suffix');
    });
  }

  _savePreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString('addressNumber', this._addressNumber!);
    sharedPreferences.setString('direction', this._direction!);
    sharedPreferences.setString('streetName', this._streetName!);
    sharedPreferences.setString('suffix', this._suffix!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MKE Garbage Pickup 3000'),
      ),
      body: FutureBuilder<StreetFormData>(
        future: futureStreetFormData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Address Number',
                      ),
                      initialValue: this._addressNumber,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a value';
                        }

                        int parsedValue = int.tryParse(value) ?? 0;
                        if (parsedValue < 1) {
                          return 'Please enter a valid number';
                        }

                        return null;
                      },
                      onSaved: (value) => this._addressNumber = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Direction',
                      ),
                      initialValue: this._direction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }

                        if (!(snapshot.data?.directions ?? []).contains(value.toUpperCase())) {
                          return 'That is not a valid street direction';
                        }

                        return null;
                      },
                      onSaved: (value) => this._direction = value,
                    ),
                    TextFormField(
                      initialValue: this._streetName,
                      decoration: InputDecoration(
                        labelText: 'Street Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }

                        if (!(snapshot.data?.streetNames ?? []).contains(value.toUpperCase())) {
                          return 'That is not a valid street name';
                        }

                        return null;
                      },
                      onSaved: (value) => this._streetName = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Street Suffix',
                      ),
                      initialValue: this._suffix,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }

                        if (!(snapshot.data?.suffixes ?? []).contains(value.toUpperCase())) {
                          return 'That is not a valid street suffix';
                        }

                        return null;
                      },
                      onSaved: (value) => this._suffix = value,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(top: 8.0),
                      child: ElevatedButton(
                        child: Text('Submit'),
                        onPressed: () async {
                          if (this._formKey.currentState!.validate()) {
                            setState(() {
                              this._formKey.currentState!.save();
                            });

                            await _savePreferences();

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyGarbageInfo(
                                    userStreetInfo: UserStreetInfo(
                                      addressNumber: this._addressNumber!,
                                      direction: this._direction!,
                                      streetName: this._streetName!,
                                      suffix: this._suffix!,
                                    ),
                                  ),
                                )
                            );
                          }
                        },
                      ),
                    ),
                  ],
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
