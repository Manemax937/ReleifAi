import 'package:flutter/material.dart';

import '../../app.dart';
import '../../widgets/app_card.dart';

class VolunteerDashboardScreen extends StatelessWidget {
  const VolunteerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final incidentController = IncidentScope.of(context);
    return ListenableBuilder(
      listenable: incidentController,
      builder: (context, child) {
        final incidents = incidentController.incidents;
        final openCount = incidents
            .where((incident) => incident.status == 'Open')
            .length;
        final progressCount = incidents
            .where((incident) => incident.status == 'In Progress')
            .length;
        final criticalCount = incidents
            .where((incident) => incident.status == 'Critical')
            .length;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
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
          ],
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
