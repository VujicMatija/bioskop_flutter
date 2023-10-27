import 'package:bioskop/listViewProjekcije.dart';
import 'package:bioskop/projekcija.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Projekcije extends StatefulWidget {
  const Projekcije({super.key});
  @override
  State<StatefulWidget> createState() {
    return _ProjekijeState();
  }
}

class _ProjekijeState extends State<Projekcije> {
  List<String> datumi = [];
  List<Projekcija> projekcije = [];
  bool isLoaded = false;

  void getProjections() async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('projekcije').get().then(
      (value) {
        for (var proj in value.docs) {
          projekcije.add(Projekcija(
              datum: proj.data()['datum'],
              film: proj.data()['film'],
              vreme: proj.data()['vreme']));
        }
      },
    );
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    getProjections();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded == true
        ? ListViewProjekcije(projekcije: projekcije)
        : const CircularProgressIndicator();
  }
}
