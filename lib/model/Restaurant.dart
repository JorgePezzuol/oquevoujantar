class Restaurant {
  String id;
  String name;
  String fileName;
  String slug;
  String detailUrl;
  double distance;


  Restaurant({this.id, this.name, this.fileName, this.slug, this.detailUrl, this.distance});

  factory Restaurant.fromJson(Map<String, dynamic> json) {

    Map<String, dynamic> resources = json['resources'][0];
    String fileName = "";
    if(resources.containsKey("fileName")) {
      fileName = "https://static-images.ifood.com.br/image/upload/f_auto,t_thumbnail/logosgde/${resources['fileName']}";
    }

    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      fileName: fileName,
      slug: json['slug'] as String,
      detailUrl: "https://www.ifood.com.br/delivery${json['slug']}/${json['id']}",
      distance: json['distance'] as double
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

  String id;
  String code;
  String description;
  String details;
  double unitPrice;
  String availability;
  String logoUrl;
  Restaurant restaurant;
  
  Food({this.id, this.code, this.description, this.details, this.unitPrice, this.availability, this.logoUrl, this.restaurant});

  String getDetailPage() {

    return "https://www.ifood.com.br/delivery/${this.restaurant.slug}/${this.restaurant.id}?prato=${this.code}";
  }

}


