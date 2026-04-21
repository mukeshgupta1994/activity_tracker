import 'package:flutter/material.dart';

class FilterScaffold<T> extends StatelessWidget {
  const FilterScaffold({super.key, required this.title, this.list = const []});
  final String title;
  final List<T> list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const SizedBox(),
    );
  }
}
