import 'package:flutter/material.dart';

class BlankLayout extends StatefulWidget {
  const BlankLayout({super.key, required this.child});

  final Widget child;

  @override
  State<BlankLayout> createState() => _BlankLayoutState();
}

class _BlankLayoutState extends State<BlankLayout> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: widget.child,
    );
  }
}
