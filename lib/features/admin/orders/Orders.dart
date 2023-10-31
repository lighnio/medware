import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminOrders extends StatefulWidget {
  const AdminOrders({super.key});

  @override
  State<AdminOrders> createState() => _AdminOrdersState();
}

class _AdminOrdersState extends State<AdminOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Solicitudes en Curso', // overflow: TextOverflow.ellipsis,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(8),
          child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('requests').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    'Parece que no hay pedidos pendientes...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.bold),
                  ),
                );
              }
              var orders = snapshot.data!.docs.map((req) {
                var temp = req
                    .data()['requests']
                    .map((elem) => {'owner': req.id, ...elem})
                    .toList();

                return temp;
              }).toList();

              print(orders[0]);

              return Text('');

              return StatefulBuilder(
                builder: (context, setState) => Column(
                  children: [
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, index) => Card(
                          elevation: 2.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          child: ListTile(
                              title: Row(
                                children: [
                                  Text(orders[index]['owner']),
                                ],
                              ),
                              subtitle: Text('Jeje')),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
