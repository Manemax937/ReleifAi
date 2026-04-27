import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app.dart';
import '../../models/incident.dart';
import '../../widgets/app_card.dart';

class VolunteerDashboardScreen extends StatelessWidget {
  const VolunteerDashboardScreen({super.key});

  Future<void> _openMaps(Incident incident, BuildContext context) async {
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
    final incidentController = IncidentScope.of(context);
    return ListenableBuilder(
      listenable: incidentController,
      builder: (context, child) {
        final incidents = incidentController.volunteerIncidents;
        final openCount = incidents
            .where((incident) => incident.status.toLowerCase() == 'open')
            .length;
        final progressCount = incidents
            .where((incident) => incident.status.toLowerCase() == 'in progress')
            .length;
        final criticalCount = incidents
            .where(
              (incident) =>
                  incident.priority.toLowerCase() == 'red' ||
                  incident.priority.toLowerCase() == 'critical',
            )
            .length;

        return RefreshIndicator(
          onRefresh: incidentController.refreshAssignedIncidents,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Assigned Dispatches',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Refresh assignments',
                    onPressed: () =>
                        incidentController.refreshAssignedIncidents(),
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _MetricTile(
                title: 'Critical Alerts',
                value: '$criticalCount',
                icon: Icons.sos_rounded,
              ),
              const SizedBox(height: 10),
              _MetricTile(
                title: 'Open Cases',
                value: '$openCount',
                icon: Icons.inbox,
              ),
              const SizedBox(height: 10),
              _MetricTile(
                title: 'In Progress',
                value: '$progressCount',
                icon: Icons.timelapse,
              ),
              const SizedBox(height: 10),
              _MetricTile(
                title: 'Total Assigned',
                value: '${incidents.length}',
                icon: Icons.assignment_turned_in_outlined,
              ),
              const SizedBox(height: 14),
              if (incidents.isEmpty)
                const AppCard(
                  child: Text(
                    'No incident assigned yet. Pull down to refresh after admin dispatches a team.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ...incidents.map(
                (incident) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                incident.id,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    incident.status.toLowerCase() ==
                                        'in progress'
                                    ? Colors.blue.withValues(alpha: 0.12)
                                    : Colors.orange.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                incident.status,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('Location: ${incident.location}'),
                        const SizedBox(height: 3),
                        Text('Priority: ${incident.priority}'),
                        if (incident.assignedTeam != null) ...[
                          const SizedBox(height: 3),
                          Text('Team: ${incident.assignedTeam}'),
                        ],
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _openMaps(incident, context),
                                icon: const Icon(Icons.map_outlined),
                                label: const Text('Open Map'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          CircleAvatar(child: Icon(icon)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
