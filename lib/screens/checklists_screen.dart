import 'package:flutter/material.dart';

import '../data/services_data.dart';
import '../data/templates_data.dart';
import '../theme.dart';
import '../widgets/checklist_widgets.dart';
import '../widgets/service_card.dart';
import 'checklist_screen.dart';
import 'templates_screen.dart';

/// "My Lists" tab: saved progress for every service and template checklist.
class ChecklistsScreen extends StatelessWidget {
  const ChecklistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final templateChecklists = prepTemplates.where((t) => t.isChecklist);
    return Scaffold(
      appBar: AppBar(title: const Text('My Lists')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          const Text(
            'Your progress is saved on this phone, so it is still here when you reopen the app.',
            style: TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 16),
          Text('Document checklists', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          for (final service in govServices) ...[
            ServiceCard(
              service: service,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ChecklistScreen(service: service)),
              ),
              footer: ChecklistProgress(
                listId: service.id,
                items: service.requirements,
                showReset: false,
              ),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 8),
          Text('Template checklists', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          for (final template in templateChecklists) ...[
            Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => TemplateDetailScreen(template: template)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(template.icon, color: AppColors.green),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              template.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppColors.muted),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ChecklistProgress(
                        listId: template.id,
                        items: template.checklist,
                        showReset: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
