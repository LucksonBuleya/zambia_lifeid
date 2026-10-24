import 'package:flutter/material.dart';

import '../data/offices_data.dart';
import '../data/services_data.dart';
import '../models/gov_office.dart';
import '../theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/office_card.dart';

/// Bottom-navigation tab: pick a province (and optionally a service) to see
/// government offices found in official sources.
class OfficesScreen extends StatefulWidget {
  const OfficesScreen({super.key});

  @override
  State<OfficesScreen> createState() => _OfficesScreenState();
}

class _OfficesScreenState extends State<OfficesScreen> {
  String? _province;
  String? _serviceId; // null means all services

  @override
  Widget build(BuildContext context) {
    final offices = _province == null
        ? const <GovOffice>[]
        : officesIn(_province!, serviceId: _serviceId);
    final heads = headOffices(serviceId: _serviceId);

    return Scaffold(
      appBar: AppBar(title: const Text('Offices')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          const Text(
            'Choose your province to see government offices found in official sources. '
            'Always confirm opening hours and services before you travel.',
            style: TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 16),
          ProvinceDropdown(
            value: _province,
            onChanged: (value) => setState(() => _province = value),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: const Text('All services'),
                selected: _serviceId == null,
                onSelected: (_) => setState(() => _serviceId = null),
              ),
              for (final service in govServices)
                ChoiceChip(
                  label: Text(service.shortName),
                  selected: _serviceId == service.id,
                  onSelected: (_) => setState(() => _serviceId = service.id),
                ),
            ],
          ),
          const SizedBox(height: 20),
          if (_province == null)
            const _SelectProvincePrompt()
          else if (offices.isEmpty)
            InfoNote(
              'No verified offices for $_province Province are in this app yet. '
              'Contact a head office below to find the nearest office for your service.',
              icon: Icons.help_outline,
              warning: true,
            )
          else
            for (final office in offices) ...[
              OfficeCard(office: office),
              const SizedBox(height: 12),
            ],
          if (_province != 'Lusaka' && heads.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text('Head offices (Lusaka)', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            const Text(
              'You can contact these offices to ask which office serves your area.',
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 12),
            for (final office in heads) ...[
              OfficeCard(office: office),
              const SizedBox(height: 12),
            ],
          ],
        ],
      ),
    );
  }
}

class _SelectProvincePrompt extends StatelessWidget {
  const _SelectProvincePrompt();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Icon(Icons.location_searching, size: 44, color: AppColors.muted),
          SizedBox(height: 10),
          Text(
            'Select a province to see offices.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
