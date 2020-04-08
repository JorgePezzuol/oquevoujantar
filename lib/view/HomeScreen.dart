import 'package:flutter/material.dart';
import 'package:oquevoujantar/model/Restaurant.dart';
import 'package:oquevoujantar/service/Services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<List<Food>> futureFood;
  String _description = "";
  String _details = "";
  double _unitPrice = 0.0;

  final Color _mainColor = Color(0xffff3300);
  final Color _secondColor = Color(0xffff5050);

  @override
  void initState() {
    super.initState();
    futureFood = Services.fetchFood();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder<List<Food>>(
        future: futureFood,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.length > 0 
            ? Stack(
              children: <Widget>[
                _header(),
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: <Widget>[  
                    Row(children: <Widget>[
                        Text("Rua Desembargador Francisco Ferreira"),
                        IconButton(
                          icon: Icon(Icons.location_on, size: 35),
                          onPressed: (){},
                        ),
                      ]
                    )             
                  ]
                ),
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 80),
                    child: Column(
                      children: <Widget>[
                        SizedBox(width: 250, child: AutoSizeText(this._description, maxLines: 1, style: TextStyle(color: Colors.white, fontSize: 28, fontStyle: FontStyle.italic))),
                        SizedBox(height: 25.0),
                        Container(
                          alignment: Alignment.topCenter,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(20.0)
                            ),
                            child: Text("Nome do restaurante"),
                          )
                        ),
                        _swiper(snapshot),
                        _content(),
                        SizedBox(height: 10),
                        _footer(),
                        
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

  Widget _content() {
    return Expanded(
      child: Column(
        children: <Widget>[
          SizedBox(height: 10.0),
          Container(
            width: 250,
          
            child: AutoSizeText(this._details, maxLines: 4, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0)),
          ),
          Spacer(),
          Text('R\$${this._unitPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
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
                    icon: Icon(FontAwesomeIcons.undo),
                    onPressed: (){},
                  ),
                  IconButton(
                    color: Colors.white,
                    icon: Icon(FontAwesomeIcons.slidersH),
                    onPressed: (){},
                  ),
                  Spacer(),
                  IconButton(
                    color: Colors.white,
                    icon: Icon(FontAwesomeIcons.bacon),
                    onPressed: (){},
                  ),
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.share),
                    onPressed: (){},
                  ),
                ],
              ),
            ),
            Center(
              child: FloatingActionButton(
                child: Icon(Icons.favorite, color: Colors.red),
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

  Widget _swiper(AsyncSnapshot<List<Food>> snapshot) {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {

        return Dismissible(
          direction: DismissDirection.up,
          key: Key(snapshot.data[index].id),
          onDismissed: (direction) {
            setState(() {
              snapshot.data.removeAt(index);
            });
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(snapshot.data[index].logoUrl,fit: BoxFit.fill)
            //child: Text(snapshot.data[index].description)
          )
        );
      },
      curve: Curves.elasticOut,
      itemWidth: 300,
      itemHeight: 300,
      itemCount: snapshot.data.length,
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
      onTap: (int index) {
        print(index);
      },
      pagination: null,
      control: null,
      onIndexChanged: (int index) {
        setState(() {
          this._description = snapshot.data[index].description;
          this._details = snapshot.data[index].details;
          this._unitPrice = snapshot.data[index].unitPrice;
        });
      },

    );
  }
  
}