import 'package:bioskop/listViewProjekcije.dart';
import 'package:bioskop/projekcija.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;

class DodavanjeProjekcija extends StatefulWidget {
  const DodavanjeProjekcija({super.key});
  @override
  State<DodavanjeProjekcija> createState() {
    return _DodavanjeProjekcijaState();
  }
}

class _DodavanjeProjekcijaState extends State<DodavanjeProjekcija> {
  TextEditingController dateController = TextEditingController();

  DateTime? pickedDate;
  List<String> filmovi = [];
  List<DropdownMenuItem<String>>? items;
  bool isLoaded = false;
  String filmValue = '';
  String currentOption = '';
  TimeOfDay? pickedTime;
  List<Projekcija> projekcije = [];
  bool isProjectionsLoaded = false;

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
      isProjectionsLoaded = true;
    });
  }

  void getMovies() async {
    await firestore.collection('movies').get().then(
      (value) {
        for (var f in value.docs) {
          filmovi.add(f.data()['ime']);
        }

        setState(() {
          isLoaded = true;
          currentOption = filmovi[0];
        });
      },
    );
  }

  void AddProjection() async {
    if (pickedTime == null || pickedDate == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'))
        ], content: const Text('Datum i vreme moraju biti izabrani')),
      );
      return;
    }
    Projekcija p = Projekcija(
        datum: dateController.text,
        film: currentOption,
        vreme: pickedTime!.minute < 10
            ? '${pickedTime!.hour}:0${pickedTime!.minute}'
            : '${pickedTime!.hour}:${pickedTime!.minute}');
    try {
      ;
      await firestore
          .collection('projekcije')
          .doc('${p.datum}${p.film}')
          .set({'film': p.film, 'datum': p.datum, 'vreme': p.vreme});
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Projekcija dodata')));
    }
  }

  @override
  void initState() {
    getProjections();
    getMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
                child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: dateController,
                  readOnly: true,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      hintText: 'Uneti datum',
                      border: const OutlineInputBorder(),
                      iconColor: Theme.of(context).colorScheme.primary,
                      icon: const Icon(
                        Icons.calendar_month,
                        size: 35,
                      )),
                  onTap: () async {
                    pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101));
                    setState(() {
                      pickedDate == null
                          ? dateController.text = 'Uneti datum'
                          : dateController.text =
                              DateFormat('dd-MM-yyyy').format(pickedDate!);
                    });
                  },
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 10, 10, 10),
                    child: ElevatedButton(
                        onPressed: () async {
                          final TimeOfDay? timeOfDay = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              initialEntryMode: TimePickerEntryMode.input);
                          if (timeOfDay != null) {
                            setState(() {
                              pickedTime = timeOfDay;
                            });
                          }
                        },
                        child: const Text('Izaberite vreme projekcije')),
                  ),
                  if (pickedTime == null)
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Izaberite vreme',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  if (pickedTime != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 45.0),
                      child: Text(
                        pickedTime!.minute < 10
                            ? '${pickedTime!.hour}: 0${pickedTime!.minute}'
                            : '${pickedTime!.hour}: ${pickedTime!.minute}',
                        style: TextStyle(fontSize: 24),
                      ),
                    )
                ],
              ),
              if (isLoaded)
                for (var f in filmovi)
                  RadioListTile(
                    title: Text(f.toString()),
                    value: f,
                    groupValue: currentOption,
                    onChanged: (value) {
                      setState(() {
                        currentOption = value.toString();
                      });
                    },
                  )
            ])),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                  onPressed: AddProjection,
                  child: const Text('Dodajte projeckiju')),
            ),
          ],
        ),
      ),
    );
  }
}
