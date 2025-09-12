part of 'notifications_bloc.dart';

class NotificationsState extends Equatable {
  final AuthorizationStatus authorizationStatus;
  final List<PushMessageEntity> notifications;

  const NotificationsState({
    this.authorizationStatus = AuthorizationStatus.notDetermined,
    this.notifications = const [],
  });

  @override
  List<Object> get props => [authorizationStatus, notifications];

  NotificationsState copyWith({
    AuthorizationStatus? authorizationStatus,
    List<PushMessageEntity>? notifications,
  }) => NotificationsState(
    authorizationStatus: authorizationStatus ?? this.authorizationStatus,
    notifications: notifications ?? this.notifications,
  );
}
