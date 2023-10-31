import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medware/components/custom_buttton.dart';
import 'package:medware/components/custom_textfield.dart';

class RequestsAdd extends StatefulWidget {
  const RequestsAdd({super.key});

  @override
  State<RequestsAdd> createState() => _RequestsAddState();
}

class _RequestsAddState extends State<RequestsAdd> {
  TextEditingController _search = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map medList = {};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: Drawer(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text(
                  'Medicamentos Solicitados',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                const SizedBox(height: 25),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 15),
                    child: ListView.builder(
                        itemCount: medList.length,
                        itemBuilder: (context, index) {
                          List medsKeys =
                              medList.entries.map((e) => e.key).toList();

                          if (medList[medsKeys[index]]['quantity'] == null) {
                            medList[medsKeys[index]]['quantity'] = 1;
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 75,
                                      height: 75,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                            'https://source.unsplash.com/random',
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }, fit: BoxFit.cover),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Text(medList[medsKeys[index]]['name'])
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        if (medList[medsKeys[index]]
                                                ['quantity'] >
                                            1) {
                                          setState(() {
                                            medList[medsKeys[index]]
                                                ['quantity']--;
                                          });
                                        } else {
                                          setState(() {
                                            medList.remove(medsKeys[index]);
                                          });
                                        }
                                      },
                                    ),
                                    Text(
                                        '${medList[medsKeys[index]]["quantity"]}',
                                        style: TextStyle(fontSize: 18)),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          medList[medsKeys[index]]
                                              ['quantity']++;
                                        });
                                      },
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                ),
                CustomButton('Solicitar', () async {
                  if (medList.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'No pueden haber solicitudes sin medicamentos...'),
                      ),
                    );
                  } else {
                    List finalMeds = medList.entries.map((e) {
                      return {
                        'genericName': e.value['genericName'],
                        'id': e.value['id'],
                        'lote': e.value['loteNumber'],
                        'name': e.value['name'],
                        'quantity': e.value['quantity'],
                      };
                    }).toList();

                    Map<String, dynamic> completeObject = {
                      'requestMeds': finalMeds,
                      'createdAt': DateTime.now(),
                      'isEnded': false,
                      'status': 'Pendiente'
                    };

                    await FirebaseFirestore.instance
                        .collection('requests')
                        .doc(FirebaseAuth.instance.currentUser?.email)
                        .update({
                      'requests': FieldValue.arrayUnion([completeObject])
                    });

                    setState(() {
                      medList.clear();
                      context.pop();
                    });
                  }
                })
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: Text('Solicitar'),
          centerTitle: true,
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _search.clear();
                });
                _scaffoldKey.currentState?.openEndDrawer();
              },
              child: Icon(Icons.shopping_bag, color: Colors.grey[200]),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(const CircleBorder()),
                padding: MaterialStateProperty.all(const EdgeInsets.all(8)),
                backgroundColor: MaterialStateProperty.all(
                    Colors.deepPurpleAccent), // <-- Button color
                overlayColor:
                    MaterialStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.red; // <-- Splash color
                  }
                  return null;
                }),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('meds')
                .where('stockPerUnit', isGreaterThanOrEqualTo: 10)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                    child: Text(
                        'Parece que no hay disponibilidad de medicamentos...'));
              }
              List items = snapshot.data!.docs
                  .map((med) => {...med.data(), 'id': med.id})
                  .toList();

              return StatefulBuilder(
                builder: (local_context, setState) => Column(
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
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            if (medList[items[index]['id']] == null) {
                              medList[items[index]['id']] = items[index];
                            }
                          },
                          child: Container(
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
                                      return Center(
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
                                        'Precio: Q${items[index]['unitaryPrice']}'),
                                    Text(
                                        'Expiracion: ${items[0]['expireDate'].toDate().toString().split(" ")[0]}'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
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
