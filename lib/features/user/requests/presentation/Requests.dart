import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: const [
      ListTile(
        title: Text("Paracetamol"),
        subtitle: Text("Medicamento para el dolor"),
        leading: Icon(Icons.medical_services),
        trailing: Text("10 disponibles"),
      ),
      ListTile(
        title: Text("Ibuprofeno"),
        subtitle: Text("Medicamento para la fiebre"),
        leading: Icon(Icons.medical_services),
        trailing: Text("20 disponibles"),
      ),
    ]);
  }
}
