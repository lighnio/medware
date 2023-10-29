import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medware/components/custom_navigation_bar.dart';
import 'package:medware/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      routerConfig: GoRouter(
        initialLocation: '/',
        routes: [
          ShellRoute(
              routes: routes,
              builder: (context, state, child) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      'MedWare',
                      style: TextStyle(
                          fontSize: 25 * MediaQuery.of(context).textScaleFactor,
                          fontFamily: 'Times New Roman',
                          fontWeight: FontWeight.w800),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.abc),
                      ),
                    ],
                    centerTitle: true,
                  ),
                  body: child,
                  bottomNavigationBar: CustomNavigationBar(context),
                );
              }),
        ],
      ),
    );
  }
}
