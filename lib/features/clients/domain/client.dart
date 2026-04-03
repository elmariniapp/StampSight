import 'package:flutter/material.dart';

class Client {
  final String id;
  final String name;
  final String? company;
  final Color color;
  final String? note;

  const Client({
    required this.id,
    required this.name,
    this.company,
    required this.color,
    this.note,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'company': company,
        'color': color.toARGB32(),
        'note': note,
      };

  factory Client.fromMap(Map<String, dynamic> map) => Client(
        id: map['id'] as String,
        name: map['name'] as String,
        company: map['company'] as String?,
        color: Color(map['color'] as int),
        note: map['note'] as String?,
      );

  Client copyWith({
    String? id,
    String? name,
    String? company,
    Color? color,
    String? note,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      company: company ?? this.company,
      color: color ?? this.color,
      note: note ?? this.note,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Client && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
