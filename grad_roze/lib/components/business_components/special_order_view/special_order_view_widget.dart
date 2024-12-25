import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:grad_roze/config.dart';

import '/custom/animations.dart';
import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' as scheduler;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'special_order_view_model.dart';
export 'special_order_view_model.dart';

class SpecialOrderViewWidget extends StatefulWidget {
  final dynamic order; // Pass the order object
  const SpecialOrderViewWidget({super.key, required this.order});

  @override
  State<SpecialOrderViewWidget> createState() => _SpecialOrderViewWidgetState();
}

class _SpecialOrderViewWidgetState extends State<SpecialOrderViewWidget>
    with TickerProviderStateMixin {
  late SpecialOrderViewModel _model;
  String address = "Loading..."; // Default value for address
  String phoneNumber = "Loading..."; // Default value for phone number

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? deviceToken;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); // Initialize the plugin

  final animationsMap = <String, AnimationInfo>{};
  Future<bool> createOffer() async {
    try {
      // Get username from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? username = prefs.getString('username'); // Replace with your key

      if (username == null || username.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Error: Username is missing in shared preferences.')),
        );
        return false;
      }

      // Get the price from the TextFormField
      String price = _model.priceTextController.text.trim();

      // Validate price
      if (price.isEmpty || double.tryParse(price) == null) {
        Navigator.pop(context); // Close the dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a valid price.')),
        );
        return false;
      }

      // Construct the API URL for creating an offer
      String apiUrl =
          '$url/offers'; // Replace with your offer creation endpoint

      // Build the request body
      final requestBody = {
        'orderId': widget.order['_id'], // Pass the order ID
        'businessUsername':
            username, // Pass the username from shared preferences
        'price': price, // Pass the entered price
      };

      // Make the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        Navigator.pop(context, true); // Close the dialog with success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Offer created and sent to the customer successfully!')),
        );
        return true; // Success
      } else {
        Navigator.pop(context, false); // Close the dialog with failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to create the offer: ${response.statusCode}')),
        );
        return false; // Failure
      }
    } catch (e) {
      Navigator.pop(context, false); // Close the dialog with failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error calling API: $e')),
      );
      return false; // Failure
    }
  }

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  Future<void> sendDeviceTokenToBackend(String token) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? username = prefs.getString('username'); // Replace with your key

      final response = await http.post(
        Uri.parse('$url/save-device-token'),
        headers: {
          'Content-Type':
              'application/json', // Set the content type to application/json
        },
        body: json.encode({
          'deviceToken': token,
          'username':
              username, // Replace with actual username or user identifier
        }),
      );

      if (response.statusCode == 200) {
        print('Device token sent successfully');
      } else {
        print('Failed to send device token ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending device token: $e');
    }
  }

  Future<void> _initializeFirebaseMessaging() async {
    // Get the device token
    deviceToken = await messaging.getToken();
    print("Device Token: $deviceToken");
    sendDeviceTokenToBackend(deviceToken!);
    // Listen to foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground Message: ${message.notification?.title}');
      // Handle the notification
      _showNotification(message);
    });

    // Handle background notifications
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Background Message: ${message.notification?.title}');
      // Navigate to a specific screen if needed
    });
  }

// Function to initialize notification channel
  Future<void> _initializeNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'offer_notifications', // ID must match with AndroidNotificationDetails
      'Offers Notifications', // Channel name
      description: 'Your channel description',
      importance: Importance.high,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _showNotification(RemoteMessage message) async {
    try {
      print("Attempting to show notification...");
      var androidDetails = AndroidNotificationDetails(
        'offer_notifications',
        'Offers Notifications',
        channelDescription: 'Your channel description',
        importance: Importance.high,
        priority: Priority.high,
      );

      var generalNotificationDetails = NotificationDetails(
        android: androidDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title ?? "No Title",
        message.notification?.body ?? "No Body",
        generalNotificationDetails,
      );
      print("Notification displayed successfully.");
    } catch (e) {
      print("Error displaying notification: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserDetails(); // Fetch user details on initialization
    _initializeFirebaseMessaging();
    _initializeNotificationChannel(); // Create the notification channel

    _model = createModel(context, () => SpecialOrderViewModel());

    _model.priceTextController ??= TextEditingController();
    _model.priceFocusNode ??= FocusNode();

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 300.ms),
          MoveEffect(
            curve: Curves.bounceOut,
            delay: 300.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 100.0),
            end: Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<void> fetchUserDetails() async {
    try {
      final response = await http.get(
        Uri.parse('$url/user/${widget.order['customerUsername']}'),
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);

        // Update the state with fetched data
        setState(() {
          address = userData['address'] ?? 'Address not available';
          phoneNumber = userData['phoneNumber'] ?? 'Phone number not available';
        });
      } else {
        setState(() {
          address = 'Error fetching address';
          phoneNumber = 'Error fetching phone number';
        });
      }
    } catch (e) {
      setState(() {
        address = 'Error: ${e.toString()}';
        phoneNumber = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).accent4,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 2, 16, 16),
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxWidth: 670,
                  ),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 12,
                        color: Color(0x1E000000),
                        offset: Offset(
                          0,
                          5,
                        ),
                      )
                    ],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(24, 16, 0, 0),
                            child: Text(
                              'Special Order',
                              style: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .override(
                                    fontFamily: 'Funnel Display',
                                    color: FlutterFlowTheme.of(context).primary,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 16, 16, 0),
                            child: FlutterFlowIconButton(
                              borderRadius: 8,
                              buttonSize: 40,
                              icon: Icon(
                                Icons.close,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 24,
                              ),
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                            child: RichText(
                              textScaler: MediaQuery.of(context).textScaler,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Order Name: \n',
                                    style: TextStyle(),
                                  ),
                                  TextSpan(
                                    text: widget.order['orderName'],
                                    style: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Funnel Display',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                          useGoogleFonts: false,
                                        ),
                                  )
                                ],
                                style: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Funnel Display',
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                            child: RichText(
                              textScaler: MediaQuery.of(context).textScaler,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Customer: \n',
                                    style: TextStyle(),
                                  ),
                                  TextSpan(
                                    text: widget.order['customerUsername'],
                                    style: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Funnel Display',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                          useGoogleFonts: false,
                                        ),
                                  )
                                ],
                                style: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Funnel Display',
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                            child: RichText(
                              textScaler: MediaQuery.of(context).textScaler,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Flower Types: ',
                                    style: TextStyle(),
                                  ),
                                  TextSpan(
                                    text: widget.order['selectedAssets']
                                        .sublist(1) // Exclude the first element
                                        .map((asset) =>
                                            '\n${asset['asset']} # ${asset['flowerCount'] ?? ''}') // Map to formatted string
                                        .join(
                                            ''), // Join them into a single string
                                    style: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Funnel Display',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                          useGoogleFonts: false,
                                        ),
                                  ),
                                ],
                                style: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Funnel Display',
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                            child: RichText(
                              textScaler: MediaQuery.of(context).textScaler,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Vase Style: ',
                                    style: TextStyle(),
                                  ),
                                  TextSpan(
                                    text:
                                        '\n${widget.order['selectedAssets'][0]['asset']}',
                                    style: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Funnel Display',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                          useGoogleFonts: false,
                                        ),
                                  )
                                ],
                                style: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Funnel Display',
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                            child: RichText(
                              textScaler: MediaQuery.of(context).textScaler,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Total Flowers: \n',
                                    style: TextStyle(),
                                  ),
                                  TextSpan(
                                    text: ' ${widget.order['flowerCount']}',
                                    style: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Funnel Display',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                          useGoogleFonts: false,
                                        ),
                                  )
                                ],
                                style: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Funnel Display',
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                            child: RichText(
                              textScaler: MediaQuery.of(context).textScaler,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Address: \n',
                                    style: TextStyle(),
                                  ),
                                  TextSpan(
                                    text: address,
                                    style: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Funnel Display',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                          useGoogleFonts: false,
                                        ),
                                  )
                                ],
                                style: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Funnel Display',
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                            child: RichText(
                              textScaler: MediaQuery.of(context).textScaler,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Phone Number: \n',
                                    style: TextStyle(),
                                  ),
                                  TextSpan(
                                    text: phoneNumber,
                                    style: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Funnel Display',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                          useGoogleFonts: false,
                                        ),
                                  )
                                ],
                                style: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Funnel Display',
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 16, 0, 0),
                                child: FaIcon(
                                  FontAwesomeIcons.dollarSign,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 20,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    7, 16, 16, 0),
                                child: Container(
                                  width: 80,
                                  child: TextFormField(
                                    controller: _model.priceTextController,
                                    focusNode: _model.priceFocusNode,
                                    autofocus: false,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'Price',
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Funnel Display',
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: false,
                                          ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Funnel Display',
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: false,
                                        ),
                                    textAlign: TextAlign.center,
                                    minLines: 1,
                                    keyboardType: TextInputType.number,
                                    cursorColor: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    validator: _model
                                        .priceTextControllerValidator
                                        .asValidator(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 12, 24, 24),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0, 0.05),
                              child: FFButtonWidget(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                text: 'Dismiss Order',
                                options: FFButtonOptions(
                                  height: 44,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24, 0, 24, 0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Funnel Display',
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: false,
                                      ),
                                  elevation: 0,
                                  borderSide: BorderSide(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0, 0.05),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  // Await the result from the function
                                  final result = await createOffer();

                                  // If the result is true (successful update), refresh the parent widget
                                  if (result == true) {
                                    setState(() {
                                      // Trigger a refresh of the parent widget's data
                                    });
                                  }
                                },
                                text: 'Make Offer',
                                options: FFButtonOptions(
                                  height: 44,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24, 0, 24, 0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  color: FlutterFlowTheme.of(context).secondary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Funnel Display',
                                        letterSpacing: 0.0,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        useGoogleFonts: false,
                                      ),
                                  elevation: 3,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animateOnPageLoad(
                    animationsMap['containerOnPageLoadAnimation']!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
