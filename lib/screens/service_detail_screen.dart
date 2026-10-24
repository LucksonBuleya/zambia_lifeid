import 'package:flutter/material.dart';

import '../data/offices_data.dart';
import '../models/gov_office.dart';
import '../models/gov_service.dart';
import '../theme.dart';
import '../widgets/card_deck.dart';
import '../widgets/checklist_widgets.dart';
import '../widgets/common_widgets.dart';
import '../widgets/office_card.dart';
import 'checklist_screen.dart';

/// One shared details screen used for every service.
class ServiceDetailScreen extends StatefulWidget {
  final GovService service;

  const ServiceDetailScreen({super.key, required this.service});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  String? _province;

  GovService get service => widget.service;

  void _openChecklist() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ChecklistScreen(service: service, openedFromDetails: true)),
    );
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 14);
    return Scaffold(
      appBar: AppBar(title: Text(service.name, overflow: TextOverflow.ellipsis)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          _header(context),
          gap,
          // Overview and Before You Apply share one swipeable stack of cards,
          // so the page is shorter to scroll.
          CardDeck(
            titles: const ['Overview', 'Before You Apply'],
            cards: [
              SectionCard(
                title: 'Overview',
                icon: Icons.info_outline,
                status: InfoStatus.official,
                child: Text(service.overview),
              ),
              SectionCard(
                title: 'Before You Apply',
                icon: Icons.lightbulb_outline,
                status: InfoStatus.guidance,
                child: Column(
                  children: [for (final tip in service.beforeYouApply) BulletText(tip)],
                ),
              ),
            ],
          ),
          gap,
          SectionCard(
            title: 'Requirements',
            icon: Icons.checklist,
            status: service.requirementsStatus,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ChecklistProgress(listId: service.id, items: service.requirements),
                const SizedBox(height: 4),
                ChecklistItems(listId: service.id, items: service.requirements),
              ],
            ),
          ),
          gap,
          SectionCard(
            title: 'Application Steps',
            icon: Icons.format_list_numbered,
            status: service.stepsStatus,
            child: _steps(),
          ),
          gap,
          SectionCard(
            title: 'Where to Apply',
            icon: Icons.location_on_outlined,
            child: _officeGuidance(),
          ),
          gap,
          SectionCard(
            title: 'Fees and Processing',
            icon: Icons.payments_outlined,
            status: service.fees.isEmpty ? InfoStatus.needsVerification : InfoStatus.official,
            child: _fees(),
          ),
          gap,
          SectionCard(
            title: 'Official Sources',
            icon: Icons.link,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final source in service.sources) SourceLinkTile(source),
                const SizedBox(height: 4),
                Text(
                  'Information last checked: ${service.lastChecked}',
                  style: const TextStyle(color: AppColors.muted, fontSize: 13),
                ),
              ],
            ),
          ),
          gap,
          const InfoNote(
            'Zambia LifeID is a preparation guide, not an official government service. '
            'Requirements can change, so confirm with the responsible authority before you travel.',
            warning: true,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton.icon(
            onPressed: _openChecklist,
            icon: const Icon(Icons.playlist_add_check),
            label: const Text('Start checklist'),
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.greenLight,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(service.icon, color: AppColors.green, size: 30),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            service.shortDescription,
            style: const TextStyle(fontSize: 15, color: AppColors.muted),
          ),
        ),
      ],
    );
  }

  Widget _steps() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < service.steps.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 13,
                  backgroundColor: AppColors.green,
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(service.steps[i])),
              ],
            ),
          ),
        if (service.stepsNote != null) InfoNote(service.stepsNote!, warning: true),
      ],
    );
  }

  Widget _officeGuidance() {
    final offices =
        _province == null ? const <GovOffice>[] : officesIn(_province!, serviceId: service.id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Responsible authority', style: TextStyle(color: AppColors.muted, fontSize: 13)),
        const SizedBox(height: 2),
        Text(service.authority, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text(service.officeGuidance),
        const SizedBox(height: 16),
        ProvinceDropdown(
          value: _province,
          onChanged: (value) => setState(() => _province = value),
        ),
        const SizedBox(height: 12),
        if (_province == null)
          const Text(
            'Choose a province to see office information. The Offices tab also lists head office contacts.',
            style: TextStyle(color: AppColors.muted),
          )
        else if (offices.isEmpty)
          InfoNote(
            'No verified ${service.shortName} office details for $_province Province yet. '
            'Contact the ${service.authority} to confirm the nearest office and its '
            'opening hours before you travel. Head office contacts are on the Offices tab.',
            icon: Icons.help_outline,
            warning: true,
          )
        else
          for (final office in offices)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: OfficeCard(office: office),
            ),
      ],
    );
  }

  Widget _fees() {
    if (service.fees.isEmpty) {
      return Text(
        'Fees and processing times are not published in the sources we checked. '
        'Confirm current fees and processing times with the ${service.authority}.',
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final fee in service.fees)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text(fee.label)),
                const SizedBox(width: 12),
                Text(fee.amount, style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        const SizedBox(height: 4),
        Text(
          service.processingTime ??
              'Processing time: not published in the sources we checked. Ask the office.',
          style: const TextStyle(color: AppColors.muted),
        ),
        const SizedBox(height: 12),
        InfoNote(
          'Fees as published on the official website (checked ${service.lastChecked}). '
          'Fees can change, so confirm before paying.',
        ),
      ],
    );
  }
}
