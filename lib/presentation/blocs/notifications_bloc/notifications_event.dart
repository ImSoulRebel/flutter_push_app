part of 'notifications_bloc.dart';

sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class NotificationStatusChanged extends NotificationsEvent {
  final AuthorizationStatus authorizationStatus;
  const NotificationStatusChanged({required this.authorizationStatus});
}

class NotificationReceived extends NotificationsEvent {
  final PushMessageEntity message;
  const NotificationReceived({required this.message});
}
