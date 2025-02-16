import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:Kyfi/infok.dart';
import 'package:Kyfi/dalok.dart';
import 'package:Kyfi/no_napi_ige.dart';
import 'package:Kyfi/kedvenc.dart';
import 'package:Kyfi/ertesitesek.dart';

extension DarkMode on BuildContext {
  /// is dark mode currently enabled?
  bool get isDarkMode {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }
}

class MainNavbar extends StatefulWidget {
  const MainNavbar({super.key});

  @override
  State<MainNavbar> createState() => _MainNavbarState();
}

class _MainNavbarState extends State<MainNavbar> {
  int currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    Notifications.init(initSchedule: true);
    TurnScheduleOn.scheduleNotification();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(currentIndex);
      }
    });
    super.didChangeDependencies();
  }

  bool ext = false;

  Widget buildPageView(bool horizont) {
    return PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: (!kIsWeb)
            ? const [
          Dalok(),
          Kedvenc(),
          NapiIge(),
          //*Bip(),*//
          Infok()
        ]
            : const [Dalok(), Kedvenc(), Infok()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (MediaQuery.of(context).size.width <
          MediaQuery.of(context).size.height)
          ? buildPageView(false)
          : Row(
        children: [
          NavigationRail(
            leading: Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        ext = !ext;
                      });
                    },
                    icon: (ext)
                        ? const Icon(Icons.arrow_back)
                        : const Icon(Icons.menu_rounded)),
                const SizedBox(
                  height: 8,
                )
              ],
            ),
            extended: ext,
            destinations: (!kIsWeb)
                ? const [
              NavigationRailDestination(
                  icon: Icon(Icons.music_note_outlined),
                  label: Text('Dalok')),
              NavigationRailDestination(
                icon: Icon(Icons.favorite_outline),
                label: Text('Kedvenc'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.book_outlined),
                label: Text('Napi ige'),
              ),
              /*NavigationRailDestination(
                        icon: Icon(Icons.phone_outlined),
                        label: Text('Bip')
                    ),*/
              NavigationRailDestination(
                  icon: Icon(Icons.info_outline),
                  label: Text('Infók')),
            ]
                : const [
              NavigationRailDestination(
                  icon: Icon(Icons.music_note_outlined),
                  label: Text('Dalok')),
              NavigationRailDestination(
                icon: Icon(Icons.favorite_outline),
                label: Text('Kedvenc'),
              ),
              NavigationRailDestination(
                  icon: Icon(Icons.info_outline),
                  label: Text('Infók')),
            ],
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              ext = false;
              _pageController.jumpToPage(index);
            },
          ),
          Expanded(child: buildPageView(true))
        ],
      ),
      bottomNavigationBar: (MediaQuery.of(context).size.width <
          MediaQuery.of(context).size.height)
          ? Padding(
          padding: const EdgeInsets.all(10.0),
          child: (context.isDarkMode)
              ? SafeArea(
            child: GNav(
              gap: 10,
              //tabBackgroundColor: Colors.teal[900]!,
              tabBackgroundColor: Colors.teal,
              activeColor: Colors.white,
              color: Colors.grey[600]!,
              duration: const Duration(milliseconds: 400),
              padding: const EdgeInsets.all(10),
              selectedIndex: currentIndex,
              tabs: (!kIsWeb)
                  ? const [
                GButton(
                    icon: Icons.music_note_outlined,
                    text: 'Dalok'),
                GButton(
                  icon: Icons.favorite_outline,
                  text: 'Kedvencek',
                ),
                GButton(
                  icon: Icons.book_outlined,
                  text: 'Napi ige',
                ),
                /*GButton(
                            icon: Icons.phone_outlined,
                            text: 'Bip',
                          ),*/
                GButton(
                  icon: Icons.info_outline,
                  text: 'Infók',
                )
              ]
                  : const [
                GButton(
                    icon: Icons.music_note_outlined,
                    text: 'Dalok'),
                GButton(
                  icon: Icons.favorite_outline,
                  text: 'Kedvencek',
                ),
                GButton(
                  icon: Icons.info_outline,
                  text: 'Infók',
                )
              ],
              onTabChange: (index) {
                _pageController.jumpToPage(index);
              },
            ),
          )
              : SafeArea(
            child: GNav(
              gap: 10,
              color: Colors.grey[700],
              /*activeColor: Colors.teal[800],
                        tabActiveBorder: Border.all(color: Colors.teal.shade500),*/
              activeColor: Colors.teal[800],
              tabActiveBorder:
              Border.all(color: Colors.teal.shade500),
              duration: const Duration(milliseconds: 400),
              padding: const EdgeInsets.all(10),
              selectedIndex: currentIndex,
              tabs: (!kIsWeb)
                  ? const [
                GButton(
                  icon: Icons.music_note_outlined,
                  text: 'Dalok',
                ),
                GButton(
                  icon: Icons.favorite_outline,
                  text: 'Kedvencek',
                ),
                GButton(
                  icon: Icons.book_outlined,
                  text: 'Napi ige',
                ),
                /*GButton(
                            icon: Icons.phone_outlined,
                            text: 'Bip',
                          ),*/
                GButton(
                  icon: Icons.info_outline,
                  text: 'Infók',
                )
              ]
                  : const [
                GButton(
                  icon: Icons.music_note_outlined,
                  text: 'Dalok',
                ),
                GButton(
                  icon: Icons.favorite_outline,
                  text: 'Kedvencek',
                ),
                GButton(
                  icon: Icons.info_outline,
                  text: 'Infók',
                )
              ],
              onTabChange: (index) {
                _pageController.jumpToPage(index);
              },
            ),
          ))
          : null,
    );
  }
}
