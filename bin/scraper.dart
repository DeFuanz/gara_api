import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

void main() async {
  var url = Uri.parse('https://www.carmodelslist.com/car-manufacturers/');

  Map<String, List<String>> carBrands = {};

  var brand = 'Chevrolet';

  //Left of implementing only pulling by selected country

  try {
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var document = parser.parse(response.body);

      var brandElements =
          document.querySelectorAll('[title="$brand Car Models List"]');

      if (brandElements.isNotEmpty) {
        var brandElement = brandElements.first;
        print(brandElement.attributes['href']);

        var brandUrl = brandElement.attributes['href'];
        var brandResponse = await http.get(Uri.parse(brandUrl!));

        if (brandResponse.statusCode == 200) {
          var brandDocument = parser.parse(brandResponse.body);

          var listItems = brandDocument.querySelectorAll('li');

          List<Element> filteredItems = listItems.where((item) {
            return item.text.contains(brand);
          }).toList();

          print(filteredItems.first.text);
        }
      }
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }

  carBrands.forEach((key, value) {
    print('$key: $value');
  });
}
