import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Remembers which checklist items are ticked, for every checklist in the app.
///
/// Each checklist has its own [listId] (for example "driving" or
/// "tpl_visit") and stores the ids of the ticked items. Progress is saved on
/// the device with shared_preferences. If saving is not possible, the app
/// keeps working and progress lasts until the app is closed.
class ChecklistStore extends ChangeNotifier {
  final Map<String, Set<String>> _checked = {};
  SharedPreferences? _prefs;

  static const _prefix = 'checklist_';

  Future<void> load() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      for (final key in _prefs!.getKeys().where((k) => k.startsWith(_prefix))) {
        _checked[key.substring(_prefix.length)] =
            (_prefs!.getStringList(key) ?? []).toSet();
      }
    } catch (e) {
      debugPrint('Checklist progress will not be saved: $e');
    }
  }

  bool isChecked(String listId, String itemId) =>
      _checked[listId]?.contains(itemId) ?? false;

  int completedCount(String listId, Iterable<String> itemIds) =>
      itemIds.where((id) => isChecked(listId, id)).length;

  void toggle(String listId, String itemId) {
    final items = _checked.putIfAbsent(listId, () => {});
    if (!items.remove(itemId)) items.add(itemId);
    _save(listId);
  }

  void reset(String listId) {
    _checked.remove(listId);
    _save(listId);
  }

  void _save(String listId) {
    notifyListeners();
    final items = _checked[listId];
    if (items == null || items.isEmpty) {
      _prefs?.remove('$_prefix$listId');
    } else {
      _prefs?.setStringList('$_prefix$listId', items.toList());
    }
  }
}

/// One shared store for the whole app.
final checklistStore = ChecklistStore();
