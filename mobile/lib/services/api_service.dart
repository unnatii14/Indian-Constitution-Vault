import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/act_summary.dart';
import '../models/section_summary.dart';
import '../models/section_detail.dart';
import '../models/ai_explanation.dart';
import '../config/app_config.dart';

class ApiService {
  final String baseUrl;
  final http.Client _client;

  ApiService({String? baseUrl, http.Client? client})
    : baseUrl = baseUrl ?? AppConfig.apiBaseUrl,
      _client = client ?? http.Client();

  // Helper method to get headers with API key
  Map<String, String> _getHeaders() {
    return {'Content-Type': 'application/json', 'X-API-Key': AppConfig.apiKey};
  }

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
    print('[API] Fetching acts from: $baseUrl/acts');
    try {
      final response = await _client.get(Uri.parse('$baseUrl/acts'));
      print('[API] Acts response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('[API] Acts loaded: ${data.length} items');
        return data.map((json) => ActSummary.fromJson(json)).toList();
      } else {
        print('[API] Failed to load acts: ${response.statusCode}');
        throw Exception('Failed to load acts: ${response.statusCode}');
      }
    } catch (e) {
      print('[API] Error loading acts: $e');
      rethrow;
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

    print('[API] Fetching sections for $actId: $uri');
    final response = await _client.get(uri);
    print('[API] Sections response: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> items = data['items'];
      print('[API] Sections loaded: ${items.length} items');
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

  // AI Explanation
  Future<AiExplanation> explainSection({
    required String sectionText,
    String language = 'en',
    bool includeExamples = true,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/explain'),
      headers: _getHeaders(),
      body: jsonEncode({
        'section_text': sectionText,
        'language': language,
        'include_examples': includeExamples,
      }),
    );

    if (response.statusCode == 200) {
      return AiExplanation.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('AI explanation failed: ${response.statusCode}');
    }
  }

  // AI Chat
  Future<Map<String, String>> chatQuery({
    required String question,
    String language = 'en',
    String? context,
  }) async {
    print('[API] Sending chat request to: $baseUrl/api/chat');
    print('[API] Question: $question');
    print('[API] Headers: ${_getHeaders()}');

    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/api/chat'),
        headers: _getHeaders(),
        body: jsonEncode({
          'question': question,
          'language': language,
          if (context != null) 'context': context,
        }),
      );

      print('[API] Chat response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('[API] Chat successful');
        return {
          'answer': data['answer'] as String,
          'disclaimer': data['disclaimer'] as String,
        };
      } else {
        print('[API] Chat failed: ${response.statusCode} - ${response.body}');
        throw Exception('Chat query failed: ${response.statusCode}');
      }
    } catch (e) {
      print('[API] Error in chat: $e');
      rethrow;
    }
  }

  // Simplified chat method
  Future<String> chatWithAI({
    required String question,
    String language = 'english',
  }) async {
    final langCode = language.toLowerCase() == 'hindi' ? 'hi' : 'en';
    final result = await chatQuery(question: question, language: langCode);
    return result['answer'] ?? 'Sorry, I could not generate a response.';
  }

  void dispose() {
    _client.close();
  }
}
