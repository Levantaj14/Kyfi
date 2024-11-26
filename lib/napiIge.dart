import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class napiIge extends StatefulWidget {
  const napiIge({super.key});

  @override
  State<napiIge> createState() => NapiIgeState();
}

class NapiIgeState extends State<napiIge> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String oszov = '';
  String or = '';
  String ujszov = '';
  String ujr = '';
  bool net = true;

  //bool visible = false;

  /*Future getExpl() async {
    final prefs = await SharedPreferences.getInstance();
    visible = prefs.getBool("Explanation") ?? false;
    setState(() {});
  }*/

  Future<void> _explanationLaunch() async {
    var url = Uri.parse('https://www.evangelikus.hu/hitunk/lelki-taplalek');
    if (!await launchUrl(url)) {
      throw Exception('Nem lehetett megnyitni az oldalt');
    }
  }

  @override
  void initState() {
    //getExpl();
    super.initState();
    getIge();
  }

  Future getIge() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult[0] == ConnectivityResult.none) {
      setState(() {
        if (ujr != '') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  'Úgy néz ki, hogy mostmár nem vagy az internetre kopcsolódva')));
        }
        net = false;
      });
    } else {
      final url = Uri.parse('https://www.evangelikus.hu/hitunk/lelki-taplalek');
      //final url = Uri.parse('https://www.evangelikus.hu/hitunk/lelki-taplalek?napiigenap=2024-09-30');
      final response = await http.get(url);
      dom.Document html = dom.Document.html(response.body);
      /*final elso = html
          .querySelector('p:nth-child(2)')
          .map((element) => element.innerHtml.trim())
          .toList();
      oszov = elso[0].substring(0, elso[0].indexOf('<') - 2);
      or = elso[0].substring(elso[0].indexOf('>') + 1);
      or = or.substring(0, or.indexOf('<'));
      final masodik = html
          .querySelectorAll('p:nth-child(4)')
          .map((element) => element.innerHtml.trim())
          .toList();
      ujszov = masodik[0].substring(0, masodik[0].indexOf('<') - 2);
      ujr = masodik[0].substring(masodik[0].indexOf('>') + 1);
      ujr = ujr.substring(0, ujr.indexOf('<'));
      setState(() {});*/
      final osszSzoveg = html.querySelectorAll('p').map((element) => element.innerHtml.trim()).toList();
      oszov = osszSzoveg[2].substring(0, osszSzoveg[2].indexOf('<') - 2);
      or = osszSzoveg[2].substring(osszSzoveg[2].indexOf('>') + 1);
      or = or.substring(0, or.indexOf('<') - 1);
      ujszov = osszSzoveg[3].substring(0, osszSzoveg[3].indexOf('<') - 2);
      ujr = osszSzoveg[3].substring(osszSzoveg[3].indexOf('>') + 1);
      ujr = ujr.substring(0, ujr.indexOf('<') - 1);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Napi ige'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                IconButton(
                    tooltip: "Az oldal kinyítása",
                    onPressed: () {
                      _explanationLaunch();
                    },
                    icon: const Icon(Icons.language_outlined)),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: const Text(
                                    'A napi igék az evangélikus bibliaolvasó Útmutatóból származnak.\nTövábbi információ: evangelikus.hu'),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'))
                                ],
                              ));
                    },
                    icon: const Icon(Icons.info_outline))
              ],
            ),
          )
        ],
      ),
      body: (ujr != '')
          ? Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: RefreshIndicator(
                onRefresh: () {
                  return getIge();
                },
                child: ListView(
                  children: [
                    Card(
                      child: InkWell(
                        onLongPress: () {
                          Clipboard.setData(
                              ClipboardData(text: "$oszov ($or)"));
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          const snackBar =
                              SnackBar(content: Text('Átmásolva a vágólapra'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(13, 8, 8, 8),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(oszov),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  or,
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                )
                              ]),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Card(
                      child: InkWell(
                        onLongPress: () {
                          Clipboard.setData(
                              ClipboardData(text: "$ujszov ($ujr)"));
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          const snackBar =
                              SnackBar(content: Text('Átmásolva a vágólapra'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(13, 8, 8, 13),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ujszov),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  ujr,
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                )
                              ]),
                        ),
                      ),
                    ),
                    /*Visibility(
                        visible: visible,
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text("Magyarázat")],
                        ))*/
                  ],
                ),
              ),
            )
          : (net)
              ? const Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 11,
                        ),
                        Text('Igék letöltése')
                      ]),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.question_mark_outlined,
                        size: 50,
                      ),
                      const SizedBox(
                        height: 11,
                      ),
                      const Text(
                        'Úgy néz ki, hogy nem vagy\ninternetre kapcsolódva',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              net = true;
                              getIge();
                            });
                          },
                          child:
                              const Text('De nekem be van kapcsolva a nettem'))
                    ],
                  ),
                ),
    );
  }
}
