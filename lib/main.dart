import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await initializeDependencies();

  runApp(const ClaudeCodeMobileApp());
}

class ClaudeCodeMobileApp extends StatelessWidget {
  const ClaudeCodeMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Claude Code Mobile',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
