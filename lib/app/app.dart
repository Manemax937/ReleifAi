import 'package:flutter/material.dart';

import 'navigation/root_router.dart';
import 'services/auth_controller.dart';
import 'services/incident_controller.dart';
import 'theme/app_theme.dart';

class ReleifAiApp extends StatefulWidget {
  const ReleifAiApp({super.key});

  @override
  State<ReleifAiApp> createState() => _ReleifAiAppState();
}

class _ReleifAiAppState extends State<ReleifAiApp> {
  AuthController? _authController;
  IncidentController? _incidentController;

  @override
  void initState() {
    super.initState();
    _authController ??= AuthController()..bootstrap();
    _incidentController ??= IncidentController();
  }

  @override
  void dispose() {
    _authController?.dispose();
    _incidentController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _authController ??= AuthController()..bootstrap();
    _incidentController ??= IncidentController();

    return AuthScope(
      controller: _authController!,
      child: IncidentScope(
        controller: _incidentController!,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ReleifAI',
          theme: AppTheme.light,
          home: const RootRouter(),
        ),
      ),
    );
  }
}

class AuthScope extends InheritedNotifier<AuthController> {
  const AuthScope({
    required AuthController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static AuthController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AuthScope>();
    assert(scope != null, 'AuthScope not found in widget tree');
    return scope!.notifier!;
  }
}

class IncidentScope extends InheritedNotifier<IncidentController> {
  const IncidentScope({
    required IncidentController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static IncidentController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<IncidentScope>();
    assert(scope != null, 'IncidentScope not found in widget tree');
    return scope!.notifier!;
  }
}
