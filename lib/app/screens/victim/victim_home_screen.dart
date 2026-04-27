import 'package:flutter/material.dart';

import '../../app.dart';
import '../../widgets/app_card.dart';
import '../../widgets/sos_pulse_button.dart';

class VictimHomeScreen extends StatefulWidget {
  const VictimHomeScreen({super.key});

  @override
  State<VictimHomeScreen> createState() => _VictimHomeScreenState();
}

class _VictimHomeScreenState extends State<VictimHomeScreen> {
  static const List<String> _disasterTypes = <String>[
    'Flood',
    'Earthquake',
    'Fire',
    'Landslide',
    'Cyclone',
    'Medical',
  ];

  String? _selectedDisaster;
  bool _sending = false;

  Future<void> _sendSos(BuildContext context, String? disasterType) async {
    if (_sending) return;

    final authController = AuthScope.of(context);
    final user = authController.user;
    final incidentController = IncidentScope.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final sentFor = disasterType == null ? 'general emergency' : disasterType;

    setState(() => _sending = true);
    try {
      final incident = await incidentController.reportSos(
        disasterType: disasterType,
        reporterName: (user?.name.trim().isNotEmpty ?? false)
            ? user!.name.trim()
            : 'Relief User',
        reporterEmail: (user?.email.trim().isNotEmpty ?? false)
            ? user!.email.trim()
            : 'unknown@releif.ai',
        reporterRole: user?.role.name ?? 'victim',
      );

      messenger.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'SOS sent for $sentFor: ${incident.id} is now on dashboard.',
          ),
        ),
      );
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Unable to send SOS right now. Please check internet/location and retry.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Need Help Fast?',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tap a disaster pill to send SOS instantly, or select one and press SOS.',
              ),
              const SizedBox(height: 14),
              Center(
                child: SosPulseButton(
                  label: _sending ? '...' : 'SOS',
                  onPressed: () => _sendSos(context, _selectedDisaster),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _disasterTypes.map((disaster) {
                  final isSelected = _selectedDisaster == disaster;
                  return ActionChip(
                    avatar: isSelected
                        ? const Icon(Icons.check_circle, size: 18)
                        : const Icon(Icons.warning_amber_rounded, size: 18),
                    label: Text(disaster),
                    backgroundColor: isSelected
                        ? Theme.of(context).colorScheme.errorContainer
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    onPressed: () {
                      setState(() {
                        _selectedDisaster = disaster;
                      });
                      _sendSos(context, disaster);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
