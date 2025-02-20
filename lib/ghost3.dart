import 'package:flutter/material.dart';
//Este archivo fué creado únciamente para mostrar la imagen de uno de los fantasmas en la pantalla.
class MyGhost3 extends StatelessWidget {
  const MyGhost3({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: Image.asset('lib/images/ghost3.png'),
    );
  }
}