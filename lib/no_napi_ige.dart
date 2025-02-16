import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class NapiIge extends StatelessWidget {
  const NapiIge({super.key});

  Future<void> _explanationLaunch() async {
    var url = Uri.parse("https://www.evangelikus.hu/hitunk/lelki-taplalek");
    if (!await launchUrl(url)) {
      throw Exception('Nem lehetett megnyitni az oldalt');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                                  title: Text('További információk',
                                      style:
                                          GoogleFonts.getFont('Oranienbaum')),
                                  content: const Text(
                                      'A napi igék az evangélikus bibliaolvasó Útmutatóból származnak.\nTövábbi információ: evangelikus.hu'),
                                  actions: [
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.sentiment_dissatisfied,
                size: 50,
              ),
              const SizedBox(
                height: 11,
              ),
              const Text('Sajnos jelenleg nem elérhető a napi ige.'),
              const Text('A földet megnyomva kinyílik az oldal az igékkel.'),
              const SizedBox(
                height: 11,
              ),
              TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Technikai infók',
                                  style: GoogleFonts.getFont('Oranienbaum')),
                              content: const Text(
                                  'Sajnos a weboldal igen megváltozott és a napi ige letöltése jelenleg nem lehetséges. Eddig egy elvolt egy kicsit kódban választva, viszont ezen cseréltek egy kicsit és most jobban beolvad az oldallal. Az új módszer keresése folyamatban van.'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK')),
                              ],
                            ));
                  },
                  child: const Text('Technikai infók'))
            ].animate(interval: .10.seconds).fadeIn(),
          ),
        ));
  }
}
