import 'package:flutter/material.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';

class AuthFlow extends StatefulWidget {
  const AuthFlow({super.key});

  @override
  State<AuthFlow> createState() => _AuthFlowState();
}

class _AuthFlowState extends State<AuthFlow> {
  bool _showSignup = false;

  @override
  Widget build(BuildContext context) {
    if (_showSignup) {
      return SignupScreen(onGoLogin: () => setState(() => _showSignup = false));
    }

    return LoginScreen(onGoSignup: () => setState(() => _showSignup = true));
  }
}
