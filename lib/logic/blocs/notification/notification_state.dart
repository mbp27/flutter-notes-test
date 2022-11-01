part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationIndexed extends NotificationState {
  final PushNotification notification;

  const NotificationIndexed(this.notification);

  @override
  List<Object?> get props => [notification];
}

class NotificationFailureState extends NotificationState {
  final String errorMessage;

  const NotificationFailureState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
