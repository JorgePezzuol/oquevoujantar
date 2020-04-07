class Restaurant {
  final String id;
  final String name;
  final String fileName;
  final String slug;

  Restaurant({this.id, this.name, this.fileName, this.slug});

  factory Restaurant.fromJson(Map<String, dynamic> json) {

    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      //fileName: json['resources'][0]['fileName'] as String,
      fileName: 'https://static-images.ifood.com.br/image/upload/f_auto,t_thumbnail/logosgde/${json['resources'][0]['fileName']}',
      slug: json['slug'] as String
    );
  }
}

class RestaurantList {
  final List<Restaurant> restaurants;

  RestaurantList({
    this.restaurants,
  });

  factory RestaurantList.fromJson(List<dynamic> parsedJson) {

    List<Restaurant> restaurants = List<Restaurant>();

    restaurants = parsedJson.map((i) => Restaurant.fromJson(i)).toList();

    return RestaurantList(
       restaurants: restaurants,
    );
  }

}

