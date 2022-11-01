import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutternotestest/data/models/push_notification.dart';
import 'package:flutternotestest/helpers/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

part 'notification_event.dart';
part 'notification_state.dart';

const notificationChannelId = "high_importance_channel";
const notificationChannelName = "High Importance Notifications";
const notificationChannelDescription =
    "This channel is used for important notifications.";

int _notificationId = 1; //Id for every notification

final FlutterLocalNotificationsPlugin _localNotifications =
    FlutterLocalNotificationsPlugin();

void onDidReceiveBackgroundNotificationResponse(details) {
  final payload = details.payload;
  if (payload != null) {
    NotificationBloc()._onSelectNotification(payload);
  }
}

Future<void> cancelNotification(int id) async {
  await _localNotifications.cancel(id);
}

Future<void> cancelAllNotification() async {
  await _localNotifications.cancelAll();
}

/// Return true if success
Future<bool> showNotification(PushNotification payload) async {
  Int64List vibrationPattern = Int64List(4);
  vibrationPattern[0] = 0;
  vibrationPattern[1] = 200;
  vibrationPattern[2] = 200;
  vibrationPattern[3] = 200;

  BigTextStyleInformation bigTextStyleInformation =
      BigTextStyleInformation(payload.body!, contentTitle: payload.title);

  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    _notificationId.toString(),
    notificationChannelName,
    channelDescription: notificationChannelDescription,
    icon: '@mipmap/ic_launcher',
    color: MyColors.pallete,
    vibrationPattern: vibrationPattern,
    importance: Importance.max,
    priority: Priority.max,
    styleInformation: bigTextStyleInformation,
  );
  DarwinNotificationDetails iOSPlatformChannelSpecifics =
      const DarwinNotificationDetails();
  NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  final granted = await Permission.notification.isGranted;
  if (!granted) {
    return false;
  }

  await _localNotifications.show(
    payload.id,
    payload.title,
    payload.body,
    platformChannelSpecifics,
    payload: payload.toJson(),
  );
  return true;
}

/// Return true if success
Future<bool> scheduledNotification({
  required PushNotification payload,
  required DateTime scheduledDate,
}) async {
  Int64List vibrationPattern = Int64List(4);
  vibrationPattern[0] = 0;
  vibrationPattern[1] = 200;
  vibrationPattern[2] = 200;
  vibrationPattern[3] = 200;

  BigTextStyleInformation bigTextStyleInformation =
      BigTextStyleInformation(payload.body!, contentTitle: payload.title);

  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    _notificationId.toString(),
    notificationChannelName,
    channelDescription: notificationChannelDescription,
    icon: '@mipmap/ic_launcher',
    color: MyColors.pallete,
    vibrationPattern: vibrationPattern,
    importance: Importance.max,
    priority: Priority.max,
    styleInformation: bigTextStyleInformation,
  );
  DarwinNotificationDetails iOSPlatformChannelSpecifics =
      const DarwinNotificationDetails();
  NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  final granted = await Permission.notification.isGranted;
  if (!granted) {
    return false;
  }

  await _localNotifications.zonedSchedule(
    payload.id,
    payload.title,
    payload.body,
    tz.TZDateTime.from(scheduledDate, tz.local),
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.dateAndTime,
    payload: payload.toJson(),
  );
  return true;
}

Future<bool> _requestIOSPermissions() async {
  IOSFlutterLocalNotificationsPlugin? platformImplementation =
      _localNotifications.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
  bool permission = false;
  if (platformImplementation != null) {
    permission = (await platformImplementation.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    ))!;
  }
  return permission;
}

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  late bool _hasLaunched;
  String? _payload;
  String? _fcmToken;

  NotificationBloc()
      : _hasLaunched = false,
        super(NotificationInitial()) {
    on<NotificationEvent>((event, emit) {
      if (event.payload != null) {
        PushNotification notification =
            PushNotification.fromJson(event.payload!);
        emit(NotificationIndexed(notification));
      }
    });
    on<NotificationFailureEvent>((event, emit) {
      emit(NotificationFailureState(event.error));
    });
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  Future<void> initialize() async {
    await _configureLocalTimeZone();

    if (Platform.isIOS) {
      await _requestIOSPermissions();
      // if (!hasPermission) {
      //   final status = await Permission.notification.request();
      //   if (!status.isGranted) {
      //     await openAppSettings();
      //   }
      // }
    }

    NotificationAppLaunchDetails? appLaunchDetails =
        await _localNotifications.getNotificationAppLaunchDetails();

    InitializationSettings initializationSettings = _getPlatformSettings();

    bool? isLocalNotificationInitialized = await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );

    if (isLocalNotificationInitialized != null &&
        !isLocalNotificationInitialized) {
      add(const NotificationFailureEvent(
        error: "You can provide permission by going into Settings later.",
      ));
    }

    await _createNotificationChannel();

    _hasLaunched = appLaunchDetails?.didNotificationLaunchApp ?? false;
    if (_hasLaunched) {
      _payload = appLaunchDetails?.notificationResponse?.payload;
    }
  }

  void onDidReceiveNotificationResponse(details) async {
    _onSelectNotification(details.payload);
  }

  Future<void> _onSelectNotification(String? payload) async {
    add(NotificationEvent(payload: payload));
  }

  Future<void> _createNotificationChannel() async {
    AndroidNotificationChannel androidNotificationChannel =
        const AndroidNotificationChannel(
      notificationChannelId,
      notificationChannelName,
      description: notificationChannelDescription,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  InitializationSettings _getPlatformSettings() {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings initializationSettingsIOS =
        const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    return InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
  }

  void checkForLaunchedNotifications() {
    if (_hasLaunched && _payload != null) {
      add(NotificationEvent(payload: _payload));
    }
  }

  String? getFcmToken() => _fcmToken;
}
