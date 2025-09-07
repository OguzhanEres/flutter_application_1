import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const HaberCraftApp());
}

class HaberCraftApp extends StatelessWidget {
  const HaberCraftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HaberCraft Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0F17),
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme.apply(bodyColor: const Color(0xFFEAF2FF)),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF5B9DFF),
          secondary: Color(0xFF8B5BFF),
          surface: Color(0xFF131A26),
          background: Color(0xFF0B0F17),
          onSurface: Color(0xFFEAF2FF),
          onBackground: Color(0xFFEAF2FF),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
