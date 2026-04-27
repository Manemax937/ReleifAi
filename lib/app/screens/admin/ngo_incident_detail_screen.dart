import 'package:flutter/material.dart';

import '../../models/incident.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/status_badge.dart';

class NgoIncidentDetailScreen extends StatelessWidget {
  const NgoIncidentDetailScreen({required this.incident, super.key});

  final Incident incident;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NGO Incident Detail')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        incident.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    StatusBadge(text: incident.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Incident ID: ${incident.id}'),
                Text('Location: ${incident.location}'),
                Text('Assigned Team: ${incident.assignedTeam ?? 'Unassigned'}'),
                const SizedBox(height: 12),
                Text(incident.description),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppButton(label: 'Assign Team', onPressed: () {}),
        ],
      ),
    );
  }
}
