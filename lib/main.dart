import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medware/components/custom_drawer.dart';
import 'package:medware/components/custom_navigation_bar.dart';
import 'package:medware/features/login/presentation/LoginPage.dart';
import 'package:medware/firebase_options.dart';
import 'package:medware/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      routerConfig: GoRouter(
        initialLocation: '/',
        routes: [
          ShellRoute(
              routes: routes,
              builder: (context, state, child) {
                if (FirebaseAuth.instance.currentUser == null) {
                  return Scaffold(
                    body: LoginPage(),
                  );
                }

                return Scaffold(
                  key: _scaffoldKey,
                  drawer: const CustomDrawer(),
                  appBar: AppBar(
                    title: Text(
                      'MedWare',
                      style: TextStyle(
                          fontSize: 25 * MediaQuery.of(context).textScaleFactor,
                          fontFamily: 'Times New Roman',
                          fontWeight: FontWeight.w800),
                    ),
                    leading: IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      icon: const Icon(Icons.menu),
                    ),
                    actions: [],
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
