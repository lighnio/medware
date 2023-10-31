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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push('/user/requests/add');
          },
          child: Icon(Icons.add),
        ),
        body: Padding(
          padding: EdgeInsets.all(8),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collectionGroup('users')
                .get()
                .asStream(),
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
              var requests =
                  snapshot.data!.docs.map((req) => req.data()).toList();

              return Center(
                child: Text('Hello'),
              );

              return StatefulBuilder(
                builder: (context, setState) => Column(
                  children: [
                    // CustomTextField(_search, 'Busqueda...', hEdgeInset: 5,
                    //     onChanged: (value) {
                    //   setState(() {
                    //     print('Searching: "${_search.text}"');
                    //   });
                    // }),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: requests.length,
                        itemBuilder: (context, index) => Card(
                          elevation: 2.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          child: ListTile(
                            title: Row(
                              children: [
                                const Text('Solicitado: '),
                                Text(
                                  requests[index]["createdAt"]
                                      .toDate()
                                      .toString()
                                      .split(".")[0],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    const Text('Por: '),
                                    Text(
                                      requests[index]["createdAt"]
                                          .toDate()
                                          .toString()
                                          .split(".")[0],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                const Text(
                                  'Medicamentos Solicitados',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Table(
                                  border: TableBorder.all(),
                                  children: [
                                    // Headers
                                    const TableRow(
                                      children: [
                                        TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: Text('Nombre',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: Text('Lote',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: Text('Cantidad',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),

                                    // Filas de datos
                                    ...requests[index]['requestMeds']
                                        .map((med) {
                                      return TableRow(
                                        children: [
                                          TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: Text(
                                                "${med['genericName']}/${med['name']}",
                                                textAlign: TextAlign.center),
                                          ),
                                          TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: Text("${med['lote']}",
                                                textAlign: TextAlign.center),
                                          ),
                                          TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: Text(
                                                "Cantidad: ${med['quantity']}",
                                                textAlign: TextAlign.center),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                )
                              ],
                            ),
                          ),
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
