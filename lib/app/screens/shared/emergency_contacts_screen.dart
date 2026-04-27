import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../widgets/app_card.dart';

class EmergencyContactsScreen extends StatelessWidget {
  const EmergencyContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: MockData.emergencyContacts.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final contact = MockData.emergencyContacts[index];
        return AppCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.local_phone_outlined),
            title: Text(contact['name'] ?? '-'),
            subtitle: Text(contact['phone'] ?? '-'),
            trailing: FilledButton.tonalIcon(
              onPressed: () {},
              icon: const Icon(Icons.call),
              label: const Text('Call'),
            ),
          ),
        );
      },
    );
  }
}
