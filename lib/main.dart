import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'views/base_camp_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<String>('parties');
  runApp(const ProviderScope(child: MaladumTrackerApp()));
}

class MaladumTrackerApp extends StatelessWidget {
  const MaladumTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maladum Party Tracker',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const BaseCampView(),
    );
  }

  ThemeData _buildTheme() {
    const scaffoldBg = Color(0xFF1A1A1A);
    const cardBg = Color(0xFF2C2C2C);
    const primaryAmber = Color(0xFFE65100);
    const textPrimary = Color(0xFFF5F5F5);
    const textSecondary = Color(0xFF9E9E9E);

    // Keep base so we can merge into its textTheme rather than replacing it.
    final base = ThemeData.dark();

    return base.copyWith(
      scaffoldBackgroundColor: scaffoldBg,
      primaryColor: primaryAmber,
      cardColor: cardBg,
      colorScheme: const ColorScheme.dark(
        primary: primaryAmber,
        surface: cardBg,
        onPrimary: textPrimary,
        onSurface: textPrimary,
        error: Color(0xFFC62828),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: cardBg,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      // Merge into the dark base textTheme so every unlisted style keeps its
      // default light colour instead of falling back to black.
      textTheme: base.textTheme.copyWith(
        bodyLarge: base.textTheme.bodyLarge?.copyWith(color: textPrimary),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(color: textPrimary),
        bodySmall: base.textTheme.bodySmall?.copyWith(color: textSecondary),
        labelSmall: base.textTheme.labelSmall?.copyWith(color: textSecondary),
      ),
      cardTheme: const CardThemeData(color: cardBg),
      listTileTheme: const ListTileThemeData(
        textColor: textPrimary,
        iconColor: textSecondary,
      ),
      expansionTileTheme: const ExpansionTileThemeData(
        textColor: textPrimary,
        iconColor: textSecondary,
        collapsedTextColor: textPrimary,
        collapsedIconColor: textSecondary,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: cardBg,
        modalBackgroundColor: cardBg,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: textSecondary),
        hintStyle: TextStyle(color: textSecondary),
      ),
      dividerColor: Color(0xFF3A3A3A),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: cardBg,
        contentTextStyle: TextStyle(color: textPrimary),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: cardBg,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(color: textPrimary),
      ),
    );
  }
}
