import 'package:bioskop/film.dart';
import 'package:bioskop/movieInfo.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Repertoar extends StatefulWidget {
  const Repertoar({super.key});
  @override
  State<Repertoar> createState() {
    return RepertoarState();
  }
}

class RepertoarState extends State<Repertoar> {
  List<Movie> filmovi = [];
  bool isDataReady = false;
  // bool filter = true;
  // bool romansa = false;
  // bool horor = false;
  // bool crtani = false;
  // bool triler = false;
  String? zanr;
  List<bool> zanrovi = [false, false, false, false, false];
  Widget? rep;
  void getMovies() async {
    filmovi = [];
    if (zanr == null) {
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
      setState(() {
        isDataReady = true;
      });
    } else {
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
          if (f.zanr == zanr) {
            filmovi.add(f);
          }
        }
      });
      setState(() {
        isDataReady = true;
      });
    }
    rep = Expanded(
      child: SizedBox(
        child: ListView.builder(
          itemCount: filmovi.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MovieInfo(film: filmovi[index]),
                ));
              },
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey.shade700, width: 0.2)),
                    child: Row(
                      children: [
                        Container(
                          child: Image.network(filmovi[index].imageUrl),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(filmovi[index].ime,
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      filmovi[index].opis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    getMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = isDataReady == false
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: ToggleButtons(
                  isSelected: zanrovi,
                  onPressed: (int index) {
                    setState(() {
                      switch (index) {
                        case 0:
                          zanr = null;
                        case 1:
                          zanr = 'Romansa';
                        case 2:
                          zanr = 'Horor';
                        case 3:
                          zanr = 'Crtani';
                        case 4:
                          zanr = 'Triler';
                      }
                      zanrovi = [false, false, false, false, false];
                      zanrovi[index] = !zanrovi[index];
                      getMovies();
                    });
                  },
                  children: const [
                    Icon(Icons.close),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Romansa',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Horor', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Crtani', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Triler', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
              rep!,
            ],
          );

    return content;
  }
}
