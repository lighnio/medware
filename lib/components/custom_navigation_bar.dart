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

  Widget build(BuildContext context) {
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
        items: 1 == 1 ? admin_nav_items : user_nav_items,
        onTap: (value) {
          setState(() => _currentIndex = value);
          context.go(paths(1 == 1)[_currentIndex]['path'] as String);
        },
        selectedFontSize: 20,
        selectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        unselectedFontSize: 14,
        unselectedItemColor: Colors.white.withOpacity(.60));
  }
}
