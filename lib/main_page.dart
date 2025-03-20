import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'detail_page.dart';
import 'swipe_buttons.dart';

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
  int _likes = 0;

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
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCounter();
    for (var i = 0; i < maxImagesInQueue; ++i) {
      fetchImage();
    }
  }

  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _likes = prefs.getInt('likes') ?? 0;
    });
  }

  Future<void> _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _likes = (prefs.getInt('likes') ?? 0) + 1;
      prefs.setInt('likes', _likes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: <Widget>[
      nextCards.length < 2
          ? Expanded(child: Center(child: CircularProgressIndicator()))
          : Expanded(
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

                  return Card(
                      child: Stack(alignment: Alignment.center, children: [
                    Positioned.fill(
                        child: CachedNetworkImage(
                            imageUrl: nextCards[index]['url'],
                            fit: BoxFit.cover,
                            alignment: Alignment.center)),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Text("You liked $_likes cats",
                            style: GoogleFonts.rowdies(
                                color: Color.fromARGB(255, 244, 232, 193),
                                fontSize: 20.0,
                                shadows: [
                                  Shadow(
                                    blurRadius: 5.0,
                                    color: Colors.black,
                                  )
                                ]))),
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
    ])));
  }

  bool _onSwipe(
      int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    setState(() {
      nextCards.remove(0);
      if (direction == CardSwiperDirection.right) {
        _incrementCounter();
      }
    });
    fetchImage();
    return true;
  }
}
