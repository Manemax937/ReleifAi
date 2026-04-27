import 'package:flutter/material.dart';

import '../../models/incident.dart';
import '../../widgets/app_card.dart';
import '../../widgets/status_badge.dart';

class VolunteerIncidentDetailScreen extends StatelessWidget {
  const VolunteerIncidentDetailScreen({required this.incident, super.key});

  final Incident incident;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Incident Detail')),
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
                Text('ID: ${incident.id}'),
                Text('Location: ${incident.location}'),
                Text('Priority: ${incident.priority}'),
                const SizedBox(height: 12),
                Text(incident.description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
