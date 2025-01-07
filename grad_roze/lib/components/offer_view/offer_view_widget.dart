import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:grad_roze/config.dart';
import 'package:grad_roze/pages/offers/offers_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/custom/animations.dart';
import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' as scheduler;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'offer_view_model.dart';
export 'offer_view_model.dart';

class OfferViewWidget extends StatefulWidget {
  final dynamic offer; // Pass the order object
  final Function onDelete; // Callback function to refresh the parent

  const OfferViewWidget(
      {super.key, required this.offer, required this.onDelete});

  @override
  State<OfferViewWidget> createState() => _OfferViewWidgetState();
}

class _OfferViewWidgetState extends State<OfferViewWidget>
    with TickerProviderStateMixin {
  late OfferViewModel _model;

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? deviceToken;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); // Initialize the plugin

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  Future<void> deleteOffer(String offerId) async {
    // Replace with your API endpoint URL
    final String apiUrl = '$url/offers/deny/$offerId';

    try {
      final response = await http.delete(
        Uri.parse('$apiUrl'), // Send the offerId in the URL
      );

      if (response.statusCode == 200) {
        // If the server responds with a success status
        print("Offer deleted successfully");
        widget.onDelete();

        // Schedule navigation after the current frame is rendered

        Navigator.pop(context);
      } else {
        // If the server responds with an error status
        print("Failed to delete offer: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> updateOrderAndDeleteOffers(
      String orderId, String businessUsername, String price) async {
    final apiurl =
        '$url/offers/order/update'; // Replace with your actual API URL

    try {
      final response = await http.put(
        Uri.parse(apiurl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'orderId': orderId,
          'businessUsername': businessUsername,
          'price': price,
        }),
      );

      if (response.statusCode == 200) {
        // Successfully updated the order and deleted the offers
        print('Order updated and offers deleted successfully');
        widget.onDelete();

        // Schedule navigation after the current frame is rendered

        Navigator.pop(context);
        //Navigator.pop(context);
      } else {
        // Handle failure
        print('Failed to update order: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
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
      'accept_notifications', // ID must match with AndroidNotificationDetails
      'accept Notifications', // Channel name
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
        'accept_notifications',
        'accept Notifications',
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
  // Future<void> acceptOrderByCustomer(String? orderId) async {
  //   final apiUrl =
  //       '$url/specialOrder/$orderId/accept'; // Replace with your API endpoint

  //   try {
  //     final response = await http.patch(
  //       Uri.parse(apiUrl),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final responseData = jsonDecode(response.body);
  //       print('Order accepted successfully: ${responseData['message']}');
  //       Navigator.pop(context);
  //     } else {
  //       print('Failed to accept order: ${response.body}');
  //     }
  //   } catch (error) {
  //     print('Error occurred: $error');
  //   }
  // }

  // Future<void> resetOrder() async {
  //   try {
  //     final response = await http.put(
  //       Uri.parse('$url/specialOrder/reset-order/${widget.order['_id']}'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       print('Order reset successfully');
  //       Navigator.pop(context);
  //     } else {
  //       print('Failed to reset order: ${response.body}');
  //     }
  //   } catch (error) {
  //     print('Error resetting order: $error');
  //   }
  //}

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OfferViewModel());
    _initializeFirebaseMessaging();
    _initializeNotificationChannel(); // Create the notification channel

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
                        padding: EdgeInsetsDirectional.fromSTEB(24, 16, 0, 0),
                        child: Text(
                          'Special Order Offer',
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
                        padding: EdgeInsetsDirectional.fromSTEB(0, 16, 16, 0),
                        child: FlutterFlowIconButton(
                          borderRadius: 8,
                          buttonSize: 40,
                          icon: Icon(
                            Icons.close,
                            color: FlutterFlowTheme.of(context).secondaryText,
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
                        padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed('AdminDashboard');
                          },
                          child: RichText(
                            textScaler: MediaQuery.of(context).textScaler,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Order: ',
                                  style: TextStyle(),
                                ),
                                TextSpan(
                                  text:
                                      '\n${widget.offer['orderDetails']['orderName']}',
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
                                    color: FlutterFlowTheme.of(context).primary,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed('AdminDashboard');
                          },
                          child: RichText(
                            textScaler: MediaQuery.of(context).textScaler,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Business: ',
                                  style: TextStyle(),
                                ),
                                TextSpan(
                                  text: '\n${widget.offer['businessUsername']}',
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
                                    color: FlutterFlowTheme.of(context).primary,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                        child: RichText(
                          textScaler: MediaQuery.of(context).textScaler,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Flower Types: ',
                                style: TextStyle(),
                              ),
                              TextSpan(
                                text: widget.offer['orderDetails']
                                        ['selectedAssets']
                                    .sublist(1) // Exclude the first element
                                    .map((asset) =>
                                        '\n${asset['asset']} # ${asset['flowerCount'] ?? ''}') // Map to formatted string
                                    .join(''),
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
                                  color: FlutterFlowTheme.of(context).primary,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
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
                                    '\n${widget.offer['orderDetails']['selectedAssets'][0]['asset']}',
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
                                  color: FlutterFlowTheme.of(context).primary,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                        child: RichText(
                          textScaler: MediaQuery.of(context).textScaler,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Price: ',
                                style: TextStyle(),
                              ),
                              TextSpan(
                                text: '\n\$${widget.offer['price']}',
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
                                  color: FlutterFlowTheme.of(context).primary,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
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
                          child: FlutterFlowIconButton(
                            borderColor: FlutterFlowTheme.of(context).alternate,
                            borderRadius: 8,
                            borderWidth: 2,
                            buttonSize: 40,
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            icon: Icon(
                              Icons.block,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24,
                            ),
                            onPressed: () {
                              deleteOffer(widget.offer[
                                  '_id']); // Call delete offer API when button is pressed
                            },
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0, 0.05),
                          child: FlutterFlowIconButton(
                            borderColor: Colors.transparent,
                            borderRadius: 8,
                            borderWidth: 1,
                            buttonSize: 40,
                            fillColor: FlutterFlowTheme.of(context).success,
                            icon: Icon(
                              Icons.check,
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              size: 24,
                            ),
                            onPressed: () async {
                              // Call the API when the button is pressed
                              await updateOrderAndDeleteOffers(
                                  widget.offer['orderDetails']['_id'],
                                  widget.offer['businessUsername'],
                                  widget.offer['price']);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
          ),
        ],
      ),
    );
  }
}
