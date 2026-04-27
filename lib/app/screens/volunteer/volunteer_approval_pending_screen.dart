import 'package:flutter/material.dart';

import '../../app.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';

class VolunteerApprovalPendingScreen extends StatelessWidget {
  const VolunteerApprovalPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);
    final user = auth.user;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: AppCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.verified_user_outlined,
                      size: 48,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Volunteer Approval Pending',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Hi ${user?.name ?? 'Volunteer'}, your account is registered successfully. '
                      'An admin must approve your profile before incident assignments can be dispatched to your app.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    AppButton(
                      label: 'Refresh status',
                      onPressed: () => auth.refreshCurrentUser(),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: auth.logout,
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
