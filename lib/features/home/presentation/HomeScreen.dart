import 'package:flutter/material.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    double txtScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Hola, Bienvenido a MedWare!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 45 * txtScale,
                    fontFamily: 'Times New Roman',
                    fontWeight: FontWeight.w600),
              ),
              Text(
                'Aplicacion interna de gestion del inventario medico.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25 * txtScale,
                    fontFamily: 'Times New Roman',
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'By: Carlos Vasquez',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15 * txtScale,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Times New Roman',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
