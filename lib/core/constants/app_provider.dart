import 'package:flutter/material.dart';

// ───────── Colors ─────────
const kPrimary = Color(0xFF0F5F4A);
const kPrimaryLight = Color(0xFFE3F1EC);
const kBorder = Color(0xFFE0E4E7);
const kHint = Color(0xFF9AA3A9);
const kText = Color(0xFF1B1F23);

// ───────── Static data ─────────
const kCategories = <(String, IconData)>[
  ('نقل و رحلات', Icons.local_shipping_outlined),
  ('نظافة و تنظيم', Icons.cleaning_services_outlined),
  ('إصلاح و صيانة', Icons.build_outlined),
  ('سباكة', Icons.plumbing),
  ('كهرباء', Icons.electrical_services),
  ('تكييف', Icons.ac_unit),
  ('نجارة', Icons.carpenter),
  ('دهان', Icons.format_paint_outlined),
];

const kSubServices = ['تنظيف المنازل', 'مكافحة الحشرات', 'تنظيف بعد التشطيب'];

const kExperienceLevels = [
  'أقل من سنة',
  '1 - 3 سنوات',
  '3 - 5 سنوات',
  '5 - 10 سنوات',
  'أكثر من 10 سنوات',
];

const kCities = ['مدينة أسيوط', 'القاهرة', 'الجيزة', 'الإسكندرية', 'سوهاج'];

const kDays = [
  'السبت',
  'الأحد',
  'الاثنين',
  'الثلاثاء',
  'الأربعاء',
  'الخميس',
  'الجمعة',
];