import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

class Fullscreen extends StatefulWidget {
    final String imageUrl;

  const Fullscreen({super.key,required this.imageUrl});

  @override
  State<Fullscreen> createState() => _FullscreenState();
}

class _FullscreenState extends State<Fullscreen> {
  Future<void> setWallpaper() async {
    try{
    int location =WallpaperManagerFlutter.homeScreen;
    var file =await DefaultCacheManager().getSingleFile(widget.imageUrl);
    bool result =await WallpaperManagerFlutter().setWallpaper(file, location);
    if(result)
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Wallpaper set successfully!')));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to set wallpaper')));
    }

    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(child: Image.network(widget.imageUrl),),

        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: () {
              setWallpaper();
              },
            child: Text('Set Wallpaper'),
          ),
        ),
      ),
    );
  }
}