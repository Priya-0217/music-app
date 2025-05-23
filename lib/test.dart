// import 'package:flutter/material.dart';
// import 'package:myflutterproject/services/socket.dart';
// import 'package:provider/provider.dart';
//
// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   late SocketService socketService;
//   TextEditingController messageController = TextEditingController();
//   List<Map<String, dynamic>> messages = [];
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     socketService = Provider.of<SocketService>(context, listen: false);  // Initialize in didChangeDependencies
//     socketService.socket.on('receive_message', (data) {
//       setState(() {
//         messages.add({
//           'user': data['user'],
//           'message': data['message'],
//         });
//       });
//     });
//   }
//
//   void sendMessage() {
//
//     if (messageController.text.isNotEmpty) {
//       final message = messageController.text.trim();
//       socketService.sendVibrate();
//
//       // 🔼 Add your own message immediately
//       setState(() {
//         messages.add({
//           'user': 'FlutterUser',
//           'message': message,
//         });
//       });
//
//       socketService.sendMessage('FlutterUser', message);
//       messageController.clear();
//     }
//   }
//
//   Widget buildMessageBubble(String user, String message, bool isMe) {
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isMe ? Colors.blueAccent : Colors.grey.shade300,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           crossAxisAlignment:
//           isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             if (!isMe)
//               Text(
//                 user,
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold, color: Colors.black54),
//               ),
//             Text(
//               message,
//               style: TextStyle(
//                 color: isMe ? Colors.white : Colors.black87,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Socket.IO Chat'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               reverse: false,
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final msg = messages[index];
//                 final isMe = msg['user'] == 'FlutterUser';
//                 return buildMessageBubble(msg['user'], msg['message'], isMe);
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Enter your message...',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     // 🧹 Clean up the listener when screen is disposed
//     final socketService = Provider.of<SocketService>(context, listen: false);
//     socketService.socket.off('receive_message');
//     messageController.dispose();
//     super.dispose();
//   }
// }
