import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:oquevoujantar/model/Restaurant.dart';
import 'package:geolocator/geolocator.dart';

class Services {

  static final apiUrl = 'https://marketplace.ifood.com.br/v1/merchants?page=0&channel=IFOOD&size=50&sort=&categories=&payment_types=&delivery_fee_from=0&delivery_fee_to=25&delivery_time_from=0&delivery_time_to=90';
  
  static Future<RestaurantList> fetchRestaurants() async {

    Position position =  await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);

    if(position == null) {
      throw Exception("Failed to get geoposition");
    }

    final response = await http.get('https://marketplace.ifood.com.br/v1/merchants?latitude=-23.53827&longitude=-46.22185&zip_code=08790320&page=0&channel=IFOOD&size=50&sort=&categories=&payment_types=&delivery_fee_from=0&delivery_fee_to=25&delivery_time_from=0&delivery_time_to=90');
    //final response = await http.get('$apiUrl&latitude=${position.latitude.toString()}&longitude=${position.longitude.toString()}');

    if (response.statusCode == 200) {
      return RestaurantList.fromJson(json.decode(response.body)['merchants']);
    } else {
      throw Exception("Failed to get data");
    }
  }
}
