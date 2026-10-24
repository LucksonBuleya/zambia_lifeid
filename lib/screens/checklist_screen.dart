import 'package:flutter/material.dart';

import '../models/gov_service.dart';
import '../services/checklist_store.dart';
import '../widgets/checklist_widgets.dart';
import '../widgets/common_widgets.dart';
import '../widgets/service_card.dart';
import 'service_detail_screen.dart';

/// The preparation checklist for one service.
class ChecklistScreen extends StatelessWidget {
  final GovService service;

  /// True when opened from the details screen, so tapping the card goes back.
  final bool openedFromDetails;

  const ChecklistScreen({super.key, required this.service, this.openedFromDetails = false});

  void _openDetails(BuildContext context) {
    if (openedFromDetails) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ServiceDetailScreen(service: service)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ids = service.requirements.map((i) => i.id);
    return Scaffold(
      appBar: AppBar(title: const Text('Preparation checklist')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          ServiceCard(
            service: service,
            onTap: () => _openDetails(context),
          ),
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChecklistProgress(listId: service.id, items: service.requirements),
                  const SizedBox(height: 8),
                  ChecklistItems(listId: service.id, items: service.requirements),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          ListenableBuilder(
            listenable: checklistStore,
            builder: (context, _) {
              final allDone =
                  checklistStore.completedCount(service.id, ids) == service.requirements.length;
              return allDone
                  ? const InfoNote(
                      'You have everything on this list. Before you travel, confirm the '
                      'office, opening hours and current fees with the responsible authority.',
                      icon: Icons.check_circle_outline,
                    )
                  : const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 14),
          const Text(
            'Your progress is saved on this phone only. Zambia LifeID does not collect '
            'ID numbers, passwords or document scans.',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
