import 'package:bioskop/film.dart';
import 'package:flutter/material.dart';

const String apiKey = 'ff4f7adcdc0b9c9a75c487c6656b3d65';

class MovieInfo extends StatelessWidget {
  const MovieInfo({super.key, required this.film});
  final Movie film;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3 * 1.4,
                  height: MediaQuery.of(context).size.height / 4 * 1.5,
                  child: Image.network(
                    film.imageUrl,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width -
                      MediaQuery.of(context).size.width / 3 * 1.4,
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        film.ime,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 16, 0, 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Zanr: ${film.zanr}',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 16, 0, 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Glumci: ${film.glumci}',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                color: Theme.of(context).cardColor,
                shadowColor: Colors.amber,
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(film.dugacakOpis,
                      style: TextStyle(
                        fontSize: 20,
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
