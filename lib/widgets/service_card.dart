import 'package:flutter/material.dart';

import '../models/gov_service.dart';
import '../theme.dart';

/// Rounded card showing a service's icon, name and short description.
class ServiceCard extends StatelessWidget {
  final GovService service;
  final VoidCallback onTap;

  /// Optional extra content under the description, e.g. checklist progress.
  final Widget? footer;

  const ServiceCard({super.key, required this.service, required this.onTap, this.footer});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.greenLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(service.icon, color: AppColors.green),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(service.name, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      service.shortDescription,
                      style: const TextStyle(color: AppColors.muted),
                    ),
                    if (footer != null) ...[
                      const SizedBox(height: 12),
                      footer!,
                    ],
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8, top: 12),
                child: Icon(Icons.chevron_right, color: AppColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact tile for the home screen grid: icon, short name, "View requirements".
class ServiceGridTile extends StatelessWidget {
  final GovService service;
  final VoidCallback onTap;

  const ServiceGridTile({super.key, required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(service.icon, color: AppColors.green, size: 26),
              const SizedBox(height: 14),
              Text(service.shortName, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              const Text(
                'View requirements',
                style: TextStyle(color: AppColors.muted, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
