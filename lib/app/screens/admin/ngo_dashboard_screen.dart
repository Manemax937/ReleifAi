import 'package:flutter/material.dart';

import '../../app.dart';
import '../../widgets/app_card.dart';

class NgoDashboardScreen extends StatelessWidget {
  const NgoDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final incidentController = IncidentScope.of(context);
    return ListenableBuilder(
      listenable: incidentController,
      builder: (context, child) {
        final incidents = incidentController.incidents;
        final resolved = incidents
            .where((incident) => incident.status == 'Resolved')
            .length;
        final critical = incidents
            .where((incident) => incident.status == 'Critical')
            .length;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AppCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  child: Icon(Icons.insights_outlined),
                ),
                title: const Text('Total Incidents'),
                subtitle: Text('${incidents.length} cases'),
              ),
            ),
            const SizedBox(height: 10),
            AppCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(child: Icon(Icons.sos_rounded)),
                title: const Text('Critical Alerts'),
                subtitle: Text('$critical active'),
              ),
            ),
            const SizedBox(height: 10),
            AppCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  child: Icon(Icons.verified_outlined),
                ),
                title: const Text('Resolved Incidents'),
                subtitle: Text('$resolved completed'),
              ),
            ),
          ],
        );
      },
    );
  }
}
