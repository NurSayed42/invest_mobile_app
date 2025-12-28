import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AdminService {
  static const String baseUrl = 'http://localhost:8000/api';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: 'access');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> getInspectionStats() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/inspections/stats/'),
        headers: headers,
      );



      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load stats: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getInspectionStats: $e');
      return {
        'total': 0,
        'pending': 0,
        'in_progress': 0,
        'completed': 0,
        'approved': 0,
        'rejected': 0,
      };
    }
  }

  Future<List<dynamic>> getAllInspections() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/inspections/all/'),
        headers: headers,
      );



      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load inspections: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getAllInspections: $e');
      return [];
    }
  }
}