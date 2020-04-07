import 'package:flutter/material.dart';
import 'package:oquevoujantar/model/Restaurant.dart';
import 'package:oquevoujantar/service/Services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<RestaurantList> futureRestaurants;

  final Color _mainColor = Color(0xffFC5CF0);
  final Color _secondColor = Color(0xffFE8852);

  @override
  void initState() {
    super.initState();
    futureRestaurants = Services.fetchRestaurants();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder<RestaurantList>(
        future: futureRestaurants,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.restaurants.length > 0 
            ? Stack(
              children: <Widget>[
                _header(),
                Container(
                    margin: EdgeInsets.only(top: 80),
                    child: Column(
                      children: <Widget>[
                        Text("Um texto qualqer", style: TextStyle(color: Colors.white, fontSize: 28, fontStyle: FontStyle.italic)),
                        SizedBox(height: 20.0),
                        _swiper(snapshot),
                        _preFooter(),
                        _footer()
                      ]
                    ),
                  ),
              ]
            ) 
            : Center(child: Text("Sem resultados"));
          }
          else if(snapshot.hasError) {
            return Center(
              child: Text("error")
            );
          } 
          else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      )
    );
  }

  Widget _preFooter() {
    return Expanded(
      child: Column(
        children: <Widget>[
          SizedBox(height: 10.0),
          Text("Sasha - 22", style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0
          ),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.location_on, size: 16.0, color: Colors.grey,),
              Text("San Diego, California, USA", style: TextStyle(color: Colors.grey.shade600),)
            ],
          ),
          SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                color: Colors.grey,
                icon: Icon(FontAwesomeIcons.instagram),
                onPressed: (){},
              ),
              IconButton(
                color: Colors.grey,
                icon: Icon(FontAwesomeIcons.facebookF),
                onPressed: (){},
              ),
              IconButton(
                color: Colors.grey.shade600,
                icon: Icon(FontAwesomeIcons.twitter),
                onPressed: (){},
              ),
            ],
          ),

        ],
      ),
    );
  }


  Widget _footer() {

    return Container(
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
              margin: const EdgeInsets.only(top: 30 ,left: 20.0, right: 20.0,bottom: 20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_mainColor, _secondColor],
                ),
                borderRadius: BorderRadius.circular(30.0)
              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                    color: Colors.white,
                    icon: Icon(FontAwesomeIcons.slidersH),
                    onPressed: (){},
                  ),
                  Spacer(),
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.location_on),
                    onPressed: (){},
                  ),
                ],
              ),
            ),
            Center(
              child: FloatingActionButton(
                child: Icon(Icons.favorite, color: Colors.pink,),
                backgroundColor: Colors.white,
                onPressed: (){},
              ),
            ),
          ],
        ),
    );
  }

  Widget _header() {

    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0), bottomRight: Radius.circular(50.0)),
        gradient: LinearGradient(
          colors: [_mainColor, _secondColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
        )
      ),
    );
  }

  Widget _swiper(AsyncSnapshot<RestaurantList> snapshot) {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {

        return Dismissible(
          direction: DismissDirection.up,
          key: Key(snapshot.data.restaurants[index].id),
          onDismissed: (direction) {
            setState(() {
              snapshot.data.restaurants.removeAt(index);
            });
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(snapshot.data.restaurants[index].fileName,fit: BoxFit.fill)
          )
        );
      },
      curve: Curves.elasticOut,
      itemWidth: 300,
      itemHeight: 400,
      itemCount: snapshot.data.restaurants.length,
      layout: SwiperLayout.CUSTOM,
      customLayoutOption: CustomLayoutOption(
          startIndex: -1,
          stateCount: 3
      ).addRotate([
        -45.0/180,
        0.0,
        45.0/180
      ]).addTranslate([
        Offset(-370.0, -40.0),
        Offset(0.0, 0.0),
        Offset(370.0, -40.0)
      ]),
      pagination: null,
      control: null,
      onIndexChanged: (int index) {
        print(index);
      },
    );
  }
  
}