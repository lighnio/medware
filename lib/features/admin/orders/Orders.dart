import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medware/components/custom_buttton.dart';

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
                  tempOrders.where((med) => med['isEnded'] == false).toList();

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

              if (orders.isEmpty) {
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
                                )
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomButton(
                                      'Aceptar',
                                      () async {
                                        var db_usReqs = FirebaseFirestore
                                            .instance
                                            .collection('requests')
                                            .doc(orders[index]['owner']);

                                        var usReqs = await db_usReqs.get();

                                        List rawReqs =
                                            usReqs.data()?['requests'] ?? [];

                                        int gLIndex = rawReqs.indexWhere(
                                          (element) =>
                                              element['createdAt'].toDate() ==
                                              orders[index]['createdAt']
                                                  .toDate(),
                                        );
                                        // print(rawReqs);

                                        rawReqs[gLIndex]['isEnded'] = true;
                                        rawReqs[gLIndex]['status'] = 'Aceptado';
                                        rawReqs[gLIndex]['endedAt'] =
                                            DateTime.now();

                                        rawReqs[gLIndex]['requestMeds']
                                            .forEach((med) async {
                                          await FirebaseFirestore.instance
                                              .collection('meds')
                                              .doc(med['id'])
                                              .update({
                                            'stockPerUnit':
                                                FieldValue.increment(
                                                    -med['quantity'])
                                          });
                                        });

                                        await db_usReqs
                                            .update({'requests': rawReqs});
                                      },
                                      color: Colors.green,
                                      padding: 10,
                                    ),
                                    CustomButton(
                                      'Rechazar',
                                      () async {
                                        var db_usReqs = FirebaseFirestore
                                            .instance
                                            .collection('requests')
                                            .doc(orders[index]['owner']);

                                        var usReqs = await db_usReqs.get();

                                        List rawReqs =
                                            usReqs.data()?['requests'] ?? [];

                                        int gLIndex = rawReqs.indexWhere(
                                          (element) =>
                                              element['createdAt'].toDate() ==
                                              orders[index]['createdAt']
                                                  .toDate(),
                                        );
                                        // print(rawReqs);

                                        rawReqs[gLIndex]['isEnded'] = true;
                                        rawReqs[gLIndex]['status'] = 'Denegado';
                                        rawReqs[gLIndex]['endedAt'] =
                                            DateTime.now();

                                        await db_usReqs
                                            .update({'requests': rawReqs});
                                      },
                                      color: Colors.red,
                                      padding: 10,
                                    ),
                                  ],
                                ),
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
