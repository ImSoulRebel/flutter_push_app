import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_push/config/router/app_router.dart';

class LocalNotificationService {
  static Future<void> requestLocalNotificationsPermission() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  static Future<void> initializeLocalNotifications() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const androidSettings = AndroidInitializationSettings('app_icon');
    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    // const initializationSettings = InitializationSettings(
    //   android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    //   iOS: DarwinInitializationSettings(),
    // );
    // await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void onDidReceiveNotificationResponse(NotificationResponse response) {
    // Manejar la interacción del usuario con la notificación aquí
    // Por ejemplo, navegar a una pantalla específica
    final payload = response.payload;
    if (payload != null) {
      // Navegar a la pantalla correspondiente usando el payload
      appRouter.push('/notification-detail/$payload');
    }
  }

  static Future<void> showLocalNotification({
    required int id,
    String? title,
    String? body,
    String? data,
  }) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      id, // notification id
      title,
      body,
      notificationDetails,
      payload: data,
    );
  }
}
