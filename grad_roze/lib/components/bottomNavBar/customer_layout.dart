import 'dart:convert';

import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:grad_roze/config.dart';
import 'package:grad_roze/custom/theme.dart';
import 'package:grad_roze/index.dart';
import 'package:grad_roze/pages/cameraPage/camera_page_widget.dart';
import 'package:grad_roze/pages/giftCardPage/giftCardPageWidget.dart';
import 'package:grad_roze/pages/offers/offers_widget.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CustomerLayout extends StatefulWidget {
  const CustomerLayout({super.key});

  @override
  _CustomerLayoutState createState() => _CustomerLayoutState();
}

class _CustomerLayoutState extends State<CustomerLayout> {
  int _currentIndex = 2; // Keeps track of the current tab
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Define a GlobalKey

  bool isLoading = true; // Track loading state
  String username = '';
  String userEmail = '';
  String userprofilePhotoUrl = '';

  Future<void> _fetchUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token'); // Retrieve the token
    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse(loggedInInfo),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            username = data['username']; // Set the fetched username
            userEmail = data['email'];
            userprofilePhotoUrl = data['profilePhoto'];
            isLoading = false; // Stop loading
          });
        } else {
          setState(() {
            isLoading = false; // Stop loading even if error occurs
          });
          print('Failed to load profile');
        }
      } catch (e) {
        setState(() {
          isLoading = false; // Stop loading in case of error
        });
        print('Error: $e');
      }
    } else {
      setState(() {
        isLoading = false; // Stop loading when no token is found
      });
      print('No token found');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserProfile(); // Fetch user profile during initialization
  }

  // List of pages displayed for each tab

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: FlutterFlowTheme.of(context).primary,
          ),
        ),
      );
    }

    // Return main layout once business name is fetched
    final List<Widget> pages = [
      GiftCardPageWidget(username: username),
      CameraPageWidget(username: username),
      HomePage(username: username),
      OffersWidget(),
      MyCartWidget(username: username),
    ];

    return Scaffold(
      body: pages[_currentIndex], // Display the current page
      bottomNavigationBar: CircleNavBar(
        activeIndex: _currentIndex,
        height: 70, // Height of the navigation bar
        circleWidth: 60, // Size of the floating circle
        circleColor:
            FlutterFlowTheme.of(context).primary, // Floating circle color

        activeIcons: const <Widget>[
          Icon(Icons.edit_note, color: Colors.white),
          Icon(Icons.camera, color: Colors.white),
          Icon(Icons.home, color: Colors.white),
          HugeIcon(
            icon: HugeIcons.strokeRoundedFlowerPot,
            color: Colors.white,
            size: 30.0,
          ),
          Icon(Icons.shopping_cart_outlined, color: Colors.white),
        ],
        inactiveIcons: <Widget>[
          Icon(Icons.edit_note,
              color: FlutterFlowTheme.of(context).secondaryText),
          Icon(Icons.camera, color: FlutterFlowTheme.of(context).secondaryText),
          Icon(Icons.home, color: FlutterFlowTheme.of(context).secondaryText),
          HugeIcon(
            icon: HugeIcons.strokeRoundedFlowerPot,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 30.0,
          ),
          Icon(Icons.shopping_cart_outlined,
              color: FlutterFlowTheme.of(context).secondaryText),
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
