import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medware/features/admin/inventory/Inventory.dart';
import 'package:medware/features/admin/inventory/presentation/inventory_add.dart';
import 'package:medware/features/home/HomeScreen.dart';
import 'package:medware/features/login/presentation/LoginPage.dart';
import 'package:medware/features/user/requests/presentation/Requests.dart';

final source = [
  // Base
  {
    'path': '/',
    'widget': const MainView(),
  },

  // User
  {
    'path': '/user/requests',
    'widget': const Requests(),
  },

  // Administrator
  {
    'path': '/admin/inventory',
    'widget': const AdminInventory(),
  },
  {
    'path': '/admin/orders',
    'widget': const Center(child: Text('Orders')),
  },
  {
    'path': '/admin/reports',
    'widget': const Center(child: Text('Reports')),
  },

  // Login Page
  {
    'path': '/login',
    'widget': const LoginPage(),
  },

  // Admin Utils
  {
    'path': '/admin/inventory/add',
    'widget': InventoryAdd(),
  },
];

List paths(isAdmin) {
  if (isAdmin) {
    return [source.elementAt(0), ...source.sublist(2, 5)];
  }

  return source.sublist(0, 1);
}

final routes = source
    .map(
      (e) => GoRoute(
        path: e['path'] as String,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: e['widget'] as Widget,
            transitionDuration: const Duration(milliseconds: 150),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.linearToEaseOut)
                    .animate(animation),
                child: child,
              );
            },
          );
        },
      ),
    )
    .toList();
