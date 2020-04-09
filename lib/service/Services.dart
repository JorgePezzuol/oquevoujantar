import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:oquevoujantar/model/Restaurant.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class Services {

  static final _apiUrl =
      'https://marketplace.ifood.com.br/v1/merchants?page=0&channel=IFOOD&size=50&sort=&categories=&payment_types=&delivery_fee_from=0&delivery_fee_to=25&delivery_time_from=0&delivery_time_to=90';
      
  static final _headers = {
    'access_key': '69f181d5-0046-4221-b7b2-deef62bd60d5',
    'secret_key': '9ef4fb4f-7a1d-4e0d-a9b1-9b82873297d8'
  };

  static Future<List<Food>> fetchMenu(List<Restaurant> restaurants) async {

    final client = new http.Client();

    List<String> restaurantsIds = []; 

    restaurants.forEach((element) => restaurantsIds.add(element.id));

    List<http.Response> list = await Future.wait(restaurantsIds.map((restaurantId) => client.get('https://wsloja.ifood.com.br/ifood-ws-v3/restaurants/$restaurantId/menu?restaurantId=$restaurantId', headers: _headers, )));

    List<Food> foodList = List<Food>();

    Uri uri;
    String logoUrl;

    list.forEach((response) {

        // get the restaurant object back (we are inside the Food object here, we need some properties from Restaurant)
        uri = response.request.url;
        final restaurantId = uri.queryParameters["restaurantId"];
        Restaurant r = restaurants.firstWhere((rest) => rest.id == restaurantId);

        List<dynamic> menu = json.decode(response.body)['data']['menu'];

        menu.forEach((m) {
          List<dynamic> itens = m["itens"];
          itens.forEach((item) {

            /* work better on this */
            if(item['logoUrl'] != null) {
              logoUrl = "https://static-images.ifood.com.br/image/upload/f_auto,t_high/pratos/${item['logoUrl']}";
            }
            else if(r.fileName != null) {
              logoUrl = r.fileName;
            }
            else {
              logoUrl = "https://static-images.ifood.com.br/image/upload/f_auto,t_high/pratos/13ebb9ba-01d3-4620-9e08-f26aa4c8d8a1/202002271026_CyBV_i.jpg";
            }
          
            if(logoUrl == "https://static-images.ifood.com.br/image/upload/f_auto,t_high/pratos/") {
              logoUrl = "https://tryportugal.pt/wp-content/themes/adventure-tours/assets/images/placeholder.png";
            }
            /* */

            foodList.add(new Food(
              id: item['id'], 
              code: item['code'], 
              description: item['description'] == "" ? "Sem descrição" : item['description'], 
              details: item['details'] == "" ? "Sem descrição" : item['details'], 
              unitPrice: item['unitPrice'] == "" ? 0.00 : item['unitPrice'], 
              availability: item['availability'],
              logoUrl: logoUrl,
              restaurant: r
            ));
          });
        });

    });
    
    return foodList;
  }

  static List shuffle(List items) {
    var random = new Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {

      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

  static Future<List<Food>> fetchFood() async {

    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);

    if (position == null) {
      throw Exception("Failed to get geoposition");
    }

    List<Food> foodList;
    
    final response = await http.get(
        'https://marketplace.ifood.com.br/v1/merchants?latitude=-23.53827&longitude=-46.22185&zip_code=08790320&page=0&channel=IFOOD&size=100&sort=&categories=&payment_types=&delivery_fee_from=0&delivery_fee_to=25&delivery_time_from=0&delivery_time_to=90');
    //final response = await http.get('$_apiUrl&latitude=${position.latitude.toString()}&longitude=${position.longitude.toString()}');

    if (response.statusCode == 200) {

      RestaurantList result = RestaurantList.fromJson(json.decode(response.body)['merchants']);
      
      if(result.restaurants.length > 0) {
        foodList = await fetchMenu(result.restaurants);
      }
    } else {
      throw Exception("Failed to get data");
    }

    return shuffle(foodList);
  }
}
