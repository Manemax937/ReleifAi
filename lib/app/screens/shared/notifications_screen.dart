import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../widgets/app_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: MockData.notifications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return AppCard(
          child: Row(
            children: [
              const Icon(Icons.notifications_active_outlined),
              const SizedBox(width: 12),
              Expanded(child: Text(MockData.notifications[index])),
            ],
          ),
        );
      },
    );
  }
}
