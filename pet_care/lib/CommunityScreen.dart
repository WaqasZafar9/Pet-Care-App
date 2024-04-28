import 'package:flutter/material.dart';

class communityScreen extends StatefulWidget {
  const communityScreen({super.key});

  @override
  State<communityScreen> createState() => _communityScreenState();
}

class _communityScreenState extends State<communityScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.pinkAccent.shade400,
              borderRadius: BorderRadius.circular(10)
            ),
          ),
        ),
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white70,

        )
      ]
    );
  }
}
