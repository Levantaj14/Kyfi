import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Kyfi/szoveg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Kyfi/dalok.dart' as global;

class Kedvenc extends StatefulWidget {
  const Kedvenc({super.key});

  @override
  State<Kedvenc> createState() => _KedvencState();
}

class _KedvencState extends State<Kedvenc> {
  List items = global.items;
  List indexes = [];
  List liked = [];
  bool done = false;

  Future getLiked() async {
    done = false;
    liked.clear();
    indexes.clear();
    final prefs = await SharedPreferences.getInstance();
    for (int i = 1; i < items.length; i++) {
      if (prefs.getBool(i.toString()) ?? false) {
        liked.add(items[i]);
        indexes.add(i);
      }
    }
    setState(() {
      done = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getLiked();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Kedvencek', style: GoogleFonts.getFont('Oranienbaum')),
        ),
        body: done
            ? liked.isNotEmpty
                ? ListView.builder(
                    itemCount: liked.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(liked[index]["cim"]),
                        leading: Text(
                          "${indexes[index]}.",
                          style: const TextStyle(fontSize: 15),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Szoveg(
                                        i: indexes[index],
                                      ))).then((value) => setState(() {
                                getLiked();
                              }));
                        },
                      );
                    },
                  ).animate().fade()
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.favorite_border_outlined,
                          size: 50,
                        ),
                        const SizedBox(
                          height: 11,
                        ),
                        const Text('Még nem jelöltél be egy dalt se kedvencként'),
                      ].animate(interval: .10.seconds).fadeIn(),
                    ),
                  )
            : null);
  }
}
