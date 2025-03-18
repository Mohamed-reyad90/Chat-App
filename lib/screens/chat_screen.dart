import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User? signedInUser;
  String messageText = '';
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    updateOldMessages(); // ✅ تحديث جميع الرسائل القديمة عند بدء التطبيق
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          signedInUser = user;
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void updateOldMessages() async {
    final messages = await _firestore.collection('messages').get();
    for (var doc in messages.docs) {
      if (!doc.data().containsKey('isRead')) {
        await doc.reference.update({'isRead': false});
      }
    }
  }

  void markMessageAsRead(DocumentSnapshot message) {
    if (message['isRead'] == false) {
      _firestore.collection('messages').doc(message.id).update({
        'isRead': true,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Row(
          children: [
            Image.asset('images/livechat2.png', height: 30),
            const SizedBox(width: 10),
            const Text('Live Chat', style: TextStyle(color: Colors.white)),
            const Spacer(),
          ],
        ),
        leading: Container(),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    _firestore
                        .collection('messages')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.yellow[900],
                      ),
                    );
                  }
                  final messages = snapshot.data!.docs;
                  List<Widget> messageWidgets = [];
                  for (var message in messages) {
                    final messageText = message.get('text');
                    final messageSender = message.get('sender');
                    final bool isRead = message.get('isRead') ?? false;

                    Timestamp? timestamp = message.get('timestamp');
                    String formattedTime =
                        timestamp != null
                            ? DateFormat('hh:mm a').format(timestamp.toDate())
                            : 'Unknown Time';

                    final bool isMe = signedInUser?.email == messageSender;
                    if (!isMe) {
                      markMessageAsRead(message);
                    }

                    final messageWidget = Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: Column(
                        crossAxisAlignment:
                            isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                        children: [
                          Text(
                            messageSender,
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color.fromARGB(255, 32, 115, 184),
                            ),
                          ),
                          Material(
                            elevation: 3,
                            borderRadius:
                                isMe
                                    ? BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    )
                                    : BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                            color: isMe ? Colors.green[300] : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    messageText,
                                    style: TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontSize: 18,
                                      color: isMe ? Colors.black : Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        formattedTime,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      if (isMe)
                                        Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: Icon(
                                            isRead
                                                ? Icons.done_all
                                                : Icons.done,
                                            size: 16,
                                            color:
                                                isRead
                                                    ? Colors.blue
                                                    : Colors.grey,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                    messageWidgets.add(messageWidget);
                  }
                  return ListView(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    children: messageWidgets,
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.yellow[900]!, width: 2.0),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        hintText: '...اكتب رسالتك هنا',
                        border: InputBorder.none,
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Tajawal',
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.yellow[900]!,
                            width: 2.0,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.yellow[900]),
                    onPressed: () {
                      if (messageText.trim().isNotEmpty &&
                          signedInUser != null) {
                        _firestore.collection('messages').add({
                          'text': messageText,
                          'sender': signedInUser!.email,
                          'timestamp': FieldValue.serverTimestamp(),
                          'isRead': false,
                        });
                        messageController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
