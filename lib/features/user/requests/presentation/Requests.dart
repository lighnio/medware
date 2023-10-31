import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:medware/components/custom_textfield.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  TextEditingController _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.email)
                .collection('requests')
                .snapshots(),
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
              var requests = snapshot.data!.docs.map((req) => req.data());

              return StatefulBuilder(
                builder: (context, setState) => Column(
                  children: [
                    CustomTextField(_search, 'Busqueda...', hEdgeInset: 5,
                        onChanged: (value) {
                      setState(() {
                        print('Searching: "${_search.text}"');
                      });
                    }),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: requests.length,
                        itemBuilder: (context, index) => Container(
                          child: Text('Elemento $index'),
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
