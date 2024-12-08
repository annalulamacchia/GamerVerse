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

  //function to map reports in Report model
  static List<Report> _parseReports(List<dynamic> reportList) {
    return reportList.map((reportData) {
      return Report.fromJson(reportData);
    }).toList();
  }

  //function to get Pending reports
  static Future<Map<String, List<Report>>> getPendingReports(
      {required String userId}) async {
    final url = Uri.parse(
        'https://gamerversemobile.pythonanywhere.com/get_pending_reports');
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"userId": userId}),
      );
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        Map<String, List<Report>> reports = {
          'Users': _parseReports(data['user_reports']),
          'Posts': _parseReports(data['post_reports']),
          'Reviews': _parseReports(data['review_reports']),
          'BlockedUsers': _parseReports(data['blocked_users']),
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

  //function to get Accepted reports
  static Future<Map<String, List<Report>>> getAcceptedReports(
      {required String userId}) async {
    final url = Uri.parse(
        'https://gamerversemobile.pythonanywhere.com/get_accepted_reports');
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"userId": userId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

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

  //function to get Declined reports
  static Future<Map<String, List<Report>>> getDeclinedReports(
      {required String userId}) async {
    final url = Uri.parse(
        'https://gamerversemobile.pythonanywhere.com/get_declined_reports');
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"userId": userId}),
      );
      print(response.body);
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

  static Future<dynamic> getAdditionalInfo({
    required String reportType,
    required String reportedId,
  }) async {
    final url = Uri.parse(
        'https://gamerversemobile.pythonanywhere.com/get_additional_info');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'type': reportType,
          'reportedId': reportedId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Mappa il JSON al tipo corretto
        final additionalInfo = data['additional_info'] ?? {};
        switch (reportType) {
          case 'User':
            return AdditionalUserInfo.fromJson(additionalInfo);
          case 'Post':
            return AdditionalPostInfo.fromJson(additionalInfo);
          case 'Review':
            return AdditionalReviewInfo.fromJson(additionalInfo);
          default:
            throw Exception("Invalid report type");
        }
      } else {
        throw Exception(
            "Failed to fetch additional info: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching additional info: $e");
    }
  }

//function to make the admin accept the report
  static Future<bool> acceptReport(
      {required String reportId, required String userId}) async {
    final url =
        Uri.parse('https://gamerversemobile.pythonanywhere.com/accept_report');
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"userId": userId, 'reportId': reportId}),
      );
      print(response.body);

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

//function to make the admin decline a report
  static Future<bool> declineReport(
      {required String reportId, required String userId}) async {
    final url =
        Uri.parse('https://gamerversemobile.pythonanywhere.com/decline_report');
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"userId": userId, 'reportId': reportId}),
      );

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

  static Future<bool> isAdmin({required String userId}) async {
    final url =
        Uri.parse('https://gamerversemobile.pythonanywhere.com/is_admin');
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"userId": userId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (kDebugMode) {
          print('Success in getting isAdmin: ${data['isAdmin']}');
        }
        return data['isAdmin'];
      } else {
        if (kDebugMode) {
          print('Fail in getting isAdmin: ${response.body}');
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

  static Future<bool> blockUnblockUser({
    required String userId,
    required String action, // 'block' o 'unblock'
    required String reportedId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://gamerversemobile.pythonanywhere.com/block_unblock_user'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'userId': userId,
          'action': action,
          'reportedId': reportedId,
        }),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Success in block/unblock user: ${response.body}');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('Fail in block/unblock user: ${response.body}');
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
