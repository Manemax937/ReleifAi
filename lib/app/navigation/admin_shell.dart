import 'package:flutter/material.dart';

import '../screens/admin/ngo_dashboard_screen.dart';
import '../screens/admin/ngo_incident_list_screen.dart';
import '../screens/admin/team_assignment_screen.dart';
import '../screens/shared/profile_screen.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _index = 0;

  static const _titles = [
    'NGO Dashboard',
    'NGO Incidents',
    'Team Assignment',
    'Profile',
  ];

  static const _pages = [
    NgoDashboardScreen(),
    NgoIncidentListScreen(),
    TeamAssignmentScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_index])),
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.space_dashboard_outlined),
            label: 'Dashboard',
          ),
          NavigationDestination(icon: Icon(Icons.receipt_long), label: 'Incidents'),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            label: 'Teams',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
