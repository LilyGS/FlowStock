import 'package:flutter/material.dart';

class FlowstockTextStyles {
  // Clase para configurar el formato de los títulos,
  // mensajes o botones

  static const TextStyle title = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle title2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle titleAppBar =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white);

  static const TextStyle titleOptions =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w500);

  static const TextStyle listTitle = TextStyle(fontWeight: FontWeight.bold);

  static const TextStyle listSubTitle = TextStyle(
      fontSize: 12,
      color: Color(0xFF757575) // debe ser Colors.grey[600]  pero no lo acepta
      );

  static const TextStyle buttonAction = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
