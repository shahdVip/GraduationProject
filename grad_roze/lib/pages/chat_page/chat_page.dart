import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:grad_roze/config.dart';
import 'package:grad_roze/custom/theme.dart';
import 'package:grad_roze/custom/util.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  final String chatId; // e.g., customerId_businessId
  final String userId; // Logged-in user ID (customer or business)
  final String receiver; // Receiver's ID

  const ChatPage(
      {required this.chatId,
      required this.userId,
      required this.receiver,
      Key? key})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? receiverId; // To store the receiver's ID
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? deviceToken;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); // Initialize the plugin

  @override
  void initState() {
    super.initState();
    _initializeFirebaseMessaging();
    _initializeNotificationChannel();
    _fetchReceiverDetails();
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
      'message_notifications', // ID must match with AndroidNotificationDetails
      'Message Notifications', // Channel name
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
        'message_notifications',
        'Message Notifications',
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

  // Function to fetch the receiver's details
  void _fetchReceiverDetails() async {
    try {
      var chatRef =
          FirebaseFirestore.instance.collection('chats').doc(widget.chatId);
      var chatSnapshot = await chatRef.get();

      if (chatSnapshot.exists) {
        // Get the list of participants
        List<String> participants =
            List<String>.from(chatSnapshot['participants']);

        // Find the receiver ID (not the current user's ID)
        receiverId = participants.firstWhere((id) => id != widget.userId);
      }
    } catch (e) {
      print("Error fetching receiver details: $e");
    }
  }

  Future<void> sendMessage() async {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      // Check if the chat already exists, if not create a new chat
      var chatRef =
          FirebaseFirestore.instance.collection('chats').doc(widget.chatId);
      var chatSnapshot = await chatRef.get();

      if (!chatSnapshot.exists) {
        // Create a new chat document with participants (customer and business)
        await chatRef.set({
          'participants': [
            widget.userId,
            'businessId'
          ], // Replace with the actual business ID
          'lastMessage': message,
          'lastTimestamp': FieldValue.serverTimestamp(),
        });
      }

      // Add the new message to the chat's messages collection
      await chatRef.collection('messages').add({
        'senderId': widget.userId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Update the chat metadata (last message)
      await chatRef.set({
        'lastMessage': message,
        'lastTimestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      _messageController.clear();

      // Scroll to the bottom of the chat
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );

      // Fetch the receiver's FCM token
      try {
        String? receiverToken =
            "c00yJFUcQACgGMkE-vMtYc:APA91bFW2I4qaoz68VsdzbPPyu7t-SKqMEbK3zXrirI-JyZl7ZZ2B9uox4NqaHndIjfjopvFIdbzZ7g_Fqu9v9_3ogzEYH-qVB2HBMwITPLE8_pEFxTxhj0"; // Assuming you store the FCM token in 'fcmToken'
        // Send a push notification to the receiver via your backend
        await sendPushNotificationToBackend(
            receiverToken, 'New Message from ${widget.userId}', message);
      } catch (e) {
        print("Error fetching receiver's FCM token: $e");
      }
    }
  }

// Function to send push notification to backend
  Future<void> sendPushNotificationToBackend(
      String deviceToken, String title, String message) async {
    try {
      final response = await http.post(
        Uri.parse('$url/notification/send-message'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'deviceToken': deviceToken,
          'title': title,
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        print('Push notification sent successfully');
      } else {
        print('Failed to send push notification: ${response.body}');
      }
    } catch (e) {
      print('Error sending push notification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ignore: unnecessary_null_comparison
        title: Text(widget.receiver),
        backgroundColor: FlutterFlowTheme.of(context).secondary,
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No messages yet."),
                  );
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message =
                        messages[index].data() as Map<String, dynamic>;

                    bool isMe = message['senderId'] == widget.userId;

                    // Parse the Firestore timestamp to a readable format
                    Timestamp? timestamp = message['timestamp'];
                    String formattedTime = timestamp != null
                        ? DateFormat('yyyy-MM-dd hh:mm a').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                timestamp.millisecondsSinceEpoch))
                        : "Delivering";

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? FlutterFlowTheme.of(context).secondary
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                message['message'],
                                style: TextStyle(
                                  color: isMe
                                      ? Colors.white
                                      : FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                            ),

                            // Add timestamp below the message
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                formattedTime,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                // Text Field
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                            color: Colors.grey), // Default border color
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context)
                                .secondary), // Border color when focused
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Send Button
                IconButton(
                  icon: Icon(Icons.send,
                      color: FlutterFlowTheme.of(context).secondary),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
