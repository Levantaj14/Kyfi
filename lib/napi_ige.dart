import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class NapiIge extends StatefulWidget {
  const NapiIge({super.key});

  @override
  State<NapiIge> createState() => NapiIgeState();
}

class NapiIgeState extends State<NapiIge> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String oszov = '';
  String or = '';
  String ujszov = '';
  String ujr = '';
  bool net = true;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');

  Future<void> _explanationLaunch() async {
    var url = Uri.parse("https://www.evangelikus.hu/hitunk/lelki-taplalek");
    if (!await launchUrl(url)) {
      throw Exception('Nem lehetett megnyitni az oldalt');
    }
  }

  @override
  void initState() {
    super.initState();
    _getIge();
  }

  Future _getIge() async {
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
      String formattedDate = formatter.format(now);
      final response = await http.get(Uri.parse(
          'https://www.evangelikus.hu/hitunk/lelki-taplalek?napiigenap=$formattedDate'));
      dom.Document html = dom.Document.html(response.body);
      final osszSzoveg = html
          .querySelectorAll('p')
          .map((element) => element.innerHtml.trim())
          .toList();
      oszov = osszSzoveg[3].substring(0, osszSzoveg[2].indexOf('<') - 2);
      or = osszSzoveg[3].substring(osszSzoveg[2].indexOf('>') + 1);
      or = or.substring(0, or.indexOf('<') - 1);
      ujszov = osszSzoveg[4].substring(0, osszSzoveg[3].indexOf('<') - 2);
      ujr = osszSzoveg[4].substring(osszSzoveg[3].indexOf('>') + 1);
      ujr = ujr.substring(0, ujr.indexOf('<') - 1);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Napi ige',
          style: GoogleFonts.getFont('Oranienbaum'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                IconButton(
                    tooltip: "Dátum kiválasztása",
                    onPressed: () {},
                    icon: const Icon(Icons.calendar_month_outlined)),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('További információk',
                                    style: GoogleFonts.getFont('Oranienbaum')),
                                content: const Text(
                                    'A napi igék az evangélikus bibliaolvasó Útmutatóból származnak.\nTövábbi információ: evangelikus.hu'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      _explanationLaunch();
                                    },
                                    child: const Text('Weboldal kinyítása'),
                                  ),
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK')),
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
                  return _getIge();
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
                  ].animate(interval: .150.seconds).fadeIn().slideY(
                      begin: 2,
                      end: 0,
                      curve: Curves.easeOutExpo,
                      duration: 2000.ms),
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
                        Icons.cloud_off,
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
                              _getIge();
                            });
                          },
                          child:
                              const Text('De nekem be van kapcsolva a nettem'))
                    ].animate(interval: .10.seconds).fadeIn(),
                  ),
                ),
    );
  }
}
