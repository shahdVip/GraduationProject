import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_roze/custom/theme.dart';
import 'package:grad_roze/custom/util.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchReceiverDetails();
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

  // Function to send a message
  void sendMessage() async {
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
