import 'package:flutter/material.dart';

import 'gov_service.dart';

/// An unofficial preparation aid shown on the Templates tab.
///
/// A template is either a checklist (items can be ticked) or a worksheet
/// (labelled blank lines to copy and fill in on paper).
class PrepTemplate {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<ChecklistItem> checklist;
  final List<String> worksheetFields;

  const PrepTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.checklist = const [],
    this.worksheetFields = const [],
  });

  bool get isChecklist => checklist.isNotEmpty;

  /// Plain text version for the "Copy text" button.
  String toPlainText() {
    final buffer = StringBuffer()
      ..writeln(title)
      ..writeln('(Unofficial preparation aid - not a government form)')
      ..writeln();
    for (final item in checklist) {
      buffer.writeln('[ ] ${item.text}');
    }
    for (final field in worksheetFields) {
      buffer.writeln('$field: ______________________________');
    }
    return buffer.toString();
  }
}
