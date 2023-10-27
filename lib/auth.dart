// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final auth = FirebaseAuth.instance;
final storage = FirebaseStorage.instance;
final db = FirebaseFirestore.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLogin = false;
  bool isSignUp = true;
  String _email = '';
  String _password = '';
  String _username = '';
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();

  void submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    try {
      if (isSignUp) {
        final userCredential = await auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Napravljen nalog')));
        }
        db.collection('user').doc(userCredential.user!.uid).set({
          'username': _username,
          'email': _email,
          'administrator': false,
        });
      } else {
        final userCredential = await auth.signInWithEmailAndPassword(
            email: _email, password: _password);
      }
      controller1.clear();
      controller2.clear();
      controller3.clear();
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? 'Auth failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              const Padding(
                padding: EdgeInsets.all(12),
                child: Image(
                  image: AssetImage('lib\\images\\kokice.png'),
                  width: 256,
                  height: 256,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22)),
                  shadowColor: Colors.red.shade300,
                  elevation: 10,
                  color: Theme.of(context).colorScheme.onBackground,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              if (isSignUp)
                                TextFormField(
                                  controller: controller1,
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty ||
                                        value.trim().length <= 3) {
                                      return 'Korisnicko ime mora biti dugacko barem 3 karaktera';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Korisnicko ime',
                                  ),
                                  onSaved: (newValue) {
                                    setState(() {
                                      if (newValue == null) {
                                        return;
                                      }
                                      _username = newValue;
                                    });
                                  },
                                ),
                              TextFormField(
                                controller: controller2,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      !value.contains('@')) {
                                    return 'Unesite pravilnu email adresu';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Email adresa',
                                ),
                                onSaved: (newValue) {
                                  setState(() {
                                    if (newValue == null) {
                                      return;
                                    }
                                    _email = newValue;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: controller3,
                                obscureText: true,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 6 ||
                                      value.trim().isEmpty) {
                                    return 'Sifra mora da ima najmanje 6 karaktera';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Lozinka',
                                ),
                                onSaved: (newValue) {
                                  if (newValue == null) {
                                    return;
                                  }
                                  _password = newValue;
                                  newValue = '';
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: submit,
                          child: Text(isLogin ? 'Prijava' : 'Registracija')),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              if (isLogin) {
                                isSignUp = true;
                                isLogin = false;
                              } else if (isSignUp) {
                                isLogin = true;
                                isSignUp = false;
                              }
                            });
                          },
                          child: isLogin
                              ? const Text('Nemate nalog? Registracija')
                              : const Text('Vec imam nalog! Prijava'))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
