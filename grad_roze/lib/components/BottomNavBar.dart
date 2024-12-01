import 'package:flutter/material.dart';
import 'package:grad_roze/pages/homePage/home.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // Define pages for navigation
  final List<Widget> _pages = [
    const HomePage(),
    const PlaceholderWidget('Page 2'),
    const PlaceholderWidget('Page 3'),
    const PlaceholderWidget('Page 4'),
    const PlaceholderWidget('Page 5'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.search, size: 30),
          Icon(Icons.favorite, size: 30),
          Icon(Icons.notifications, size: 30),
          Icon(Icons.settings, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: _pages[_page], // Display the current page based on the index
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String text;

  const PlaceholderWidget(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
