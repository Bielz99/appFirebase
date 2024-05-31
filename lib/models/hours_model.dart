import 'dart:convert';

import 'package:flutter/widgets.dart';

class HoursModel {
  String id;
  String data;
  int minutos;
  String? description;
  HoursModel({
    required this.id,
    required this.data,
    required this.minutos,
    this.description,
  });

  HoursModel copyWith({
    String? id,
    String? data,
    int? minutos,
    ValueGetter<String?>? description,
  }) {
    return HoursModel(
      id: id ?? this.id,
      data: data ?? this.data,
      minutos: minutos ?? this.minutos,
      description: description != null ? description() : this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': data,
      'minutos': minutos,
      'description': description,
    };
  }

  factory HoursModel.fromMap(Map<String, dynamic> map) {
    return HoursModel(
      id: map['id'] ?? '',
      data: map['data'] ?? '',
      minutos: map['minutos']?.toInt() ?? 0,
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory HoursModel.fromJson(String source) =>
      HoursModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HoursModel(id: $id, data: $data, minutos: $minutos, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HoursModel &&
        other.id == id &&
        other.data == data &&
        other.minutos == minutos &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        data.hashCode ^
        minutos.hashCode ^
        description.hashCode;
  }
}
