import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Holds everything the user enters across the steps.
class JoinData {
  // Step 1
  XFile? avatar;
  String name = '';
  String phone = '';
  String email = '';

  // Step 2
  Set<int> categories = {1};
  Set<String> subServices = {};
  String? experience;
  List<XFile> works = [];
  String notes = '';

  // Step 3
  String? city;
  Set<String> days = {};
  TimeOfDay from = const TimeOfDay(hour: 10, minute: 0);
  TimeOfDay to = const TimeOfDay(hour: 20, minute: 0);
}