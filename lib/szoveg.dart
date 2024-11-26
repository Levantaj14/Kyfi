import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Kyfi/dalok.dart' as global;

class szoveg extends StatefulWidget {
  final int i;

  const szoveg({super.key, required this.i});

  @override
  State<szoveg> createState() => _szovegState();
}

class _szovegState extends State<szoveg> {
  int i = 1;
  double meret = 16;
  bool szeret = false;
  bool vanIro = false;
  String cim = "";
  String iro = "";
  String szoveg = "";
  String key = "";

  Future<void> readText() async {
    i = widget.i;
    cim = global.items[i]["cim"];
    szoveg = global.items[i]["szoveg"];
    vanIro = global.items[i]["vanIro"];
    if (vanIro) {
      iro = global.items[i]["iro"];
    }
    key = i.toString();
    getInfos();
  }

  Future setBoolTrue() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, true);
  }

  Future setBoolFalse() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, false);
  }

  Future setFont() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble("Fmeret", meret);
  }

  Future getInfos() async {
    final prefs = await SharedPreferences.getInstance();
    szeret = prefs.getBool(key) ?? false;
    meret = prefs.getDouble("Fmeret") ?? 16;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    readText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: key == "0" ? Text(cim) : Text('$key. $cim'),
          actions: [
            IconButton(
              icon: const Icon(Icons.text_fields_outlined),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 180,
                        child: StatefulBuilder(builder: (context, state) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Válaszd ki a szöveg méretét!',
                                style: TextStyle(fontSize: meret),
                              ),
                              Slider(
                                value: meret,
                                min: 16,
                                max: 24,
                                onChanged: (newMeret) {
                                  setState(() {});
                                  state(() {
                                    meret = newMeret;
                                  });
                                },
                                onChangeEnd: (newMeret) {
                                  setFont();
                                },
                              )
                            ],
                          );
                        }),
                      );
                    });
              },
            ),
            (i != 0)
                ? Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onLongPress: () {
                        setState(() {
                          szeret = !szeret;
                        });
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        if (szeret) {
                          setBoolTrue();
                        } else {
                          setBoolFalse();
                        }
                        final snackBar = SnackBar(
                            content: (szeret)
                                ? const Text('Big ✨Slay✨ 🤪')
                                : const Text('No big ✨Slay✨ 😭'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              szeret = !szeret;
                            });
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();
                            if (szeret) {
                              setBoolTrue();
                            } else {
                              setBoolFalse();
                            }
                            final snackBar = SnackBar(
                                content: (szeret)
                                    ? const Text(
                                        'A dal sikeresen be lett jelölve kedvencként')
                                    : const Text(
                                        'A dal sikeresen ki lett törölve a kedvenceid közül'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                          icon: (szeret)
                              ? const Icon(Icons.favorite)
                              : const Icon(Icons.favorite_outline)),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Padding(
            padding: EdgeInsets.only(
                left: 10, right: 10, bottom: (vanIro) ? 20 : 50),
            child: Text(
              szoveg,
              style: TextStyle(fontSize: meret),
            ),
          ),
          (vanIro)
              ? Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 50),
                  child: Text(
                    'Írta: $iro',
                    style: TextStyle(fontSize: meret - 2, color: Colors.grey),
                  ))
              : const SizedBox(
                  height: 15,
                )
        ]))
      ],
    ));
  }
}
