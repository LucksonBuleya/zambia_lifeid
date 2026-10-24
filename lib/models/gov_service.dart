import 'package:flutter/material.dart';

/// How trustworthy a piece of information is. Shown to the user as a badge
/// so they can tell official facts apart from general advice.
enum InfoStatus {
  /// Taken from an official government web page (see the service's sources).
  official,

  /// General preparation advice written for this app. Not government policy.
  guidance,

  /// Could not be confirmed from an official source yet.
  needsVerification,
}

/// One item the user can tick off. The [id] must never change, because
/// saved checklist progress is stored against it.
class ChecklistItem {
  final String id;
  final String text;

  const ChecklistItem(this.id, this.text);
}

class FeeItem {
  final String label;
  final String amount;

  const FeeItem(this.label, this.amount);
}

class OfficialSource {
  final String name;
  final String url;

  const OfficialSource(this.name, this.url);
}

/// A government service, for example a passport or driving licence.
class GovService {
  final String id;
  final String name;

  /// Short name for the home screen grid, e.g. "NRC".
  final String shortName;
  final String shortDescription;
  final IconData icon;
  final List<String> keywords;

  final String overview;
  final List<String> beforeYouApply;

  final List<ChecklistItem> requirements;
  final InfoStatus requirementsStatus;

  final List<String> steps;
  final InfoStatus stepsStatus;
  final String? stepsNote;

  final String authority;
  final String officeGuidance;

  /// Empty when no official fee information was found.
  final List<FeeItem> fees;
  final String? processingTime;

  final List<OfficialSource> sources;
  final String lastChecked;

  const GovService({
    required this.id,
    required this.name,
    required this.shortName,
    required this.shortDescription,
    required this.icon,
    required this.keywords,
    required this.overview,
    required this.beforeYouApply,
    required this.requirements,
    required this.requirementsStatus,
    required this.steps,
    required this.stepsStatus,
    this.stepsNote,
    required this.authority,
    required this.officeGuidance,
    this.fees = const [],
    this.processingTime,
    required this.sources,
    required this.lastChecked,
  });

  /// Used by the home screen search.
  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return name.toLowerCase().contains(q) ||
        shortDescription.toLowerCase().contains(q) ||
        keywords.any((k) => k.contains(q));
  }
}
