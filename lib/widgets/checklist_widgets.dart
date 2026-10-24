import 'package:flutter/material.dart';

import '../models/gov_service.dart';
import '../services/checklist_store.dart';
import '../theme.dart';

/// Progress bar, "x of y completed" and a reset button for one checklist.
/// Rebuilds automatically when items are ticked.
class ChecklistProgress extends StatelessWidget {
  final String listId;
  final List<ChecklistItem> items;
  final bool showReset;

  const ChecklistProgress({
    super.key,
    required this.listId,
    required this.items,
    this.showReset = true,
  });

  Future<void> _confirmReset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset checklist?'),
        content: const Text('All ticked items in this checklist will be cleared.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed == true) checklistStore.reset(listId);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: checklistStore,
      builder: (context, _) {
        final done = checklistStore.completedCount(listId, items.map((i) => i.id));
        final total = items.length;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    done == total ? 'All $total completed' : '$done of $total completed',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                if (showReset && done > 0)
                  TextButton.icon(
                    onPressed: () => _confirmReset(context),
                    icon: const Icon(Icons.restart_alt, size: 18),
                    label: const Text('Reset'),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : done / total,
                minHeight: 8,
                backgroundColor: AppColors.slateLight,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// A list of tickable items connected to the shared [checklistStore].
class ChecklistItems extends StatelessWidget {
  final String listId;
  final List<ChecklistItem> items;

  const ChecklistItems({super.key, required this.listId, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: checklistStore,
      builder: (context, _) => Column(
        children: [
          for (final item in items)
            CheckboxListTile(
              value: checklistStore.isChecked(listId, item.id),
              onChanged: (_) => checklistStore.toggle(listId, item.id),
              title: Text(item.text),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: false,
            ),
        ],
      ),
    );
  }
}
