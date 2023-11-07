import 'package:flutter/material.dart';
import 'package:shop_app_00/widgets/grocery_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(119, 107, 93,1),
          surface: const Color.fromRGBO(176, 166, 149,1)
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(235, 227, 213,1),
        useMaterial3: true,
      ),
      home: const GroceryList(),
    );
  }
}

