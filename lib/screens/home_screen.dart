import 'package:flutter/material.dart';

import '../data/services_data.dart';
import '../models/gov_service.dart';
import '../theme.dart';
import '../widgets/service_card.dart';
import '../widgets/typewriter_text.dart';
import 'service_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _tile(GovService service) => ServiceGridTile(
        service: service,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ServiceDetailScreen(service: service)),
        ),
      );

  void _clearSearch() {
    _searchController.clear();
    setState(() => _query = '');
  }

  @override
  Widget build(BuildContext context) {
    final results = govServices.where((s) => s.matches(_query)).toList();
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Zambia LifeID', style: textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    const Text(
                      'Know what to bring before you go',
                      style: TextStyle(color: AppColors.muted, fontSize: 15),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.greenLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.fact_check_outlined, color: AppColors.green),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hint: const TypewriterText(
                phrases: [
                  'What document do you need?',
                  'Try "passport"',
                  'Try "NRC"',
                  'Try "driving licence"',
                  'Try "birth certificate"',
                ],
                style: TextStyle(color: AppColors.muted, fontSize: 16),
              ),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      icon: const Icon(Icons.close),
                      onPressed: _clearSearch,
                    ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Essential Documents', style: textTheme.titleMedium),
          const SizedBox(height: 12),
          if (results.isEmpty)
            _NoResults(query: _query, onClear: _clearSearch)
          else
            // Two tiles per row. IntrinsicHeight keeps both tiles in a row the
            // same height, even when a name wraps onto two lines.
            for (var i = 0; i < results.length; i += 2)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: _tile(results[i])),
                      const SizedBox(width: 12),
                      Expanded(
                        child: i + 1 < results.length
                            ? _tile(results[i + 1])
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
          if (_query.isEmpty) ...[
            const SizedBox(height: 8),
            const _PrepareIntro(),
          ],
          const SizedBox(height: 16),
          const Text(
            'Zambia LifeID is a student project and preparation guide, not an official '
            'government app. Always confirm requirements with the responsible authority.',
            style: TextStyle(color: AppColors.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _PrepareIntro extends StatelessWidget {
  const _PrepareIntro();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.greenLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Prepare before you visit an office',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.navy),
          ),
          SizedBox(height: 6),
          Text(
            'Check the requirements, follow the steps and tick off your checklist, '
            'so you arrive with everything and avoid extra trips.',
            style: TextStyle(color: AppColors.navy),
          ),
        ],
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  final String query;
  final VoidCallback onClear;

  const _NoResults({required this.query, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          const Icon(Icons.search_off, size: 48, color: AppColors.muted),
          const SizedBox(height: 12),
          Text(
            'No services match "$query"',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          const Text(
            'Try NRC, birth, passport or driving.',
            style: TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onClear, child: const Text('Show all services')),
        ],
      ),
    );
  }
}
