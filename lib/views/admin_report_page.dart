import 'package:flutter/material.dart';
import 'package:gamerverse/models/report.dart';
import 'package:gamerverse/services/report_service.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/widgets/admin/category_reports.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/firebase_auth_helper.dart';
import '../widgets/specific_game/no_data_list.dart';

class AdminReportPage extends StatefulWidget {
  const AdminReportPage({super.key});

  @override
  AdminReportPageState createState() => AdminReportPageState();
}

class AdminReportPageState extends State<AdminReportPage> {
  late String? userId = '';
  Future<Map<String, List<Report>>> reports = Future.value({});
  String selectedStatus = 'Pending';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  //load the user_id
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? uid = prefs.getString('user_uid');
    final valid = await FirebaseAuthHelper.checkTokenValidity();
    setState(() {
      if (valid) {
        userId = uid;
      } else {
        userId = null;
      }
    });
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    reports = _loadReports();
  }

  Future<Map<String, List<Report>>> _loadReports() async {
    if (selectedStatus == 'Pending') {
      return await ReportService.getPendingReports(userId: userId!);
    } else if (selectedStatus == 'Accepted') {
      return await ReportService.getAcceptedReports(userId: userId!);
    } else {
      return await ReportService.getDeclinedReports(userId: userId!);
    }
  }

  // Load Pending Reports
  Future<void> _loadPendingReports() async {
    setState(() {
      reports = ReportService.getPendingReports(userId: userId!);
    });
  }

  // Load Accepted Reports
  Future<void> _loadAcceptedReports() async {
    setState(() {
      reports = ReportService.getAcceptedReports(userId: userId!);
    });
  }

  // Load Declined Reports
  Future<void> _loadDeclinedReports() async {
    setState(() {
      reports = ReportService.getDeclinedReports(userId: userId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final parentContext = context;
    return Scaffold(
      backgroundColor: AppColors.darkestGreen,
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Reports', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Sections
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatusButton('Declined', Colors.red),
                  _buildStatusButton('Pending', Colors.orange),
                  _buildStatusButton('Accepted', Colors.green),
                ],
              ),
            ),
            FutureBuilder<Map<String, List<Report>>>(
              future: reports, // Pass the Future that loads all reports
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(color: Colors.teal));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Data is empty'));
                } else {
                  // Access the reports by category (Users, Posts, Reviews)
                  Map<String, List<dynamic>> reportsData = snapshot.data!;
                  if (reportsData['Users']!.isEmpty &&
                      reportsData['Posts']!.isEmpty &&
                      reportsData['Reviews']!.isEmpty) {
                    if (selectedStatus == 'Declined') {
                      return NoDataList(
                        message: 'No reports available.',
                        subMessage: 'There are no Declined reports yet',
                        color: Colors.red,
                        textColor: Colors.white,
                        icon: Icons.report_off,
                      );
                    } else if (selectedStatus == 'Accepted') {
                      return NoDataList(
                        message: 'No reports available.',
                        subMessage: 'There are no Accepted reports yet',
                        color: Colors.green,
                        textColor: Colors.white,
                        icon: Icons.report_off,
                      );
                    } else if(selectedStatus == 'Pending' && reportsData['BlockedUsers'] != null && reportsData['BlockedUsers']!.isEmpty){
                      return NoDataList(
                        message: 'No reports available.',
                        subMessage: 'There are no Pending reports yet',
                        color: Colors.orange,
                        textColor: Colors.white,
                        icon: Icons.report_off,
                      );
                    }
                  }
                  return Column(
                    children: [
                      // Users reports section
                      if (reportsData['Users'] != null &&
                          reportsData['Users']!.isNotEmpty)
                        ReportsCategory(
                          title: 'Users',
                          selectedStatus: selectedStatus,
                          reports: reportsData['Users']!,
                          parentContext: parentContext,
                          onPending: _loadPendingReports,
                          onDeclined: _loadDeclinedReports,
                          onAccepted: _loadAcceptedReports,
                          userId: userId!,
                        ),
                      const SizedBox(height: 10),
                      // Posts reports section
                      if (reportsData['Posts'] != null &&
                          reportsData['Posts']!.isNotEmpty)
                        ReportsCategory(
                          title: 'Posts',
                          selectedStatus: selectedStatus,
                          reports: reportsData['Posts']!,
                          parentContext: parentContext,
                          onPending: _loadPendingReports,
                          onDeclined: _loadDeclinedReports,
                          onAccepted: _loadAcceptedReports,
                          userId: userId!,
                        ),
                      const SizedBox(height: 10),
                      // Reviews reports section
                      if (reportsData['Reviews'] != null &&
                          reportsData['Reviews']!.isNotEmpty)
                        ReportsCategory(
                          title: 'Reviews',
                          selectedStatus: selectedStatus,
                          reports: reportsData['Reviews']!,
                          parentContext: parentContext,
                          onPending: _loadPendingReports,
                          onDeclined: _loadDeclinedReports,
                          onAccepted: _loadAcceptedReports,
                          userId: userId!,
                        ),
                      const SizedBox(height: 10),
                      // Sections for Pending or Declined status
                      if (selectedStatus == 'Pending')
                        if (reportsData['BlockedUsers'] != null &&
                            reportsData['BlockedUsers']!.isNotEmpty)
                          ReportsCategory(
                            title: 'Temporarily Blocked Users',
                            selectedStatus: selectedStatus,
                            reports: reportsData['BlockedUsers']!,
                            parentContext: parentContext,
                            onPending: _loadPendingReports,
                            onDeclined: _loadDeclinedReports,
                            onAccepted: _loadAcceptedReports,
                            userId: userId!,
                          ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 3,
      ),
    );
  }

  //set the status of the section
  Widget _buildStatusButton(String status, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedStatus == status ? color : Colors.white,
      ),
      onPressed: () {
        setState(() {
          selectedStatus = status;
          _fetchReports();
        });
      },
      child: Text(status,
          style: TextStyle(
            color: selectedStatus == status ? Colors.white : Colors.black,
          )),
    );
  }
}
