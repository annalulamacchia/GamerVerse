import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:gamerverse/models/report.dart';
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
      print(reporterId);
      print(response.body);

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

  // Funzione per mappare i dati in oggetti Report
  static List<Report> _parseReports(List<dynamic> reportList) {
    return reportList.map((reportData) {
      return Report.fromJson(reportData);
    }).toList();
  }

  static Future<Map<String, List<Report>>> getPendingReports() async {
    try {
      final response = await http.get(Uri.parse(
          'https://gamerversemobile.pythonanywhere.com/get_pending_reports'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        Map<String, List<Report>> reports = {
          'Users': _parseReports(data['user_reports']),
          'Posts': _parseReports(data['post_reports']),
          'Reviews': _parseReports(data['review_reports']),
        };

        if (kDebugMode) {
          print('Success to load pending reports');
        }

        return reports;
      } else {
        if (kDebugMode) {
          print('Failed to load pending reports');
        }
        return {
          'Users': [],
          'Posts': [],
          'Reviews': [],
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return {
        'Users': [],
        'Posts': [],
        'Reviews': [],
      };
    }
  }

  static Future<Map<String, List<Report>>> getAcceptedReports() async {
    try {
      final response = await http.get(Uri.parse(
          'https://gamerversemobile.pythonanywhere.com/get_accepted_reports'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Crea la mappa dei report separati per tipo
        Map<String, List<Report>> reports = {
          'Users': _parseReports(data['user_reports']),
          'Posts': _parseReports(data['post_reports']),
          'Reviews': _parseReports(data['review_reports']),
        };

        if (kDebugMode) {
          print('Success to load accepted reports');
        }

        return reports;
      } else {
        if (kDebugMode) {
          print('Failed to load accepted reports');
        }
        return {
          'Users': [],
          'Posts': [],
          'Reviews': [],
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return {
        'Users': [],
        'Posts': [],
        'Reviews': [],
      };
    }
  }

  static Future<Map<String, List<Report>>> getDeclinedReports() async {
    try {
      final response = await http.get(Uri.parse(
          'https://gamerversemobile.pythonanywhere.com/get_declined_reports'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Crea la mappa dei report separati per tipo
        Map<String, List<Report>> reports = {
          'Users': _parseReports(data['user_reports']),
          'Posts': _parseReports(data['post_reports']),
          'Reviews': _parseReports(data['review_reports']),
        };

        if (kDebugMode) {
          print('Success to load declined reports');
        }

        return reports;
      } else {
        if (kDebugMode) {
          print('Failed to load declined reports');
        }
        return {
          'Users': [],
          'Posts': [],
          'Reviews': [],
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return {
        'Users': [],
        'Posts': [],
        'Reviews': [],
      };
    }
  }

  static Future<bool> acceptReport(String reportId) async {
    try {
      final response = await http.post(
        Uri.parse('https://gamerversemobile.pythonanywhere.com/accept_report'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'report_id': reportId}),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Success to accept the report');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('Failed to accept the report');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return false;
    }
  }

  // Decline a report
  static Future<bool> declineReport(String reportId) async {
    try {
      final response = await http.post(
        Uri.parse('https://gamerversemobile.pythonanywhere.com/decline_report'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'report_id': reportId}),
      );
      if (kDebugMode) {
        print(response.body);
      }

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Success to decline the report');
        }

        return true;
      } else {
        if (kDebugMode) {
          print('Failed to decline the report');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return false;
    }
  }
}
