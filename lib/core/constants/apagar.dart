import 'package:flutter/material.dart';

class Apagar extends StatelessWidget {
  const Apagar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('apagar')),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(onPressed: () {}, child: const Text('Apagar')),
        ),
      ),
      
      body: Container(),
    );
  }
}
