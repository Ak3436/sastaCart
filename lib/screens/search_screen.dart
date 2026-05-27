import 'package:flutter/material.dart';

import '../utils/edge_to_edge.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Products")),

      body: const EdgeToEdgeBody(
        top: false,
        child: Center(
          child: Text(
            "Search Screen",

            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
