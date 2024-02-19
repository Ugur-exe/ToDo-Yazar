import 'package:flutter/material.dart';
import 'package:yazar/view/books_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: BooksPage(),
      ),
    );
  }
}
