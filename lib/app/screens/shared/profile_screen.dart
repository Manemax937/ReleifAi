import 'package:flutter/material.dart';

import '../../app.dart';
import '../../models/user_role.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);
    final user = auth.user;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.name ?? 'Guest User',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 6),
              Text(user?.email ?? '-'),
              const SizedBox(height: 6),
              Text('Role: ${user?.role.label ?? '-'}'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Settings'),
              const SizedBox(height: 8),
              SwitchListTile(
                value: true,
                onChanged: (_) {},
                title: const Text('Push notifications'),
                contentPadding: EdgeInsets.zero,
              ),
              SwitchListTile(
                value: false,
                onChanged: (_) {},
                title: const Text('Location sharing'),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppButton(
          label: 'Logout',
          onPressed: auth.logout,
          icon: Icons.logout,
        ),
      ],
    );
  }
}
