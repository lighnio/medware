import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medware/features/home/presentation/HomeScreen.dart';
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
    'widget': const Center(child: Text('Inventory')),
  },
  {
    'path': '/admin/orders',
    'widget': const Center(child: Text('Orders')),
  },
  {
    'path': '/admin/reports',
    'widget': const Center(child: Text('Reports')),
  },
];

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
