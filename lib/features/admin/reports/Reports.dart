import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medware/components/custom_buttton.dart';
import 'package:medware/features/admin/reports/data/CreateInventoryReport.dart';

class AdminReports extends StatefulWidget {
  const AdminReports({super.key});

  @override
  State<AdminReports> createState() => _AdminReportsState();
}

class _AdminReportsState extends State<AdminReports> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Generar Reporte de Inventario',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ), // overflow: TextOverflow.ellipsis,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Divider(),
              CustomButton('Generar Reporte de Inventario', () async {
                final db = FirebaseFirestore.instance;
                var meds = await db.collection('meds').get();
                var requests = await db.collection('requests').get();

                await CreateInventoryReport(meds.docs, requests.docs);
              }),
              const Divider(),
              CustomButton('Generar Reporte de Pedidos', () {}),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
