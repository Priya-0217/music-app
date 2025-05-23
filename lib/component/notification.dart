import 'package:permission_handler/permission_handler.dart';

Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.request();

  if (status.isGranted) {
    print("✅ Notification permission granted");
  } else {
    print("❌ Notification permission denied");
  }
}
