import 'package:flutter/material.dart';

import '../../app.dart';
import '../../widgets/app_card.dart';

class TeamAssignmentScreen extends StatelessWidget {
  const TeamAssignmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final incidentController = IncidentScope.of(context);
    return ListenableBuilder(
      listenable: incidentController,
      builder: (context, child) {
        final incidents = incidentController.incidents;
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: incidents.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final incident = incidents[index];
            return AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    incident.title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text('Current team: ${incident.assignedTeam ?? 'Unassigned'}'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton.tonal(
                        onPressed: () {},
                        child: const Text('Rescue Team A'),
                      ),
                      FilledButton.tonal(
                        onPressed: () {},
                        child: const Text('Medical Unit'),
                      ),
                      FilledButton.tonal(
                        onPressed: () {},
                        child: const Text('Logistics Team'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
