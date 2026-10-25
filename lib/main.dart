import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// Import file yang baru kita buat
import 'providers/book_provider.dart';
import 'screens/inspiration_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://gahqbtyyzpwkdeiaoyzt.supabase.co',
    publishableKey: 'sb_publishable_SNWJBVVP18c917qbjdEqEg_qxqx5HBX', 
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Daftarkan BookProvider di sini
        ChangeNotifierProvider(create: (_) => BookProvider()),
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
        // Ubah home menjadi InspirationScreen
        home: const InspirationScreen(), 
      ),
    );
  }
}