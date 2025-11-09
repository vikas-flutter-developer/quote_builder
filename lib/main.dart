import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quote_builder/app.dart';
import 'package:quote_builder/features/quote_builder/bloc/quote_builder_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide the BLoC to the entire widget tree
    return BlocProvider(
      create: (context) => QuoteBuilderBloc(),
      child: const App(),
    );
  }
}