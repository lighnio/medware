import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Center(
                child:
                    Text('Hola, ${FirebaseAuth.instance.currentUser?.email}')),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Inicio'),
            onTap: () {
              context.pop();
              context.go('/');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configuración'),
            onTap: () {
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Opcion no disponible aun.'),
                ),
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            leading: Icon(Icons.logout_outlined),
            title: Text('Cerrar Sesion'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              context.replace('/login');
            },
          ),
        ],
      ),
    );
  }
}
