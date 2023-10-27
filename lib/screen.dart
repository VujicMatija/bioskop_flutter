// ignore_for_file: unused_local_variable

import 'package:bioskop/brisanje.dart';
import 'package:bioskop/dodavanjeProekcija.dart';
import 'package:bioskop/reperotar.dart';
import 'package:bioskop/projekcije.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'add.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ScreenState();
  }
}

class _ScreenState extends State<Screen> {
  Widget content = const Repertoar();
  bool isAdministrator = false;
  void administratorCheck() {
    final docRef = FirebaseFirestore.instance
        .collection('user')
        .where('administrator', isEqualTo: true)
        .get()
        .then((snapshot) {
      for (var docSnapshot in snapshot.docs) {
        if (docSnapshot.data()['email'].toString() ==
            FirebaseAuth.instance.currentUser!.email.toString()) {
          setState(() {
            isAdministrator = true;
          });
        }
      }
    });
  }

  @override
  void initState() {
    administratorCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.exit_to_app_outlined))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Repertoar'),
              onTap: () {
                setState(() {
                  content = const Repertoar();
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Projekcije'),
              onTap: () {
                setState(() {
                  content = const Projekcije();
                });
                Navigator.of(context).pop();
              },
            ),
            if (isAdministrator)
              ListTile(
                title: const Text('Dodaj film'),
                onTap: () {
                  setState(() {
                    content = const Add();
                  });
                  Navigator.of(context).pop();
                },
              ),
            if (isAdministrator)
              ListTile(
                title: const Text('Dodaj projekcije'),
                onTap: () {
                  setState(() {
                    content = const DodavanjeProjekcija();
                  });
                  Navigator.of(context).pop();
                },
              ),
            if (isAdministrator)
              ListTile(
                title: const Text('Izbrisi film'),
                onTap: () {
                  setState(() {
                    content = const BrisanjeFilmova();
                  });
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
      body: content,
    );
  }
}
