import 'dart:convert';

import 'package:collection/collection.dart';

enum StoreVisitType { noVisit, visit }

class StoreVisit {
  final int? id;
  final String? storeId;
  final StoreVisitType? type;
  final DateTime? date;
  final String? latitude;
  final String? longitude;

  StoreVisit({
    this.id,
    this.storeId,
    this.type,
    this.date,
    this.latitude,
    this.longitude,
  });

  StoreVisit copyWith({
    int? id,
    String? storeId,
    StoreVisitType? type,
    DateTime? date,
    String? latitude,
    String? longitude,
  }) {
    return StoreVisit(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      type: type ?? this.type,
      date: date ?? this.date,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'store_id': storeId,
      'type': type?.name.toUpperCase(),
      'date': date?.millisecondsSinceEpoch,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory StoreVisit.fromMap(Map<String, dynamic> map) {
    return StoreVisit(
      id: map['id']?.toInt(),
      storeId: map['storeId'],
      type: map['type'] != null
          ? StoreVisitType.values.singleWhereOrNull(
              (element) => element.name.toUpperCase() == map['type'])
          : null,
      date: map['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['date'])
          : null,
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreVisit.fromJson(String source) =>
      StoreVisit.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StoreVisit(id: $id, storeId: $storeId, type: $type, date: $date, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StoreVisit &&
        other.id == id &&
        other.storeId == storeId &&
        other.type == type &&
        other.date == date &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        storeId.hashCode ^
        type.hashCode ^
        date.hashCode ^
        latitude.hashCode ^
        longitude.hashCode;
  }
}
