import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'providers/book_provider.dart';
import 'providers/draft_provider.dart';
import 'screens/main_navigation_screen.dart'; // Import navigation

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://gahqbtyvzpnkdeiaoyzt.supabase.co',
    publishableKey: 'sb_publishable_SNWJBYVPI8c9i7qbjdEqEg_qxqx5HBX',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(
          create: (_) => DraftProvider(),
        ), // Daftarkan Provider Database
      ],
      child: MaterialApp(
        title: 'InkSpire',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFF5F0E6),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF5D4037),
            primary: const Color(0xFF5D4037),
          ),
          textTheme: GoogleFonts.loraTextTheme().apply(
            bodyColor: const Color(0xFF3E2723),
            displayColor: const Color(0xFF3E2723),
          ),
        ),
        home: const MainNavigationScreen(), // Ubah home ke Navigation
      ),
    );
  }
}
