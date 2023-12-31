import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'extensions/color.dart';
import 'logger/logger.dart';
import 'utils/number.dart';

class ColorAsset {
  Color color;
  String name;
  String intro;
  String hex;
  List<int> rgb;
  ColorAsset? parent;

  ColorAsset({
    required this.color,
    required this.name,
    required this.intro,
  })  : hex = color.toHex(),
        rgb = [color.red, color.green, color.blue];

  static List<ColorAsset> assets = [];
  static bool loaded = false;
  static Color defaultColor = Colors.white;

  static random() {
    if (assets.isEmpty) {
      return defaultColor;
    }
    return assets[getRandom(end: assets.length)].color;
  }

  static Future<dynamic?> loadColors() async {
    if (loaded) {
      return;
    }
    final data = await rootBundle.loadString('assets/colors.json');
    List<dynamic> series = jsonDecode(data);
    for (dynamic item in series) {
      List<dynamic> colors = item["colors"];
      String name = item['name'];
      String hex = item['hex'];
      var parent = ColorAsset(color: parseColor(hex), name: name, intro: name);
      for (dynamic colorItem in colors) {
        String name = colorItem['name'];
        String intro = colorItem['intro'];
        String hex = colorItem['hex'];
        var a = ColorAsset(color: parseColor(hex), name: name, intro: intro);
        a.parent = parent;
        assets.add(a);
      }
    }
    loaded = true;
    logger.i('colors loaded');
  }
}

class ColorsPage extends StatelessWidget {
  const ColorsPage({super.key});

  Widget renderColorAsset(ColorAsset asset, BuildContext context) {
    String hex = asset.parent!.name.contains('白') ? "#50616d" : "#ffffff";
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(asset.color);
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: asset.color),
        width: 100,
        height: 140,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              asset.name,
              style: TextStyle(
                  fontSize: 24,
                  color: parseColor(hex),
                  decoration: TextDecoration.none),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                asset.hex,
                textAlign: TextAlign.center,
                maxLines: 3,
                style: TextStyle(
                    fontSize: 10,
                    color: parseColor(hex).withOpacity(0.8),
                    overflow: TextOverflow.ellipsis,
                    decoration: TextDecoration.none),
              ),
            ),
            // SizedBox(
            //   height: 40,
            //   child: Text(
            //     asset.intro,
            //     textAlign: TextAlign.center,
            //     maxLines: 3,
            //     style: TextStyle(
            //         fontSize: 8,
            //         color: Colors.white.withOpacity(0.8),
            //         overflow: TextOverflow.ellipsis,
            //         decoration: TextDecoration.none),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: Wrap(
            children: [
              ...ColorAsset.assets.map((e) => renderColorAsset(e, context))
            ],
          ),
        ),
      ),
    );

    // return Container(
    //   width: 200.0,
    //   height: 200.0,
    //   decoration: const BoxDecoration(
    //     gradient: LinearGradient(
    //       begin: Alignment.centerLeft,
    //       end: Alignment.centerRight,
    //       colors: <Color>[
    //         Colors.red,
    //         Colors.yellow,
    //       ],
    //     ),
    //   ),
    // );
  }
}
