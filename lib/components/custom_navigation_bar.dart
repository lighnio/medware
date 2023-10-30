import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medware/routes.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar(context, {super.key});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int _currentIndex = 0;
  bool admin = false;

  Future verifyAdmin() async {
    var user = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.email)
        .get();

    setState(() {
      admin = user.data()?['isAdmin'] ?? false;
    });
  }

  Widget build(BuildContext context) {
    double txtFactor = MediaQuery.of(context).textScaleFactor;
    verifyAdmin();

    const List<BottomNavigationBarItem> general_items = [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
    ];

    const List<BottomNavigationBarItem> admin_nav_items = [
      ...general_items,
      BottomNavigationBarItem(
          icon: Icon(Icons.medication), label: 'Inventario'),
      BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Pedidos'),
      BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reportes'),
    ];

    const List<BottomNavigationBarItem> user_nav_items = [
      ...general_items,
      BottomNavigationBarItem(
        icon: Icon(Icons.assignment_add),
        label: 'Pedidos',
      ),
    ];

    return BottomNavigationBar(
        backgroundColor: Colors.deepPurple,
        currentIndex: _currentIndex,
        items: admin ? admin_nav_items : user_nav_items,
        onTap: (value) {
          setState(() => _currentIndex = value);
          context.go(paths(admin)[_currentIndex]['path'] as String);
        },
        selectedFontSize: (15 * txtFactor),
        selectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        unselectedFontSize: 13 * txtFactor,
        unselectedItemColor: Colors.white.withOpacity(.60));
  }
}
