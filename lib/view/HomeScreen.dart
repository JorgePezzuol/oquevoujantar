import 'package:flutter/material.dart';
import 'package:oquevoujantar/model/Restaurant.dart';
import 'package:oquevoujantar/service/Services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<List<Food>> futureFood;
  
  // placeholder for the first index in the swiper
  Food food = new Food(id: "Loading", code: "Loading", description: "Loading", details: "Loading", unitPrice: 0.0, availability: "Loading", logoUrl: "https://tryportugal.pt/wp-content/themes/adventure-tours/assets/images/placeholder.png", restaurant: new Restaurant(id: "Loading", name: "Loading", detailUrl: "Loading", fileName: "", slug: "Loading"));
  
  SwiperController _swipeController = SwiperController();

  @override
  void initState() {
    super.initState();
    futureFood = Services.fetchFood().whenComplete(() => {
      Future.delayed(const Duration(milliseconds: 500), () {
        _swipeController.next();
      })
    });
  }


  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: true,
        enableJavaScript: true
      );
    } else {
      throw 'Could not launch $url';
    }
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
                        Text("Distância aprox: ${this.food.restaurant.distance.toString()} km", style: GoogleFonts.oswald(fontWeight: FontWeight.bold)),
                        IconButton(
                          color: Colors.white,
                          icon: Icon(FontAwesomeIcons.mapMarkerAlt),
                          onPressed: (){
                          },
                        ),
                      ]
                    )             
                  ]
                ),
                Container(
                    margin: EdgeInsets.only(top: 70),
                    child: Column(
                      children: <Widget>[
                        
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: AutoSizeText(this.food.description, maxLines: 1, style: GoogleFonts.oswald(color: Colors.white, fontSize: 28, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                        ),
                        
                        SizedBox(height: 10.0),
                        Container(
                          alignment: Alignment.topCenter,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.yellowAccent,
                              borderRadius: BorderRadius.circular(20.0)
                            ),
                            child: AutoSizeText(this.food.restaurant.name, maxLines: 1, style: GoogleFonts.oswald(fontWeight: FontWeight.bold, fontSize: 18)),
                          )
                        ),
                        SizedBox(height: 5),
                        Expanded(
                          flex: 2,
                          child: _swiper(snapshot),
                        ),
                        //Spacer
                        Expanded(
                          flex: 1,
                          child: _content(), 
                        ),
                        SizedBox(height: 5),
                        _footer(),
                      ]
                    ),
                  ),
              ]
            ) 
            : Center(child: Text("Sem resultados", style: GoogleFonts.oswald(fontWeight: FontWeight.bold, fontSize: 18)));
          }
          else if(snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString(), style: GoogleFonts.oswald(fontWeight: FontWeight.bold, fontSize: 18))
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
    return Container(
      child: Column(
        children: <Widget>[
          Spacer(),
          Expanded(
              child: Container(
                width: 250,
                child: AutoSizeText(this.food.details, style: GoogleFonts.oswald(fontSize: 20.0, fontStyle: FontStyle.normal)),
              )
          ),
      
          //SizedBox(height: 10),
          Expanded(
            child: AutoSizeText('R\$ ${this.food.unitPrice.toStringAsFixed(2)}', style: GoogleFonts.oswald(fontSize: 22, fontWeight: FontWeight.bold))
          )
          
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
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.orangeAccent, Colors.red],
                ),
                borderRadius: BorderRadius.circular(30.0)
              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                    color: Colors.white,
                    icon: Icon(FontAwesomeIcons.undo),
                    onPressed: (){
                      _swipeController.previous();
                    },
                  ),
                  IconButton(
                    color: Colors.white,
                    icon: Icon(FontAwesomeIcons.slidersH),
                    onPressed: (){},
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.bacon, color: Colors.white),
                      onPressed: (){
                      _swipeController.startAutoplay();
                      Future.delayed(Duration(milliseconds: 10000), () {
                        _swipeController.stopAutoplay();
                      });
                    },
                  ),
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.share),
                    onPressed: (){
                      Share.share(this.food.getDetailPage());
                    },
                  ),
                ],
              ),
            ),
            Center(
              child: FloatingActionButton(
                child: Icon(Icons.favorite, color: Colors.red),
                backgroundColor: Colors.white,
                onPressed: (){
                  this._launchInBrowser(this.food.getDetailPage());
                },
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
          colors: [Colors.orangeAccent, Colors.red],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft
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
              this._launchInBrowser(this.food.getDetailPage());
              snapshot.data.removeAt(index);
              _swipeController.next();
            });
          },
          child: Container(

            decoration: BoxDecoration(
              image: DecorationImage(
                    fit: BoxFit.contain,
                    image: NetworkImage(snapshot.data[index].logoUrl)
                  ),
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              color: Colors.grey[200],
            )
          )
        );
      },
      curve: Curves.linear,
      itemWidth: 300,
      itemHeight: 275,
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
      pagination: null,
      control: null,
      onIndexChanged: (int index) {
        setState(() {

          this.food = snapshot.data[index];
          if(this.food.details == "") {
            this.food.details = "Sem descrição";
          }
        });
      },
      autoplayDisableOnInteraction: true,
      duration: 500,
      controller: _swipeController,
      autoplayDelay: 1000,
      autoplay: false,
      onTap: (int index) {     
      },
    );
  }
  
}