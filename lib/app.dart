import 'package:flutter/material.dart';
import 'package:quote_builder/core/theme/app_theme.dart';
import 'package:quote_builder/features/quote_builder/screens/quote_form_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote Builder',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const QuoteFormScreen(),
    );
  }
}