import 'dart:convert';

import 'package:collection/collection.dart';

enum ReminderInterval {
  no,
  oneDay,
  threeHour,
  oneHour,
}

extension OnReminderInterval on ReminderInterval {
  String get title {
    switch (this) {
      case ReminderInterval.oneDay:
        return '1 day before';
      case ReminderInterval.threeHour:
        return '3 hour before';
      case ReminderInterval.oneHour:
        return '1 hour before';
      default:
        return 'Nothing';
    }
  }

  int get durationInHour {
    switch (this) {
      case ReminderInterval.oneDay:
        return 24;
      case ReminderInterval.threeHour:
        return 3;
      case ReminderInterval.oneHour:
        return 1;
      default:
        return 0;
    }
  }
}

class Note {
  final int? id;
  final String? title;
  final String? description;
  final DateTime? reminderTime;
  final ReminderInterval? reminderInterval;
  final String? file;

  const Note({
    this.id,
    this.title,
    this.description,
    this.reminderTime,
    this.reminderInterval,
    this.file,
  });

  Note copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? reminderTime,
    ReminderInterval? reminderInterval,
    String? file,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      reminderTime: reminderTime ?? this.reminderTime,
      reminderInterval: reminderInterval ?? this.reminderInterval,
      file: file ?? this.file,
    );
  }

  Map<String, dynamic> toUpdate() {
    return {
      'title': title,
      'description': description,
      'reminderTime': reminderTime?.millisecondsSinceEpoch,
      'reminderInterval': reminderInterval?.durationInHour,
      'file': file,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'reminderTime': reminderTime?.millisecondsSinceEpoch,
      'reminderInterval': reminderInterval?.durationInHour,
      'file': file,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['_id']?.toInt(),
      title: map['title'],
      description: map['description'],
      reminderTime: map['reminderTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['reminderTime'])
          : null,
      reminderInterval: map['reminderInterval'] != null
          ? ReminderInterval.values.singleWhereOrNull(
              (element) => element.durationInHour == map['reminderInterval'])
          : null,
      file: map['file'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Note(id: $id, title: $title, description: $description, reminderTime: $reminderTime, reminderInterval: $reminderInterval, file: $file)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Note &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.reminderTime == reminderTime &&
        other.reminderInterval == reminderInterval &&
        other.file == file;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        reminderTime.hashCode ^
        reminderInterval.hashCode ^
        file.hashCode;
  }
}
