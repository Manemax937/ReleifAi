import 'package:flutter/material.dart';

import '../screens/shared/profile_screen.dart';
import '../screens/shared/safety_tips_screen.dart';
import '../screens/victim/incident_tracking_screen.dart';
import '../screens/victim/victim_home_screen.dart';

class VictimShell extends StatefulWidget {
  const VictimShell({super.key});

  @override
  State<VictimShell> createState() => _VictimShellState();
}

class _VictimShellState extends State<VictimShell> {
  int _index = 0;

  static const _titles = [
    'Relief AI',
    'Incident Tracking',
    'Safety Tips',
    'Profile',
  ];

  static const _pages = [
    VictimHomeScreen(),
    IncidentTrackingScreen(),
    SafetyTipsScreen(),
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
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.track_changes_outlined),
            label: 'Track',
          ),
          NavigationDestination(
            icon: Icon(Icons.tips_and_updates_outlined),
            label: 'Tips',
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
