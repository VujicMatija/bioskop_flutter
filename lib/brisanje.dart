import 'package:flutter/material.dart';
import 'film.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BrisanjeFilmova extends StatefulWidget {
  const BrisanjeFilmova({super.key});
  @override
  State<StatefulWidget> createState() {
    return _BrisanjeFilmovaState();
  }
}

class _BrisanjeFilmovaState extends State<BrisanjeFilmova> {
  List<Movie> filmovi = [];
  bool isDataReady = false;
  Widget? lista;
  void getMovies() async {
    filmovi = [];
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('movies').get().then((snapshot) {
      for (var film in snapshot.docs) {
        Movie f = Movie(
            ime: film.data()['ime'],
            glumci: film.data()['glumci'],
            zanr: film.data()['zanr'],
            opis: film.data()['opis'],
            imageUrl: film.data()['slika'],
            dugacakOpis: film.data()['dugacakOpis']);
        // print(
        //     'FILM: ${f.ime} GLUMCI: ${f.glumci} ZANR: ${f.zanr} OPIS: ${f.opis} IMAGE: ${f.imageUrl}');
        filmovi.add(f);
      }
    });
    lista = ListView.builder(
      itemCount: filmovi.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Card(
            color: Colors.grey.shade100,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 10,
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 12,
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      filmovi[index].ime,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 4,
              ),
              Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('movies')
                                        .doc(filmovi[index].ime)
                                        .delete();
                                    FirebaseFirestore.instance
                                        .collection('projekcije')
                                        .get()
                                        .then(
                                      (value) {
                                        for (var doc in value.docs) {
                                          if (doc.id
                                              .contains(filmovi[index].ime)) {
                                            FirebaseFirestore.instance
                                                .collection('projekcije')
                                                .doc(doc.id)
                                                .delete();
                                          }
                                        }
                                      },
                                    );
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Film izbrisan')));
                                    setState(() {
                                      getMovies();
                                    });
                                  },
                                  child: const Text('OK'))
                            ],
                            content: Text(
                                'Da li ste sigurni da zelite da obrisete film ${filmovi[index].ime}?'),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.background,
                      )))
            ]),
          ),
        );
      },
    );
    setState(() {
      isDataReady = true;
    });
  }

  @override
  void initState() {
    getMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isDataReady == true) Expanded(child: SizedBox(child: lista!))
      ],
    );
  }
}
