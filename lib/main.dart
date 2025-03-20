import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Katze',
      theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 244, 232, 193)),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final String apiKey =
      "live_97KadH3nCu0lwgXFmuEgToPyFe35AB5PDDnSNbFK3msuAiuf2Qfy9WRH0doOEkC7";

  final maxImagesInQueue = 5;
  final _swiperController = CardSwiperController();
  List nextCards = [];

  fetchImage() async {
    var url = Uri.https(
        "api.thecatapi.com", "v1/images/search", {"has_breeds": "true"});
    var response = await http.get(url, headers: {'x-api-key': apiKey});

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body)[0];
      if (responseData.isNotEmpty) {
        setState(() {
          Map newCard = {
            'url': responseData['url'],
            'breeds': responseData['breeds']
          };
          precacheImage(NetworkImage(newCard['url']), context);
          nextCards.add(newCard);
          print(responseData);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < maxImagesInQueue; ++i) {
      fetchImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      nextCards.length < 2
          ? Expanded(child: Center(child: CircularProgressIndicator()))
          : Expanded(
              // width: double.infinity,
              // height: double.infinity,
              // width: 800,
              // height: 600,
              child: CardSwiper(
              padding: EdgeInsets.zero,
              cardsCount: nextCards.length,
              controller: _swiperController,
              cardBuilder:
                  (context, index, percentThresholdX, percentThresholdY) {
                return GestureDetector(onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(data: nextCards[index])));
                }, child: LayoutBuilder(builder: (context, constraints) {
                  double labelHeight = constraints.maxHeight * 0.3;
                  double counterHeight = constraints.maxHeight * 0.1;

                  return Card(
                      child: Stack(alignment: Alignment.center, children: [
                    Positioned.fill(
                        child: CachedNetworkImage(
                            imageUrl: nextCards[index]['url'],
                            fit: BoxFit.cover,
                            alignment: Alignment.center)),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: counterHeight,
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Colors.brown.withAlpha(128),
                              Colors.brown.withAlpha(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: labelHeight,
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Colors.brown.withAlpha(0),
                              // Colors.black12,
                              // Colors.black45
                              Colors.brown,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 15,
                        child: Text(nextCards[index]['breeds'][0]['name'],
                            style: GoogleFonts.rowdies(
                                color: Color.fromARGB(255, 244, 232, 193),
                                fontSize: 30.0))),
                    Positioned(
                        bottom: 15,
                        left: 15,
                        right: 15,
                        child:
                            SwipeButtons(swiperController: _swiperController))
                  ]));
                }));
              },
              allowedSwipeDirection:
                  AllowedSwipeDirection.symmetric(horizontal: true),
              onSwipe: _onSwipe,
            )),
    ]));
  }

  bool _onSwipe(
      int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    if (nextCards.length <= 1) {
      return false;
    }
    setState(() {
      nextCards.remove(0);
    });
    fetchImage();
    return true;
  }
}

class DetailPage extends StatelessWidget {
  final Map data;
  const DetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.all(15.0),
          child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                CachedNetworkImage(imageUrl: data["url"], fit: BoxFit.cover),
                Text(data["breeds"][0]["name"],
                    style: GoogleFonts.rowdies(
                        color: Colors.brown,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold)),
                Divider(color: Colors.brown.withAlpha(128)),
                Text(
                  data["breeds"][0]["description"],
                  style:
                      GoogleFonts.rowdies(color: Colors.brown, fontSize: 25.0),
                  textAlign: TextAlign.justify,
                ),
              ])),
        ));
  }
}

class SwipeButtons extends StatelessWidget {
  final CardSwiperController swiperController;

  const SwipeButtons({super.key, required this.swiperController});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Ink(
                  decoration: const ShapeDecoration(
                      color: Colors.white, shape: CircleBorder()),
                  child: IconButton(
                      onPressed: () {
                        swiperController.swipe(CardSwiperDirection.left);
                      },
                      icon: Icon(Icons.heart_broken, color: Colors.black))),
              // label: Text("I'm a horrible person"))),
              Ink(
                  decoration: const ShapeDecoration(
                      color: Colors.white, shape: CircleBorder()),
                  child: IconButton(
                    onPressed: () {
                      swiperController.swipe(CardSwiperDirection.right);
                    },
                    icon: Icon(Icons.favorite, color: Colors.red),
                    // label: Text('Like'),
                  )),
            ],
          ),
        ));
  }
}
