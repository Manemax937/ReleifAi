import '../models/incident.dart';

class MockData {
  static const emergencyContacts = <Map<String, String>>[
    {'name': 'National Emergency', 'phone': '112'},
    {'name': 'Medical Helpline', 'phone': '108'},
    {'name': 'Local Police', 'phone': '100'},
  ];

  static const safetyTips = <String>[
    'Stay in a visible, populated area when possible.',
    'Keep emergency numbers accessible and charged phone ready.',
    'Share live location with trusted contacts during travel.',
    'Carry a small first-aid kit in your bag or vehicle.',
    'Do not confront danger directly; prioritize personal safety.',
  ];

  static final incidents = <Incident>[
    Incident(
      id: 'INC-2401',
      title: 'Flooded street assistance',
      location: 'Sector 12, Riverside',
      status: 'In Progress',
      priority: 'High',
      reportedAt: DateTime(2026, 4, 24, 9, 15),
      description:
          'Water levels rising quickly. Need immediate evacuation support for elderly residents.',
      assignedTeam: 'Rescue Team A',
    ),
    Incident(
      id: 'INC-2397',
      title: 'Medical supply shortage',
      location: 'Community Clinic, East End',
      status: 'Open',
      priority: 'Medium',
      reportedAt: DateTime(2026, 4, 23, 14, 30),
      description:
          'Clinic reports shortage of essential supplies and needs coordinated volunteer drop-off.',
      assignedTeam: 'Logistics Unit',
    ),
    Incident(
      id: 'INC-2389',
      title: 'Temporary shelter setup',
      location: 'City School Grounds',
      status: 'Resolved',
      priority: 'Low',
      reportedAt: DateTime(2026, 4, 21, 18, 45),
      description:
          'Shelter tents and food distribution point were requested and completed successfully.',
      assignedTeam: 'Shelter Team',
    ),
  ];

  static const notifications = <String>[
    'Weather alert: heavy rain expected in 3 hours.',
    'Volunteer Team B assigned to INC-2401.',
    'Your profile verification is complete.',
    'Safety tip of the day: carry an emergency whistle.',
  ];
}
