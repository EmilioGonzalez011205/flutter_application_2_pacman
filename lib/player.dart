import 'package:flutter/material.dart';
//Este archivo fué creado para mostrar la imagen del pacman en la pantalla.
class Player extends StatelessWidget {
  const Player({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Image.asset('lib/images/pacman.png'));
  }
}