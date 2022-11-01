part of 'notification_bloc.dart';

class NotificationEvent extends Equatable {
  final String? payload;

  const NotificationEvent({this.payload});

  @override
  List<Object?> get props => [payload];
}

class NotificationFailureEvent extends NotificationEvent {
  final String error;

  const NotificationFailureEvent({required this.error}) : super(payload: null);

  @override
  List<Object?> get props => [error];
}
