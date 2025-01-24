import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_roze/config.dart';
import 'package:grad_roze/custom/theme.dart';
import 'package:grad_roze/pages/chat_list/dialog_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:grad_roze/pages/chat_page/chat_page.dart';
import 'package:hugeicons/hugeicons.dart';

class CustomerChatListPage extends StatefulWidget {
  final String userId; // Logged-in user ID (customer or business)

  const CustomerChatListPage({required this.userId, super.key});

  @override
  _CustomerChatListPageState createState() => _CustomerChatListPageState();
}

class _CustomerChatListPageState extends State<CustomerChatListPage> {
  Future<List<String>> fetchBusinessUsers() async {
    final response = await http.get(Uri.parse('$url/allUsers'));

    if (response.statusCode == 200) {
      // Parse the response to get the users
      List<dynamic> allUsers = json.decode(response.body);

      // Filter the users based on their role and collect their usernames
      List<String> businessUsernames = [];
      for (var user in allUsers) {
        if (user['role'] == 'Business') {
          businessUsernames.add(user['username']);
        }
      }

      return businessUsernames;
    } else {
      // Handle error if the request fails
      throw Exception('Failed to load users');
    }
  }

  // Function to create a new chat or open existing chat
  void createNewChat() async {
    List<String> businessUsernames = await fetchBusinessUsers();

    // Show a dialog to enter the username
    String? enteredUsername =
        await showUsernameDialog(context, businessUsernames);

    if (enteredUsername != null && enteredUsername.isNotEmpty) {
      try {
        // Make a request to fetch all users from the backend
        final response = await http.get(Uri.parse('$url/allUsers'));

        if (response.statusCode == 200) {
          // Parse the response to get the users
          List<dynamic> allUsers = json.decode(response.body);

          // Find the user with the entered username and check if the role is 'Customer'
          var selectedUser = allUsers.firstWhere(
              (user) =>
                  user['username'] == enteredUsername &&
                  user['role'] == 'Business',
              orElse: () => null);

          if (selectedUser != null) {
            // Get the customer ID from the selected user
            String selectedCustomerId = selectedUser['username'];

            // Fetch existing chats where the logged-in user and the selected customer are participants
            var chatQuery = await FirebaseFirestore.instance
                .collection('chats')
                .where('participants', arrayContainsAny: [
              widget.userId,
              selectedCustomerId
            ]).get();

            // Check if a chat already exists between the logged-in user and the selected customer
            QueryDocumentSnapshot<Map<String, dynamic>>? existingChat;

            try {
              existingChat = chatQuery.docs.firstWhere(
                (doc) =>
                    (doc['participants'] as List)
                        .contains(selectedCustomerId) &&
                    (doc['participants'] as List).contains(widget.userId),
              );
            } catch (e) {
              // If no chat is found, we simply handle it and leave existingChat as null
              existingChat = null;
            }

            String chatId;

            if (existingChat != null) {
              // If chat already exists, use the existing chatId
              chatId = existingChat.id;
            } else {
              // If no existing chat, generate a new chatId and create a new chat document
              chatId = '${widget.userId}_$selectedCustomerId';
              await FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatId)
                  .set({
                'participants': [widget.userId, selectedCustomerId],
                'lastMessage': "",
                'lastTimestamp': FieldValue.serverTimestamp(),
              });
            }

            // Navigate to the new or existing chat page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                    chatId: chatId,
                    userId: widget.userId,
                    receiver: selectedCustomerId),
              ),
            );
          } else {
            // Show an error message if the username doesn't belong to a valid customer
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Invalid username or not a business."),
            ));
          }
        } else {
          // If the request fails, show an error message
          throw Exception('Failed to load users');
        }
      } catch (error) {
        // Handle errors, such as network issues
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error: $error"),
        ));
      }
    }
  }

  // Function to show the dialog for entering the username
  Future<String?> showUsernameDialog(
      BuildContext context, List<String> users) async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return DialogWidget(
          users: users,
          onUserSelected: (selectedUser) {
            Navigator.of(context).pop(selectedUser);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: FlutterFlowTheme.of(context).primary),
          onPressed: () {
            Navigator.pop(context); // Navigates back to the previous screen
          },
        ),
        title: Text(
          'Chats',
          style: FlutterFlowTheme.of(context).titleLarge.override(
                fontFamily: 'Funnel Display',
                letterSpacing: 0.0,
                useGoogleFonts: false,
              ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants',
                arrayContains:
                    widget.userId) // Filter by user ID (customer or business)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No chats available."));
          }

          var chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              var chatData = chats[index].data() as Map<String, dynamic>;
              var chatId = chats[index].id;
              var receiverId = chatData['participants'].firstWhere(
                  (id) => id != widget.userId); // Find the other participant

              return ListTile(
                title: Text(
                  "$receiverId",
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Funnel Display',
                        color: FlutterFlowTheme.of(context).primary,
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                ),
                subtitle: Text(
                  chatData['lastMessage'] ?? "No messages yet",
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Funnel Display',
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        chatId: chatId,
                        userId: widget.userId,
                        receiver: receiverId,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(

        onPressed: () => createNewChat(),
        backgroundColor: FlutterFlowTheme.of(context)
            .secondary, // Set the button's background color


        child: HugeIcon(
          icon: HugeIcons.strokeRoundedBubbleChatAdd,
          color: Colors.white,
          size: 24.0,
        ),
      ),
    );
  }
}
