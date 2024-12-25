import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:grad_roze/custom/theme.dart';
import 'package:grad_roze/index.dart';
import 'package:grad_roze/pages/cameraPage/camera_page_widget.dart';
import 'package:grad_roze/pages/offers/offers_widget.dart';
import 'package:hugeicons/hugeicons.dart';

class CustomerLayout extends StatefulWidget {
  const CustomerLayout({super.key});

  @override
  _CustomerLayoutState createState() => _CustomerLayoutState();
}

class _CustomerLayoutState extends State<CustomerLayout> {
  int _currentIndex = 1; // Keeps track of the current tab

  // List of pages displayed for each tab
  final List<Widget> _pages = [
    const CameraPageWidget(),
    const HomePage(),
    const CartWidget(),
    const OffersWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Display the current page
      bottomNavigationBar: CircleNavBar(
        activeIndex: _currentIndex,
        height: 70, // Height of the navigation bar
        circleWidth: 60, // Size of the floating circle
        circleColor:
            FlutterFlowTheme.of(context).primary, // Floating circle color
        activeIcons: const <Widget>[
          Icon(Icons.camera, color: Colors.white),
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.shopping_cart_outlined, color: Colors.white),
          HugeIcon(
            icon: HugeIcons.strokeRoundedFlowerPot,
            color: Colors.white,
            size: 30.0,
          )
        ],
        inactiveIcons: <Widget>[
          Icon(Icons.camera, color: FlutterFlowTheme.of(context).secondaryText),
          Icon(Icons.home, color: FlutterFlowTheme.of(context).secondaryText),
          Icon(Icons.shopping_cart_outlined,
              color: FlutterFlowTheme.of(context).secondaryText),
          HugeIcon(
            icon: HugeIcons.strokeRoundedFlowerPot,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 30.0,
          )
        ],
        color: FlutterFlowTheme.of(context)
            .secondaryBackground, // Nav bar background color
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the active tab
          });
        },
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 5), // Removed the extra comma here
      ),
    );
  }
}
