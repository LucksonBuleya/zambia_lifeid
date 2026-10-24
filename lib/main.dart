import 'package:flutter/material.dart';

import 'screens/checklists_screen.dart';
import 'screens/home_screen.dart';
import 'screens/offices_screen.dart';
import 'screens/templates_screen.dart';
import 'services/checklist_store.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await checklistStore.load(); // restore saved checklist progress
  runApp(const ZambiaLifeIdApp());
}

class ZambiaLifeIdApp extends StatelessWidget {
  const ZambiaLifeIdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zambia LifeID',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const MainShell(),
    );
  }
}

/// Holds the four bottom-navigation tabs. IndexedStack keeps each tab's
/// state (such as the search text) when switching between tabs.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: const [
          HomeScreen(),
          OfficesScreen(),
          TemplatesScreen(),
          ChecklistsScreen(),
        ],
      ),
      // A floating bar with rounded corners, a light border and a soft shadow.
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: NavigationBar(
                selectedIndex: _tab,
                onDestinationSelected: (index) => setState(() => _tab = index),
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.location_on_outlined),
                    selectedIcon: Icon(Icons.location_on),
                    label: 'Offices',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.description_outlined),
                    selectedIcon: Icon(Icons.description),
                    label: 'Templates',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.assignment_turned_in_outlined),
                    selectedIcon: Icon(Icons.assignment_turned_in),
                    label: 'My Lists',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
