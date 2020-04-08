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



class Food {

  final String id;
  final String code;
  final String description;
  final String details;
  final double unitPrice;
  final String availability;
  final String logoUrl;
  
  Food({this.id, this.code, this.description, this.details, this.unitPrice, this.availability, this.logoUrl});

  String getThumb() {

    return 'https://static-images.ifood.com.br/image/upload/f_auto,t_high/pratos/${this.logoUrl}';
  }

  factory Food.fromJson(Map<String, dynamic> json) {

    return Food(
      id: json['id'] as String,
      code: json['code'] as String,
      description: json['description'] as String,
      details: json['details'] as String,
      unitPrice: json['unitPrice'] as double,
      availability: json['availability'] as String
    );
  }
  
}


