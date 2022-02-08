import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:puzzle_hack/service/puzzle_service.dart';
import 'package:puzzle_hack/ui/puzzle_hack.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    const mainColor = Colors.amber;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: mainColor,
        statusBarColor: mainColor,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.transparent));

    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: mainColor,
            title: const Text('Puzzle Hack'),
            systemOverlayStyle: const SystemUiOverlayStyle(
              systemNavigationBarColor: mainColor,
              statusBarColor: mainColor,
            ),
          ),
          backgroundColor: mainColor.shade100,
          body: ChangeNotifierProvider<PuzzleService>(
              create: (_) => PuzzleService(), child: const PuzzleHack()),
        ),
        debugShowCheckedModeBanner: false,
        theme: theme.copyWith(
          backgroundColor: mainColor.shade100,
          primaryColor: mainColor,
        ));
  }
}
