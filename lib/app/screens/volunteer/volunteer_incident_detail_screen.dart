import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/incident.dart';
import '../../widgets/app_card.dart';
import '../../widgets/status_badge.dart';

class VolunteerIncidentDetailScreen extends StatelessWidget {
  const VolunteerIncidentDetailScreen({required this.incident, super.key});

  final Incident incident;

  Future<void> _openMaps(BuildContext context) async {
    final latitude = incident.latitude;
    final longitude = incident.longitude;

    final Uri uri;
    if (latitude != null && longitude != null) {
      uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude',
      );
    } else {
      uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(incident.location)}',
      );
    }

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open Maps on this device.')),
      );
    }
  }

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
                if (incident.assignedTeam != null) ...[
                  const SizedBox(height: 2),
                  Text('Assigned Team: ${incident.assignedTeam}'),
                ],
                const SizedBox(height: 12),
                Text(incident.description),
                const SizedBox(height: 12),
                Text(
                  incident.guidance ??
                      'Follow on-ground instructions, keep dispatch updated, and use safe access routes.',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: () => _openMaps(context),
                  icon: const Icon(Icons.map_outlined),
                  label: const Text('Open Route in Maps'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
