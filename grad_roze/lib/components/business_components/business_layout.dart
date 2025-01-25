import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grad_roze/config.dart';
import 'package:grad_roze/custom/theme.dart';
import 'package:grad_roze/pages/business_pages/myBouquets/my_bouquet_widget.dart';
import 'package:grad_roze/pages/business_pages/myOrders/myOrdersWidget.dart';
import 'package:grad_roze/pages/business_pages/my_profile/myprofile_business_widget.dart';
import 'package:grad_roze/pages/business_pages/special_orders_list/special_orders_list_widget.dart';

import 'package:grad_roze/pages/chat_list/chat_list.dart';

import 'package:grad_roze/pages/notifications/notifications_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './drawer/drawer_widget.dart';
import 'package:http/http.dart' as http;

class BusinessLayout extends StatefulWidget {
  const BusinessLayout({super.key});

  @override
  _BusinessLayoutState createState() => _BusinessLayoutState();
}

class _BusinessLayoutState extends State<BusinessLayout> {
  int _currentIndex = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Define a GlobalKey

  bool isLoading = true; // Track loading state
  String businessUsername = '';
  String businessEmail = '';
  String businessprofilePhotoUrl = '';

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
            businessUsername = data['username']; // Set the fetched username
            businessEmail = data['email'];
            businessprofilePhotoUrl = data['profilePhoto'];
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

  @override
  Widget build(BuildContext context) {
    // Return a loading indicator while fetching data
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
      MyprofileBusinessWidget(
        onRefresh: _fetchUserProfile,
      ),
      MyBouquetWidget(business: businessUsername),
      MyOrdersWidget(business: businessUsername),
      SpecialOrdersListWidget(),
      ChatListPage(userId: businessUsername),
      NotificationsWidget(),
    ];

    return Scaffold(
      key: _scaffoldKey, // Assign the GlobalKey to the Scaffold
      appBar: AppBar(
        title: Text(
          'Business Dashboard',
          style: FlutterFlowTheme.of(context).titleMedium.copyWith(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                fontFamily: 'Funnel Display',
              ),
        ),
        backgroundColor: FlutterFlowTheme.of(context).secondary,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.clear_all_rounded, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: SidedrawerWidget(
          onNavSelect: (index) {
            setState(() {
              _currentIndex = index; // Update the selected page
            });
          },
          business: businessUsername,
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
    );
  }
}
