import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/city_model.dart';
import '../models/governorate_model.dart';

class LocationLocalDatasource {
  static const String _governoratesAssetPath =
      'assets/data/governorates.json';
  static const String _citiesAssetPath = 'assets/data/cities.json';
  static const String _dataKey = 'data';

  Future<List<GovernorateModel>> loadGovernorates() async {
    final raw = await rootBundle.loadString(_governoratesAssetPath);
    final items = _decodeDataArray(raw);
    return items.map(GovernorateModel.fromJson).toList();
  }

  Future<List<CityModel>> loadCitiesForGovernorate(
    String governorateId,
  ) async {
    final raw = await rootBundle.loadString(_citiesAssetPath);
    final items = _decodeDataArray(raw);
    return items
        .map(CityModel.fromJson)
        .where((city) => city.governorateId == governorateId)
        .toList();
  }

  List<Map<String, dynamic>> _decodeDataArray(String raw) {
    final decoded = jsonDecode(raw);
    final data = switch (decoded) {
      List<dynamic> entries => _findTableData(entries),
      Map<String, dynamic> root => root[_dataKey],
      _ => null,
    };
    if (data is! List) return const [];
    return data.cast<Map<String, dynamic>>();
  }

  Object? _findTableData(List<dynamic> entries) {
    for (final entry in entries) {
      if (entry is Map<String, dynamic> && entry[_dataKey] is List) {
        return entry[_dataKey];
      }
    }
    return null;
  }
}