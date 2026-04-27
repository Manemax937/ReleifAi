import 'package:flutter/material.dart';

import '../../app.dart';
import '../../widgets/app_card.dart';
import '../../widgets/status_badge.dart';
import 'ngo_incident_detail_screen.dart';

class NgoIncidentListScreen extends StatelessWidget {
  const NgoIncidentListScreen({super.key});

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
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => NgoIncidentDetailScreen(incident: incident),
                  ),
                );
              },
              child: AppCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            incident.title,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Text(incident.location),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusBadge(text: incident.status),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
