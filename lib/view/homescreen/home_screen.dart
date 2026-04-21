import 'package:flutter/material.dart';

class ActivityTrackerDashboard extends StatefulWidget {
  const ActivityTrackerDashboard({super.key});

  @override
  State<ActivityTrackerDashboard> createState() => _ActivityTrackerDashboardState();
}

class _ActivityTrackerDashboardState extends State<ActivityTrackerDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Tracker Dashboard'),
      ),
      body: const Center(
        child: Text('Welcome to the Activity Tracker Dashboard!'),
      ),
    );
  }
}