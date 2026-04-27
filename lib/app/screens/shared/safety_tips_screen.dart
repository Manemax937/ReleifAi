import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../widgets/app_card.dart';

class SafetyTipsScreen extends StatelessWidget {
  const SafetyTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: MockData.safetyTips.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final tip = MockData.safetyTips[index];
        return AppCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${index + 1}. '),
              Expanded(child: Text(tip)),
            ],
          ),
        );
      },
    );
  }
}
