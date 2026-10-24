import 'package:flutter/material.dart';

import '../models/gov_office.dart';
import '../models/gov_service.dart';
import '../theme.dart';
import 'common_widgets.dart';

/// Shows one office. Missing details are labelled "Not verified" instead of
/// being left out silently.
class OfficeCard extends StatelessWidget {
  final GovOffice office;

  const OfficeCard({super.key, required this.office});

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
                const Icon(Icons.apartment_outlined, color: AppColors.green),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(office.name, style: Theme.of(context).textTheme.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(office.authority, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
            const SizedBox(height: 8),
            StatusBadge(
              office.isFullyVerified ? InfoStatus.official : InfoStatus.needsVerification,
            ),
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.place_outlined,
              text: office.address ?? 'Address not verified. Confirm with the authority.',
              missing: office.address == null,
            ),
            if (office.contacts.isEmpty)
              const _DetailRow(
                icon: Icons.call_outlined,
                text: 'Contact details not verified.',
                missing: true,
              )
            else
              for (final contact in office.contacts)
                _DetailRow(
                  icon: switch (contact.type) {
                    ContactType.phone => Icons.call_outlined,
                    ContactType.whatsapp => Icons.chat_outlined,
                    ContactType.email => Icons.email_outlined,
                    ContactType.website => Icons.language,
                  },
                  text: '${contact.label}: ${contact.value}',
                  onTap: () => openExternal(context, contact.uri),
                ),
            const SizedBox(height: 4),
            Text(office.note, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
            const SizedBox(height: 4),
            InkWell(
              onTap: () => openExternal(context, Uri.parse(office.sourceUrl)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  'Source: ${office.sourceName}',
                  style: const TextStyle(
                    color: AppColors.green,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.green,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool missing;
  final VoidCallback? onTap;

  const _DetailRow({required this.icon, required this.text, this.missing = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = missing
        ? AppColors.amber
        : onTap != null
            ? AppColors.green
            : AppColors.navy;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: TextStyle(color: color))),
          ],
        ),
      ),
    );
  }
}
