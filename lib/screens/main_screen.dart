import 'package:edencrew_assignment_starter/screens/search_screen.dart';
import 'package:edencrew_assignment_starter/screens/watchlist_screen.dart';
import 'package:edencrew_assignment_starter/widgets/common/bottom_nav.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final screens = const [WatchlistScreen(), SearchScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: BottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
