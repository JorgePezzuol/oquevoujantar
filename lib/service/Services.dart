import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:oquevoujantar/model/Restaurant.dart';
import 'package:geolocator/geolocator.dart';

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

    List<http.Response> list = await Future.wait(restaurantsIds.map((restaurantId) => client.get('https://wsloja.ifood.com.br/ifood-ws-v3/restaurants/$restaurantId/menu/', headers: _headers)));

    List<Food> foodList = List<Food>();

    list.forEach((response) {

        List<dynamic> menu = json.decode(response.body)['data']['menu'];

        menu.forEach((m) {
          List<dynamic> itens = m["itens"];
          itens.forEach((item) {
            foodList.add(new Food(
              id: item['id'], 
              code: item['code'], 
              description: item['description'], 
              details: item['details'], 
              unitPrice: item['unitPrice'], 
              availability: item['availability'],
              logoUrl: 'https://static-images.ifood.com.br/image/upload/f_auto,t_high/pratos/13ebb9ba-01d3-4620-9e08-f26aa4c8d8a1/202002271026_CyBV_i.jpg'
            ));
          });
        });

    });

    return foodList;
  }

  static Future<List<Food>> fetchFood() async {

    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);

    if (position == null) {
      throw Exception("Failed to get geoposition");
    }

    List<Food> foodList;
    
    final response = await http.get(
        'https://marketplace.ifood.com.br/v1/merchants?latitude=-23.53827&longitude=-46.22185&zip_code=08790320&page=0&channel=IFOOD&size=50&sort=&categories=&payment_types=&delivery_fee_from=0&delivery_fee_to=25&delivery_time_from=0&delivery_time_to=90');
    //final response = await http.get('$_apiUrl&latitude=${position.latitude.toString()}&longitude=${position.longitude.toString()}');

    if (response.statusCode == 200) {

      RestaurantList result = RestaurantList.fromJson(json.decode(response.body)['merchants']);
      
      if(result.restaurants.length > 0) {
        foodList = await fetchMenu(result.restaurants);
      }
    } else {
      throw Exception("Failed to get data");
    }

    return foodList;
  }
}
