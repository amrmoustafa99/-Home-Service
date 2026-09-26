import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Offer {
  final String id;
  final String name;
  final String description;
  final String code;
  final String icon;
  final String usageNote;
  final bool isActive;
  final DateTime expiryDate;
  final int? progressCurrent;
  final int? progressTarget;

  const Offer({
    required this.id,
    required this.name,
    required this.description,
    required this.code,
    required this.icon,
    required this.usageNote,
    required this.isActive,
    required this.expiryDate,
    this.progressCurrent,
    this.progressTarget,
  });

  bool get isExpired => !isActive || expiryDate.isBefore(DateTime.now());

  bool get hasProgress => progressCurrent != null && progressTarget != null;

  int get daysRemaining => expiryDate.difference(DateTime.now()).inDays;

  static const Map<String, IconData> _iconMap = {
    'ac_unit': Icons.ac_unit,
    'star': Icons.star,
    'card_giftcard': Icons.card_giftcard,
    'cleaning_services': Icons.cleaning_services,
  };

  IconData get iconData => _iconMap[icon] ?? Icons.local_offer;

  factory Offer.fromJson(Map<String, dynamic> json, String id) {
    return Offer(
      id: id,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      code: json['code'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      usageNote: json['usageNote'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      expiryDate:
          (json['expiryDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      progressCurrent: json['progressCurrent'] as int?,
      progressTarget: json['progressTarget'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'code': code,
      'icon': icon,
      'usageNote': usageNote,
      'isActive': isActive,
      'expiryDate': Timestamp.fromDate(expiryDate),
      if (progressCurrent != null) 'progressCurrent': progressCurrent,
      if (progressTarget != null) 'progressTarget': progressTarget,
    };
  }
}
