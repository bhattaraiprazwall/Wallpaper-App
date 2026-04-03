import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:wallpaper_app/fullscreen.dart';

class Wallpaper extends StatefulWidget {
  const Wallpaper({super.key});

  @override
  State<Wallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  List<dynamic> photos = [];
  int page = 1;
  @override
  void initState() {
    super.initState();
    fetchPhotos();
  }

  var logger = Logger();
  Future<void> fetchPhotos() async {
    // Future.delayed(Duration(seconds: 10)); //
    await http
        .get(
          Uri.parse("https://api.pexels.com/v1/curated?per_page=80"),
          headers: {
            'Authorization':
                '7ks0RPP5tE1LoBfjwElBqLZNGjmSzu3IGfoGTDkgdiFfCZqvwxaf6OjU',
          },
        )
        .then((value) {
          Map result = jsonDecode(value.body);
          setState(() {
            photos = result['photos'];
          });
          print(photos[0]);
        });
  }

  Future<void> loadMore() async {
    setState(() {
      page = page + 1;
    });
    String url =
        'https://api.pexels.com/v1/curated?per_page=80&page=' + page.toString();
    await http
        .get(
          Uri.parse(url),
          headers: {
            'Authorization':
                '7ks0RPP5tE1LoBfjwElBqLZNGjmSzu3IGfoGTDkgdiFfCZqvwxaf6OjU',
          },
        )
        .then((value) {
          Map result = jsonDecode(value.body);
          setState(() {
            photos.addAll(result['photos']);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: photos.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 2 / 3,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Fullscreen(
                            imageUrl: photos[index]['src']['large2x'],
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    color: Colors.amber,
                    child: Image.network(
                      fit: BoxFit.cover,
                      photos[index]['src']['tiny'],
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return CircularProgressIndicator();
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: () {
              loadMore();
            },
            child: Text('Load More'),
          ),
        ),
      ),
    );
  }
}
