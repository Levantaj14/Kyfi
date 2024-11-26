import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Bip extends StatefulWidget {
  const Bip({super.key});

  @override
  State<Bip> createState() => _BipState();
}

class _BipState extends State<Bip> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bip'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                  onPressed: () {
                    const snackBar = SnackBar(
                        content: Text(
                            'Sajnos per pillanat nem tudsz hozzáadni felhasználókat'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  icon: const Icon(Icons.add_outlined)),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text('Hogyan működik?'),
                              content: const Text(
                                  'Nyomd meg a plusz jelet a sarokban, majd válaszd ki azokat a személyeket akiket bipelni szeretnél. Egy lista fog megjelenni ezekkel a személyekkel.'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'))
                              ],
                            ));
                  },
                  icon: const Icon(Icons.info_outline)),
            )
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                      child: ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text('Juj'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    launchUrlString('tel:1234');
                                  },
                                  icon: const Icon(Icons.phone_outlined)),
                              const SizedBox(width: 11,),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.message_outlined))
                            ],
                          )),
                    ),
                  );
                })));
  }
}
