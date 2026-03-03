import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = 'https://tropicalfruitandveg.com/';
  static const String apiVersion = '${apiUrl}api';

  Future<Map<String, dynamic>> sendApiReqest({
    required String path,
    required dynamic body,
    String method = 'get',
  }) async {
    final targetUrl = '$apiVersion/$path';
    try {
      final response = await _request(targetUrl: targetUrl, body: body, method: method);
      return _decodeResponse(response);
    } catch (_) {
      // Web CORS/mixed-origin failures can throw ClientException before a response exists.
      if (!kIsWeb || method.toLowerCase() != 'get') {
        return {};
      }

      // Fallback through a CORS-friendly proxy for browser builds.
      try {
        final proxyUrl = 'https://api.allorigins.win/raw?url=${Uri.encodeComponent(targetUrl)}';
        final response = await http.get(Uri.parse(proxyUrl));
        return _decodeResponse(response);
      } catch (_) {
        return {};
      }
    }
  }

  Future<http.Response> _request({
    required String targetUrl,
    required dynamic body,
    required String method,
  }) async {
    switch (method.toLowerCase()) {
      case 'get':
        return http.get(Uri.parse(targetUrl));
      case 'post':
        return http.post(Uri.parse(targetUrl), body: body);
      case 'put':
        return http.put(Uri.parse(targetUrl), body: body);
      case 'delete':
        return http.delete(Uri.parse(targetUrl));
      default:
        return http.get(Uri.parse(targetUrl));
    }
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    if (response.statusCode != 200) {
      return {};
    }

    try {
      final utfBody = utf8.decode(response.bodyBytes, allowMalformed: true);
      final jsonText = _extractJsonObject(utfBody);
      final decoded = jsonDecode(jsonText);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } on FormatException {
      final latinBody = latin1.decode(response.bodyBytes, allowInvalid: true);
      final jsonText = _extractJsonObject(latinBody);
      final decoded = jsonDecode(jsonText);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    }

    return {};
  }

  String _extractJsonObject(String raw) {
    final start = raw.indexOf('{');
    final end = raw.lastIndexOf('}');
    if (start >= 0 && end > start) {
      return raw.substring(start, end + 1);
    }
    return raw;
  }
}
