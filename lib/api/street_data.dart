import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'package:mke_garbage_pickup_3000/models/street_form_data.dart';

List<String> getSelectOptionValues(dom.Element? select) {
  if (select == null) {
    return [];
  }

  Iterable<String> optionValues = select.children.where((dom.Element currentElement) => (
      (currentElement.attributes['value'] ?? '').length > 0
  )).map((currentElement) => (
      currentElement.attributes['value']!
  ));

  return optionValues.toList();
}

Future<StreetFormData> fetchStreetFormData() async {
  final response = await http.get(Uri.https('itmdapps.milwaukee.gov', 'DpwServletsPublic/garbage_day?embed=y'));

  if (response.statusCode == 200) {
    var form = parse(response.body);

    return StreetFormData(
        directions: getSelectOptionValues(form.getElementById('sdir')),
        streetNames: getSelectOptionValues(form.getElementById('sname')),
        suffixes: getSelectOptionValues(form.getElementById('stype'))
    );
  } else {
    throw Exception('Failed to load street form data');
  }
}