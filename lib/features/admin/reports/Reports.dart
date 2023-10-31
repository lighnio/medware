import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
          title: Text(
            'Solicitudes Procesadas', // overflow: TextOverflow.ellipsis,
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
              var tempOrders = snapshot.data?.docs
                      .map((req) {
                        var temp = req
                            .data()['requests']
                            .map((elem) => {'owner': req.id, ...elem})
                            .toList();

                        return temp;
                      })
                      .toList()
                      .expand((sublist) => sublist)
                      .toList() ??
                  [];

              var orders =
                  tempOrders.where((med) => med['isEnded'] == true).toList();

              orders.sort((a, b) {
                final comparacionPorOwner = a['owner'].compareTo(b['owner']);
                if (comparacionPorOwner != 0) {
                  return comparacionPorOwner;
                } else {
                  final fechaA = a['createdAt'].toDate();
                  final fechaB = b['createdAt'].toDate();
                  return fechaA.compareTo(fechaB);
                }
              });

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
                            title: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text('Creacion: '),
                                    Text(
                                      orders[index]["createdAt"]
                                          .toDate()
                                          .toString()
                                          .split(".")[0],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Solicitado por: '),
                                    Text(
                                      orders[index]["owner"].split('@')[0],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Procesado: '),
                                    Text(
                                      orders[index]["endedAt"]
                                          .toDate()
                                          .toString()
                                          .split(".")[0],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Estado Final: '),
                                    Text(
                                      orders[index]["status"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: orders[index]["status"] ==
                                                  'Aceptado'
                                              ? Colors.green
                                              : Colors.red),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
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

                                    ...orders[index]['requestMeds'].map((med) {
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
                                ),
                                const SizedBox(height: 25),
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
