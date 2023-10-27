import 'package:bioskop/auth.dart';
import 'package:bioskop/loading.dart';
import 'package:bioskop/screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
        ),
        textTheme: GoogleFonts.quicksandTextTheme(),
      ),
      title: 'Bioskop',
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Screen();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
