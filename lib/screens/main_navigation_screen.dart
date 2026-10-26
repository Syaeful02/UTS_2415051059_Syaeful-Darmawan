import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'inspiration_screen.dart';
import 'my_library_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Definisikan screen di dalam build agar bisa mengakses setState
    final List<Widget> screens = [
      HomeScreen(
        // Oper fungsi untuk pindah ke tab Inspiration (index 1)
        onNavigateToInspiration: () {
          setState(() {
            _selectedIndex = 1;
          });
        },
      ),
      const InspirationScreen(),
      const MyLibraryScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.edit_document), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Inspirasi'),
          NavigationDestination(icon: Icon(Icons.library_books), label: 'My Library'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}