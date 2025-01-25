import 'package:grad_roze/config.dart';

import '/custom/theme.dart';
import '/custom/util.dart';
import '/components/notification_card/notification_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'notifications_model.dart';
export 'notifications_model.dart';

class NotificationsWidget extends StatefulWidget {
  const NotificationsWidget({super.key});

  @override
  State<NotificationsWidget> createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  late NotificationsModel _model;
  String? username;
  List<dynamic> notifications = [];
  bool isLoading = true;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  Future<String?> getUsernameFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs
        .getString('username'); // Make sure 'username' key is set during login
  }

  Future<List<dynamic>> fetchNotifications(String username) async {
    final apiurl = Uri.parse('$url/notification/$username');

    try {
      final response = await http.get(apiurl);

      if (response.statusCode == 200) {
        return json.decode(response.body); // Return the notifications list
      } else {
        throw Exception('Failed to fetch notifications');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  Future<void> loadNotifications() async {
    // Fetch username from SharedPreferences
    username = await getUsernameFromSharedPreferences();

    if (username != null) {
      // Fetch notifications for the username
      notifications = await fetchNotifications(username!);
    }

    setState(() {
      isLoading = false; // Stop loading after data fetch
    });
  }

  @override
  void initState() {
    super.initState();
    loadNotifications();

    _model = createModel(context, () => NotificationsModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          title: Text(
            'Notifications',
            style: FlutterFlowTheme.of(context).headlineLarge.override(
                  fontFamily: 'Funnel Display',
                  letterSpacing: 0.0,
                  useGoogleFonts: false,
                  color: FlutterFlowTheme.of(context).primary,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : notifications.isEmpty
                  ? Center(child: Text("No notifications found"))
                  : ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return NotificationCardWidget(
                            notification: notification);
                      },
                    ),
        ),
      ),
    );
  }
}
