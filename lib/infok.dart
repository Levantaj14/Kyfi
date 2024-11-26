import 'package:flutter/material.dart';
import 'package:Kyfi/ertesitesek.dart';
import 'package:Kyfi/szoveg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Infok extends StatefulWidget {
  const Infok({super.key});

  @override
  State<Infok> createState() => _InfokState();
}

class _InfokState extends State<Infok> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late TimeOfDay timeOfDay;
  bool bekapcs = false;
  String appVersion = "v0.6.2";

  //bool magyarazat = false;

  Future getTime() async {
    final prefs = await SharedPreferences.getInstance();
    bekapcs = prefs.getBool("NotificationOn") ?? false;
    //magyarazat = prefs.getBool("Explanation") ?? false;
    int aux = prefs.getInt("NotificationTime") ?? 840;
    timeOfDay = TimeOfDay(hour: aux ~/ 60, minute: aux % 60);
    setState(() {});
  }

  Future setTime() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("NotificationTime", timeOfDay.hour * 60 + timeOfDay.minute);
  }

  Future setToggle() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("NotificationOn", bekapcs);
  }

  /*Future setExpl() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("Explanation", magyarazat);
  }*/

  @override
  void initState() {
    getTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(title: const Text('Infók')),
        body: ListView(
            children: (!kIsWeb)
                ? [
                    ListTile(
                      title: const Text('Visszajelzés'),
                      subtitle: const Text(
                          'Van valami gond az alkalmazással? Jelezd itt'),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text('Vigyázat!'),
                                  content: const Text(
                                      'A következőkben át leszel írányítva az email alkalmazásodhoz'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          launchUrlString(
                                              'mailto:tulip.topcoat-0j@icloud.com?subject=Kyfi alkalmazás visszajelzés');
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Hajrá')),
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Inkább ne')),
                                  ],
                                ));
                      },
                    ),
                    ListTile(
                      title: const Text('Napi Ige értesítés'),
                      subtitle: const Text(
                          'Állítsd be, hogy hánykor értesülj az újabb napi igéről'),
                      trailing: IconButton(
                        icon: bekapcs
                            ? const Icon(Icons.notifications_active_outlined)
                            : const Icon(Icons.notifications_off_outlined),
                        onPressed: () {
                          setState(() {
                            bekapcs = !bekapcs;
                            setToggle();
                          });
                          if (bekapcs) {
                            TurnScheduleOn.initialNotification();
                            TurnScheduleOn.scheduleNotification();
                          }
                        },
                      ),
                      onTap: bekapcs
                          ? () async {
                              TimeOfDay? selectedTime = await showTimePicker(
                                context: context,
                                initialTime: timeOfDay,
                                initialEntryMode: TimePickerEntryMode.dialOnly,
                              );
                              if (selectedTime != null) {
                                timeOfDay = selectedTime;
                                setTime();
                                TurnScheduleOn.scheduleNotification();
                              }
                            }
                          : null,
                    ),
                    ListTile(
                      title: const Text('Több infó'),
                      subtitle:
                          const Text('Itt találhatod az összes unalmas infót'),
                      onTap: () {
                        showAboutDialog(
                            context: context,
                            applicationIcon: const FlutterLogo(),
                            applicationName: 'Kyfi',
                            applicationVersion: appVersion);
                      },
                      onLongPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const szoveg(
                                      i: 0,
                                    )));
                      },
                    )
                  ]
                : [
                    ListTile(
                      title: const Text('Visszajelzés'),
                      subtitle: const Text(
                          'Van valami gond az alkalmazással? Jelezd itt'),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text('Vigyázat!'),
                                  content: const Text(
                                      'A következőkben át leszel írányítva az email alkalmazásodhoz'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          launchUrlString(
                                              'mailto:tulip.topcoat-0j@icloud.com?subject=Kyfi alkalmazás visszajelzés');
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Hajrá')),
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Inkább ne')),
                                  ],
                                ));
                      },
                    ),
                    ListTile(
                      title: const Text('Több infó'),
                      subtitle:
                          const Text('Itt találhatod az összes unalmas infót'),
                      onTap: () {
                        showAboutDialog(
                            context: context,
                            applicationIcon: const FlutterLogo(),
                            applicationName: 'Kyfi',
                            applicationVersion: appVersion);
                      },
                      onLongPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const szoveg(
                                      i: 0,
                                    )));
                      },
                    )
                  ]));
  }
}
