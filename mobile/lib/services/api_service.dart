import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/act_summary.dart';
import '../models/section_summary.dart';
import '../models/section_detail.dart';
import '../config/app_config.dart';

class ApiService {
  final String baseUrl;
  final http.Client _client;

  ApiService({String? baseUrl, http.Client? client})
    : baseUrl = baseUrl ?? AppConfig.apiBaseUrl,
      _client = client ?? http.Client();

  // Health check
  Future<bool> checkHealth() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/health'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'ok';
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // List all acts
  Future<List<ActSummary>> listActs() async {
    final response = await _client.get(Uri.parse('$baseUrl/acts'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ActSummary.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load acts: ${response.statusCode}');
    }
  }

  // Get sections for an act
  Future<List<SectionSummary>> getActSections(
    String actId, {
    int offset = 0,
    int limit = 20,
  }) async {
    final uri = Uri.parse('$baseUrl/acts/$actId/sections').replace(
      queryParameters: {'offset': offset.toString(), 'limit': limit.toString()},
    );

    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> items = data['items'];
      return items.map((json) => SectionSummary.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sections: ${response.statusCode}');
    }
  }

  // Get specific section detail
  Future<SectionDetail> getSectionDetail(
    String actId,
    String sectionNumber,
  ) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/acts/$actId/sections/$sectionNumber'),
    );

    if (response.statusCode == 200) {
      return SectionDetail.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Section not found');
    } else {
      throw Exception('Failed to load section: ${response.statusCode}');
    }
  }

  // Search across acts
  Future<List<Map<String, dynamic>>> search(
    String query, {
    String? actId,
    int limit = 20,
  }) async {
    final queryParams = {'q': query, 'limit': limit.toString()};
    if (actId != null) {
      queryParams['act_id'] = actId;
    }

    final uri = Uri.parse(
      '$baseUrl/search',
    ).replace(queryParameters: queryParams);
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['items']);
    } else {
      throw Exception('Search failed: ${response.statusCode}');
    }
  }

  void dispose() {
    _client.close();
  }
}
