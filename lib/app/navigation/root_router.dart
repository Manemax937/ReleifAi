import 'package:flutter/material.dart';

import '../app.dart';
import '../models/user_role.dart';
import '../theme/app_theme.dart';
import 'auth_flow.dart';
import 'victim_shell.dart';
import 'volunteer_shell.dart';

class RootRouter extends StatelessWidget {
  const RootRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);

    if (auth.booting) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppTheme.primary)),
      );
    }

    final user = auth.user;
    if (user == null) return const AuthFlow();

    switch (user.role) {
      case UserRole.victim:
        return const VictimShell();
      case UserRole.volunteer:
        return const VolunteerShell();
    }
  }
}
