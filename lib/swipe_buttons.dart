import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

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
              Ink(
                  decoration: const ShapeDecoration(
                      color: Colors.white, shape: CircleBorder()),
                  child: IconButton(
                    onPressed: () {
                      swiperController.swipe(CardSwiperDirection.right);
                    },
                    icon: Icon(Icons.favorite, color: Colors.red),
                  )),
            ],
          ),
        ));
  }
}
