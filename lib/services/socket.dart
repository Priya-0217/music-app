import 'package:firebase_auth/firebase_auth.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketManager {
  static final SocketManager _instance = SocketManager._internal();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  IO.Socket? _socket;

  // Private constructor
  SocketManager._internal();

  factory SocketManager() {
    return _instance;
  }

  // Initialize socket connection (only once)
  Future<void> initSocket() async {
    // Ensure the user is logged in
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      print('User not authenticated');
      return;
    }

    String currentUserId = currentUser.uid;

    if (_socket == null || !_socket!.connected) {
      _socket = IO.io('https://myserver-1-lq6r.onrender.com', IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build());

      // Connect to the socket server
      _socket!.connect();

      // Emit 'register_user' event once connected
      _socket!.onConnect((_) {
        print('Connected to server');
        _socket!.emit('register_user', currentUserId);  // Ensure to use _socket here
      });

      _socket!.onDisconnect((_) {
        print('Disconnected from server');
      });

      print('Socket connected');
    }
  }

  IO.Socket? get socket => _socket;
}
