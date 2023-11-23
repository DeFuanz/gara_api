import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';

void main() async {
  var url = Uri.parse('https://en.wikipedia.org/wiki/List_of_car_brands');

  var country = 'United States';

  //Left of implementing only pulling by selected country

  try {
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var document = parser.parse(response.body);

      var activeBrandElements = document.querySelectorAll('h3');

      if (activeBrandElements.isNotEmpty) {
        for (var activeBrandElement in activeBrandElements) {
          var activeBrandText = activeBrandElement.text;

          if (activeBrandText.contains('Active brands')) {
            var ulElement = activeBrandElement.nextElementSibling;

            while (ulElement != null && ulElement.localName != 'ul') {
              ulElement = ulElement.nextElementSibling;
            }

            if (ulElement != null) {
              var liElements = ulElement.querySelectorAll('li');

              for (var liElement in liElements) {
                var linkElement = liElement.querySelector('a');

                if (linkElement != null) {
                  var text = linkElement.text;
                  print('Make: $text');
                }
              }
            }
          }
        }
      } else {
        print('Elements not found');
      }
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
