import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myflutterproject/services/chat_service.dart';
import 'dart:async';

import '../component/BackgroundVideo.dart';
import '../pages/userPage.dart';
class ChatPage extends StatefulWidget {
  final String reciversEmail;
  final String reciverID;
  final String username;

  const ChatPage({
    super.key,
    required this.reciversEmail,
    required this.reciverID,
    required this.username,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _messageContoller = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  // ignore: prefer_typing_uninitialized_variables
  var typing;

  final FocusNode myFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  Timer? _typingTimer;
  bool _isTyping = false;

  String get chatRoomId {
    List<String> ids = [_auth.currentUser!.uid, widget.reciverID];
    ids.sort(); // ensure unique and consistent ID
    return ids.join("_");
  }

  @override
  void initState() {
    super.initState();

    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 400),
              () => scrollDown(),
        );
      }
    });

    _messageContoller.addListener(_handleTypingStatus);

    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
    listenToTypingStatus(chatRoomId);
  }

  void _handleTypingStatus() {
    if (_messageContoller.text.isNotEmpty && !_isTyping) {
      _updateTypingStatus(true);
      _isTyping = true;
    }

    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      _updateTypingStatus(false);
      _isTyping = false;
    });
  }

  void listenToTypingStatus(String chatRoomID) {
    FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("typing_status")
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        var data = doc.data();
        String userId = doc.id;
        bool isTyping = data['isTyping'] ?? false;

        if (isTyping) {
          print("👤 $userId is typing...");
          typing = "typing";
        } else {
          print("✋ $userId stopped typing");
        }
      }
    });
  }

  Future<void> _updateTypingStatus(bool isTyping) async {
    String myUid = _auth.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('typing_status')
        .doc(myUid)
        .set({
      'isTyping': isTyping,
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _updateTypingStatus(false); // Reset on exit
    myFocusNode.dispose();
    _messageContoller.removeListener(_handleTypingStatus);
    _messageContoller.dispose();
    super.dispose();
  }

  void scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  Future<void> sendMessage() async {
    if (_messageContoller.text.isNotEmpty) {
      await _chatServices.sendMessage(widget.reciverID, _messageContoller.text);
      _messageContoller.clear();
      _updateTypingStatus(false);
      _isTyping = false;
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Prevent resizing when keyboard appears
      appBar: AppBar(
        title: InkWell(
          onTap: (){Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserPage(username:
              widget.username, reciverUID:widget.reciverID),
            ),
          );
          },
          child: Row(
            children: [
              const CircleAvatar(
                radius: 20,
                child: Icon(Icons.person),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.username,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          BackgroundVideo(imageAsset: "assets/angryChat.jpg",),
          Column(
            children: [
              Expanded(child: _buildMessageList()),
              _buildUserInput(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = _auth.currentUser!.uid;
    return StreamBuilder(
      stream: _chatServices.getMessages(widget.reciverID, senderId),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text("Error");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs
              .map((doc) => _buildMessageItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderid'] == _auth.currentUser!.uid;

    var alignment =
    isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    var bgColor = isCurrentUser ? Colors.blue[200] : Colors.grey[300];
    var textColor = isCurrentUser ? Colors.white : Colors.black87;

    // For BackdropFilter


    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          // Apply a linear gradient with transparent colors for glassmorphism effect
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isCurrentUser ? const Radius.circular(12) : Radius.zero,
            bottomRight: isCurrentUser ? Radius.zero : const Radius.circular(12),
          ),
        ),
        // Apply the glassmorphism effect using BackdropFilter
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isCurrentUser ? const Radius.circular(12) : Radius.zero,
            bottomRight: isCurrentUser ? Radius.zero : const Radius.circular(12),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Adjust blur
            child: Container(
              color: Colors.black.withOpacity(0),  // Make container transparent but keep blur effect
              child: Text(
                data['message'],
                style: TextStyle(color: textColor, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );

  }

  Widget _buildUserInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageContoller,
              focusNode: myFocusNode,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
              cursorColor: Theme.of(context).colorScheme.primary,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(
                  color: Theme.of(context).hintColor,
                ),
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor ??
                    Theme.of(context).colorScheme.surface,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
