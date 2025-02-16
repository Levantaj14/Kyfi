import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
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
  String appVersion = "v0.7.0";

  Future getTime() async {
    final prefs = await SharedPreferences.getInstance();
    bekapcs = prefs.getBool("NotificationOn") ?? false;
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

  ListTile feedback() {
    return ListTile(
      title: Text(
        'Visszajelzés',
        style: GoogleFonts.getFont('Oranienbaum'),
      ),
      subtitle: const Text('Van valami gond az alkalmazással? Jelezd itt'),
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Vigyázat!',
                      style: GoogleFonts.getFont('Oranienbaum')),
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
    );
  }

  ListTile notifications() {
    return ListTile(
      title:
          Text('Napi Ige értesítés', style: GoogleFonts.getFont('Oranienbaum')),
      subtitle:
          const Text('Állítsd be, hogy hánykor értesülj az újabb napi igéről'),
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
    );
  }

  ListTile more() {
    return ListTile(
      title: Text('Több infó', style: GoogleFonts.getFont('Oranienbaum')),
      subtitle: const Text('Itt találhatod az összes unalmas infót'),
      onTap: () {
        showAboutDialog(
          context: context,
          applicationIcon: const FlutterLogo(),
          applicationName: 'Kyfi',
          applicationVersion: appVersion,
        );
      },
      onLongPress: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const Szoveg(
                      i: 0
                    )));
      },
    );
  }

  @override
  void initState() {
    getTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
            title: Text(
          'Infók',
          style: GoogleFonts.getFont('Oranienbaum'),
        )),
        body: ListView(
            children: (!kIsWeb)
                ? [feedback(), notifications(), more()].animate().fadeIn()
                : [feedback(), more()]));
  }
}
