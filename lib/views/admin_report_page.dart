import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/admin/category_reports.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';

class AdminReportPage extends StatefulWidget {
  const AdminReportPage({super.key});

  @override
  AdminReportPageState createState() => AdminReportPageState();
}

class AdminReportPageState extends State<AdminReportPage> {
  //Default section
  String selectedStatus = 'Pending';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      appBar: AppBar(
        backgroundColor: const Color(0xff163832),
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

          ReportsCategory(title: 'Users', selectedStatus: selectedStatus),
          const SizedBox(height: 10),
          ReportsCategory(title: 'Posts', selectedStatus: selectedStatus),
          const SizedBox(height: 10),
          ReportsCategory(title: 'Reviews', selectedStatus: selectedStatus),
          const SizedBox(height: 10),
          if (selectedStatus == 'Pending')
            ReportsCategory(
                title: 'Temporary Blocked Users',
                selectedStatus: selectedStatus),
          if (selectedStatus == 'Declined')
            ReportsCategory(
                title: 'Permanently Blocked Users',
                selectedStatus: selectedStatus),
        ],
      )),
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
        });
      },
      child: Text(status,
          style: TextStyle(
            color: selectedStatus == status ? Colors.white : Colors.black,
          )),
    );
  }
}
