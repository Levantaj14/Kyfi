import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:Kyfi/szoveg.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:Kyfi/MyStatefulBuilder.dart';
import 'package:smooth_counter/smooth_counter.dart';

class Terms {
  String cim;
  int index;

  Terms({required this.cim, required this.index});
}

List items = [];
List<Terms> searchTerms = [];

class Dalok extends StatefulWidget {
  const Dalok({super.key});

  @override
  State<Dalok> createState() => _DalokState();
}

class _DalokState extends State<Dalok> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  int leSzam = 1;
  bool nyomhato = true;
  final random = Random();
  bool mehet = false;
  int nextRandom = 0;
  Timer? _delayed;

  Future<void> readText() async {
    final String response = await rootBundle.loadString('assets/szoveg.json');
    final data = await jsonDecode(response);
    setState(() {
      items = data["szoveg"];
    });
    initSearch();
  }

  Future initSearch() async {
    searchTerms.clear();
    for (int i = 1; i < items.length; i++) {
      searchTerms.add(Terms(cim: items[i]["cim"], index: i));
    }
  }

  final _controller = SmoothCounterController(
    duration: const Duration(seconds: 2),
  );

  void _handleButtonPress() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => szoveg(
                  i: nextRandom,
                )));
  }

  @override
  void dispose() {
    /*_controller.dispose();*/
    super.dispose();
  }

  @override
  void initState() {
    /*_controller.count = 0;*/
    super.initState();
    readText();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dalok'),
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                    useSafeArea: true,
                    context: context,
                    showDragHandle: true,
                    builder: (BuildContext context) {
                      return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: MyStatefulBuilder(dispose: () {
                            _delayed?.cancel();
                            /*_controller.count = 0;*/
                            mehet = false;
                          }, builder: (context, state) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Lássuk a szerencsés számot',
                                    style: TextStyle(fontSize: 18)),
                                const SizedBox(
                                  height: 5,
                                ),
                                SmoothCounter(
                                    controller: _controller,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .headlineMedium),
                                const SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FilledButton(
                                        onPressed: () {
                                          _delayed?.cancel();
                                          state(() {
                                            mehet = false;
                                            nextRandom = 1 +
                                                random
                                                    .nextInt(items.length - 2);
                                            _controller.count = nextRandom;
                                          });
                                          _delayed = Timer(
                                              const Duration(seconds: 2), () {
                                            state(() {
                                              mehet = true;
                                            });
                                          });
                                        },
                                        child: const Text('Tippelj!')),
                                    const SizedBox(width: 15),
                                    FilledButton(
                                        onPressed: (mehet)
                                            ? () {
                                                mehet = false;
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            szoveg(
                                                                i: nextRandom)));
                                              }
                                            : null,
                                        child: const Text('Szökj oda'))
                                  ],
                                )
                              ],
                            );
                          }));
                    });
              },
              icon: const Icon(Icons.casino_outlined),
            ),
            Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  icon: const Icon(Icons.search_outlined),
                  onPressed: () {
                    showSearch(
                        context: context, delegate: CustomSearchDelegate());
                  },
                ))
          ],
        ),
        body: items.isNotEmpty
            ? ListView.builder(
                itemCount: items.length - 1,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index + 1]["cim"]),
                    leading: Text(
                      "${index + 1}.",
                      style: const TextStyle(fontSize: 15),
                    ),
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => szoveg(
                                    i: index + 1,
                                  )));
                    },
                  );
                })
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 11),
                    Text('Dalok betöltése')
                  ],
                ),
              ));
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Terms> matchQuery = [];
    for (var songs in searchTerms) {
      if (removeDiacritics(songs.cim.toLowerCase().replaceAll(" ", ""))
              .contains(
                  removeDiacritics(query.toLowerCase().replaceAll(" ", ""))) ||
          songs.index.toString().contains(query)) {
        matchQuery.add(songs);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.cim),
          leading: Text(
            "${result.index}.",
            style: const TextStyle(fontSize: 15),
          ),
          onTap: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => szoveg(
                          i: result.index,
                        )));
          },
        );
      },
    );
  }
}
