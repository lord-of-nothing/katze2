import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPage extends StatelessWidget {
  final Map data;
  const DetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
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
