import 'package:flutter/material.dart';

// Widget que tiene el background de la pantalla del Login

class LoginBackground extends StatelessWidget {

  const LoginBackground({super.key});

  LinearGradient _getBackgroundGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.blue[300]!,
        Colors.blue[900]!,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: _getBackgroundGradient()),
    );
  }
}
