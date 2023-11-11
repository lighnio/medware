import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medware/components/custom_textfield.dart';

class AdminInventory extends StatefulWidget {
  const AdminInventory({super.key});

  @override
  State<AdminInventory> createState() => AdminInventoryState();
}

class AdminInventoryState extends State<AdminInventory> {
  TextEditingController _search = TextEditingController();
  final ValueNotifier<String> _searchFilter = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('meds').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No hay nada en el inventario...'));
          }

          List items = snapshot.data!.docs.map((med) => med.data()).toList();

          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                context.push('/admin/inventory/add');
              },
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StatefulBuilder(
                builder: (context, setState) => Column(
                  children: [
                    CustomTextField(_search, 'Busqueda...', hEdgeInset: 5,
                        onChanged: (value) {
                      setState(() {
                        items = snapshot.data!.docs
                            .map((med) => med.data())
                            .toList()
                            .where((med) {
                          return med['genericName']
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              med['name']
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              med['provider']
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              med['registryName']
                                  .toLowerCase()
                                  .contains(value.toLowerCase());
                        }).toList();
                      });
                    }),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) => Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Imagen
                              SizedBox(
                                width: 150,
                                height: 150,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                      'https://source.unsplash.com/random',
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }, fit: BoxFit.cover),
                                ),
                              ),
                              // Información
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Nombre
                                  Text(
                                    items[index]['genericName'],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),

                                  // Descripción
                                  Text(items[index]['name'],
                                      overflow: TextOverflow.ellipsis),
                                  Text(items[index]['provider'],
                                      overflow: TextOverflow.ellipsis),
                                  Text(
                                      'En Stock: ${items[index]['stockPerUnit']}',
                                      style: TextStyle(
                                          color:
                                              items[index]['stockPerUnit'] < 50
                                                  ? Colors.red
                                                  : null)),
                                  Text(
                                      'Precio: Q${items[index]['unitaryPrice']}'),
                                  Text(
                                      'Expiracion: ${items[0]['expireDate'].toDate().toString().split(" ")[0]}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ));
  }
}
