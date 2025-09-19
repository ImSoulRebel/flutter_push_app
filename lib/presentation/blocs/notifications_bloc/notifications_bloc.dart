import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_push/config/helpers/helpers.dart';
import 'package:flutter_push/domain/entities/entities.dart';
import 'package:flutter_push/firebase_options.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  debugPrint('Handling a background message: ${message.messageId}');
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationsBloc() : super(const NotificationsState()) {
    on<NotificationStatusChanged>(_notificationStatusChanged);
    on<NotificationReceived>(_notificationReceived);

    // Verificar el estado de los permisos
    _initialCheckStatus();
    // Escuchar los mensajes en foreground
    _onForegroundMessage();
  }

  static Future<void> initializeFirebaseNotifications() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void _notificationStatusChanged(
    NotificationStatusChanged event,
    Emitter<NotificationsState> emit,
  ) {
    emit(state.copyWith(authorizationStatus: event.authorizationStatus));
    _getFirebaseNotificationsToken();
  }

  void _notificationReceived(
    NotificationReceived event,
    Emitter<NotificationsState> emit,
  ) {
    final message = event.message;

    emit(state.copyWith(notifications: [message, ...state.notifications]));
  }

  Future<void> _initialCheckStatus() async {
    final settings = await messaging.getNotificationSettings();
    add(
      NotificationStatusChanged(
        authorizationStatus: settings.authorizationStatus,
      ),
    );
  }

  Future<void> _getFirebaseNotificationsToken() async {
    if (state.authorizationStatus != AuthorizationStatus.authorized) {
      return;
    }
    String? token = await messaging.getToken();
    debugPrint('Firebase Messaging Token: $token');
  }

  void handleRemoteMessage(RemoteMessage message) {
    if (message.notification == null) {
      return;
    }
    final parsedId = StringFormaters.messageIdParser(message.messageId!);

    final imageUrl = Platform.isAndroid
        ? message.notification?.android?.imageUrl
        : message.notification?.apple?.imageUrl;

    final notification = PushMessageEntity(
      messageId: parsedId,
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sendDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: imageUrl,
    );
    add(NotificationReceived(message: notification));
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    add(
      NotificationStatusChanged(
        authorizationStatus: settings.authorizationStatus,
      ),
    );
  }

  PushMessageEntity? getMessageById(String messageId) {
    try {
      return state.notifications.firstWhere(
        (message) => message.messageId == messageId,
      );
    } catch (e) {
      return null;
    }
  }
}
