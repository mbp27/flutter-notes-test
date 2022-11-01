import 'dart:convert';

enum PushNotificationType {
  note,
}

extension SelectedPushNotificationType on PushNotificationType {
  String get toService {
    switch (this) {
      default:
        return name;
    }
  }
}

class PushNotification {
  final int id;
  final String? title;
  final String? body;
  final String? typeId;
  final PushNotificationType type;

  PushNotification({
    required this.id,
    this.title,
    this.body,
    this.typeId,
    required this.type,
  });

  PushNotification copyWith({
    int? id,
    String? title,
    String? body,
    String? typeId,
    PushNotificationType? type,
  }) {
    return PushNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      typeId: typeId ?? this.typeId,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type_id': typeId.toString(),
      'type': type.toService,
    };
  }

  factory PushNotification.fromMap(Map<String, dynamic> map) {
    return PushNotification(
      id: map['id']?.toInt() ?? 0,
      title: map['title'],
      body: map['body'],
      typeId: map['type_id'].toString(),
      type: PushNotificationType.values
          .singleWhere((element) => element.toService == map['type']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PushNotification.fromJson(String source) =>
      PushNotification.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PushNotification(id: $id, title: $title, body: $body, typeId: $typeId, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PushNotification &&
        other.id == id &&
        other.title == title &&
        other.body == body &&
        other.typeId == typeId &&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        body.hashCode ^
        typeId.hashCode ^
        type.hashCode;
  }
}
