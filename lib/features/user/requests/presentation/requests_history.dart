import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RequestsHistory extends StatefulWidget {
  const RequestsHistory({super.key});

  @override
  State<RequestsHistory> createState() => _RequestsHistoryState();
}

class _RequestsHistoryState extends State<RequestsHistory> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Solicitudes Finalizadas',
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.push('/user/requests/history');
              },
              icon: const Icon(
                Icons.history,
                size: 35,
              ),
            ),
          ],
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
                .collection('requests')
                .doc(FirebaseAuth.instance.currentUser?.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: Text(
                    'Parece que aun no hay un registro...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.bold),
                  ),
                );
              }

              List requests = snapshot.data
                      ?.data()?['requests']
                      .where((med) => med['isEnded'] == true)
                      .toList() ??
                  [];

              if (requests.isEmpty) {
                return const Center(
                  child: Text(
                    'Parece que aun no hay un registro...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.bold),
                  ),
                );
              }

              requests.sort((a, b) {
                final DateTime dateTimeA = a['createdAt'].toDate();
                final DateTime dateTimeB = b['createdAt'].toDate();
                return dateTimeA.compareTo(dateTimeB);
              });

              return StatefulBuilder(
                builder: (context, setState) => Column(
                  children: [
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
                                const SizedBox(height: 15),
                                Text(
                                  requests[index]["status"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: requests[index]["status"] ==
                                              'Aceptado'
                                          ? Colors.green
                                          : Colors.red),
                                ),
                                const SizedBox(height: 15),
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
