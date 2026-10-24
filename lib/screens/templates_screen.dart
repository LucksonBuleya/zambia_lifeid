import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/templates_data.dart';
import '../models/prep_template.dart';
import '../theme.dart';
import '../widgets/checklist_widgets.dart';
import '../widgets/common_widgets.dart';

const _unofficialNotice =
    'Unofficial preparation aid made for this app. It is not a government form.';

/// Bottom-navigation tab listing the preparation templates.
class TemplatesScreen extends StatelessWidget {
  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Templates')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          const InfoNote(
            'These templates help you get ready. They are unofficial and are not '
            'government forms. Official forms are provided by the responsible office.',
          ),
          const SizedBox(height: 16),
          for (final template in prepTemplates) ...[
            _TemplateCard(template: template),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final PrepTemplate template;

  const _TemplateCard({required this.template});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(template.icon, color: AppColors.green, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(template.title, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(template.description, style: const TextStyle(color: AppColors.muted)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  label: Text(template.isChecklist ? 'Checklist · Unofficial' : 'Worksheet · Unofficial'),
                  labelStyle: const TextStyle(fontSize: 12),
                  visualDensity: VisualDensity.compact,
                  side: const BorderSide(color: AppColors.border),
                  backgroundColor: AppColors.slateLight,
                ),
                FilledButton.tonal(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => TemplateDetailScreen(template: template)),
                  ),
                  child: const Text('View'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows one template: a tickable checklist or a blank practice worksheet.
class TemplateDetailScreen extends StatelessWidget {
  final PrepTemplate template;

  const TemplateDetailScreen({super.key, required this.template});

  Future<void> _copy(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: template.toPlainText()));
    messenger.showSnackBar(const SnackBar(content: Text('Template text copied')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(template.title, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            tooltip: 'Copy text',
            icon: const Icon(Icons.copy_outlined),
            onPressed: () => _copy(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          const InfoNote(_unofficialNotice, warning: true),
          const SizedBox(height: 14),
          Text(template.description, style: const TextStyle(color: AppColors.muted)),
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: template.isChecklist ? _checklist() : _worksheet(),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => _copy(context),
            icon: const Icon(Icons.copy_outlined),
            label: const Text('Copy template text'),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          ),
        ],
      ),
    );
  }

  Widget _checklist() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChecklistProgress(listId: template.id, items: template.checklist),
        const SizedBox(height: 4),
        ChecklistItems(listId: template.id, items: template.checklist),
      ],
    );
  }

  Widget _worksheet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Copy this worksheet and fill it in on paper. Zambia LifeID does not '
          'store anything you write.',
          style: TextStyle(color: AppColors.muted),
        ),
        const SizedBox(height: 12),
        for (final field in template.worksheetFields)
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(field, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 18),
                const Divider(height: 1, thickness: 1, color: AppColors.border),
              ],
            ),
          ),
      ],
    );
  }
}
