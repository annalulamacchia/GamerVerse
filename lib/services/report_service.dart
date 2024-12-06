import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ReportService {
  //function to add a report
  static Future<bool> addReport({
    required String reporterId,
    required String reportedId,
    required String reason,
    required String type,
  }) async {
    final url =
        Uri.parse("https://gamerversemobile.pythonanywhere.com/add_report");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "reporterId": reporterId,
          "reportedId": reportedId,
          "reason": reason,
          "type": type,
        }),
      );
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Success in adding report");
        }
        return true;
      } else {
        if (kDebugMode) {
          print("Failed to add report");
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error during the request for adding report");
      }
      return false;
    }
  }
}
