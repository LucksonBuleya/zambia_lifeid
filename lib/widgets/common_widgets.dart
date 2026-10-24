import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/services_data.dart';
import '../models/gov_service.dart';
import '../theme.dart';

/// A white rounded card with a heading, used for each section of a screen.
class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final InfoStatus? status;
  final Widget child;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.green, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(title, style: Theme.of(context).textTheme.titleMedium),
                ),
              ],
            ),
            if (status != null) ...[
              const SizedBox(height: 8),
              StatusBadge(status!),
            ],
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

/// Small label that tells users where information comes from.
class StatusBadge extends StatelessWidget {
  final InfoStatus status;

  const StatusBadge(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    final (label, icon, fg, bg) = switch (status) {
      InfoStatus.official => (
          'From official source',
          Icons.verified_outlined,
          AppColors.green,
          AppColors.greenLight,
        ),
      InfoStatus.guidance => (
          'General advice (not official policy)',
          Icons.lightbulb_outline,
          AppColors.muted,
          AppColors.slateLight,
        ),
      InfoStatus.needsVerification => (
          'Needs official verification',
          Icons.error_outline,
          AppColors.amber,
          AppColors.amberLight,
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

/// A tinted box for notes and warnings.
class InfoNote extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool warning;

  const InfoNote(this.text, {super.key, this.icon = Icons.info_outline, this.warning = false});

  @override
  Widget build(BuildContext context) {
    final fg = warning ? AppColors.amber : AppColors.green;
    final bg = warning ? AppColors.amberLight : AppColors.greenLight;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: fg),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(color: AppColors.navy))),
        ],
      ),
    );
  }
}

/// A bullet point line of text.
class BulletText extends StatelessWidget {
  final String text;

  const BulletText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 7, right: 10),
            child: CircleAvatar(radius: 3, backgroundColor: AppColors.green),
          ),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

/// Opens a web link, phone number or email in another app. Shows a message
/// with the link if nothing on the phone can open it.
Future<void> openExternal(BuildContext context, Uri uri) async {
  final messenger = ScaffoldMessenger.of(context);
  var opened = false;
  try {
    opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    opened = false;
  }
  if (!opened) {
    messenger.showSnackBar(SnackBar(content: Text('Could not open $uri')));
  }
}

/// A tappable official source that opens in the phone's browser.
class SourceLinkTile extends StatelessWidget {
  final OfficialSource source;

  const SourceLinkTile(this.source, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.open_in_new, color: AppColors.green),
      title: Text(source.name),
      subtitle: Text(source.url, style: const TextStyle(color: AppColors.green)),
      onTap: () => openExternal(context, Uri.parse(source.url)),
    );
  }
}

/// Dropdown for choosing one of Zambia's ten provinces.
class ProvinceDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const ProvinceDropdown({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Select your province',
        prefixIcon: Icon(Icons.map_outlined),
      ),
      items: [
        for (final p in zambianProvinces) DropdownMenuItem(value: p, child: Text('$p Province')),
      ],
      onChanged: onChanged,
    );
  }
}
