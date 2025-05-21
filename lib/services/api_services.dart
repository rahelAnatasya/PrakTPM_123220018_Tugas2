import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pakaian_model.dart';

class ApiService {
  static const String baseUrl =
      'https://tpm-api-tugas-872136705893.us-central1.run.app/api/clothes';

  static Future<List<Pakaian>> fetchPakaian() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));
      if (res.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(res.body);
        if (jsonResponse['status'] == 'Success') {
          final List<dynamic> jsonList = jsonResponse['data'] as List<dynamic>;
          return jsonList
              .map((e) => Pakaian.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception(jsonResponse['message'] ?? 'Unknown error');
        }
      } else {
        throw Exception('Failed to load data: ${res.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Network error: $e');
    }
  }

  static Future<Pakaian> fetchDetail(int id) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/$id'));
      if (res.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(res.body);
        if (jsonResponse['status'] == 'Success') {
          return Pakaian.fromJson(jsonResponse['data'] as Map<String, dynamic>);
        } else {
          throw Exception(jsonResponse['message'] ?? 'Unknown error');
        }
      } else if (res.statusCode == 404) {
        throw Exception('Clothing not found 😮');
      } else {
        throw Exception('Failed to load detail: ${res.statusCode}');
      }
    } catch (e) {
      print('Error fetching detail: $e');
      throw Exception('Network error: $e');
    }
  }

  static Future<void> createPakaian(Pakaian pakaian) async {
    try {
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(pakaian.toJson()),
      );
      if (res.statusCode == 201 || res.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(res.body);
        if (jsonResponse['status'] != 'Success') {
          throw Exception(jsonResponse['message'] ?? 'Unknown error');
        }
      } else if (res.statusCode == 400) {
        final Map<String, dynamic> jsonResponse = json.decode(res.body);
        throw Exception(jsonResponse['message'] ?? 'Bad request');
      } else {
        throw Exception('Failed to create: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<void> updatePakaian(int id, Pakaian pakaian) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(pakaian.toJson()),
      );
      if (res.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(res.body);
        if (jsonResponse['status'] != 'Success') {
          throw Exception(jsonResponse['message'] ?? 'Unknown error');
        }
      } else if (res.statusCode == 400) {
        final Map<String, dynamic> jsonResponse = json.decode(res.body);
        throw Exception(jsonResponse['message'] ?? 'Bad request');
      } else if (res.statusCode == 404) {
        throw Exception('Clothing not found 😮');
      } else {
        throw Exception('Failed to update: ${res.statusCode}');
      }
    } catch (e) {
      print('Error updating: $e');
      throw Exception('Network error: $e');
    }
  }

  static Future<void> deletePakaian(int id) async {
    try {
      final res = await http.delete(Uri.parse('$baseUrl/$id'));
      if (res.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(res.body);
        if (jsonResponse['status'] != 'Success') {
          throw Exception(jsonResponse['message'] ?? 'Unknown error');
        }
      } else if (res.statusCode == 404) {
        throw Exception('Clothing not found 😮');
      } else {
        throw Exception('Failed to delete: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
