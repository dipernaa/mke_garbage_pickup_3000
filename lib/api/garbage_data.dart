import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'package:mke_garbage_pickup_3000/models/user_street_info.dart';

Future<String> fetchGarbageInfoData(UserStreetInfo userStreetInfo) async {
  final response = await http.post(
    Uri.https('itmdapps.milwaukee.gov', 'DpwServletsPublic/garbage_day?embed=y'),
    body: <String, dynamic>{
      'laddr': userStreetInfo.addressNumber,
      'sdir': userStreetInfo.direction.toUpperCase(),
      'sname': userStreetInfo.streetName.toUpperCase(),
      'stype': userStreetInfo.suffix.toUpperCase(),
      'embed': 'Y',
      'Submit': 'Submit',
    }
  );

  if (response.statusCode == 200) {
    return parse(response.body).getElementById('nConf')?.innerHtml ?? '';
  } else {
    throw Exception('Failed to load street form data');
  }
}