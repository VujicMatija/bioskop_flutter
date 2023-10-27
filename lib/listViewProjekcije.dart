import 'package:flutter/material.dart';

import 'projekcija.dart';

class ListViewProjekcije extends StatefulWidget {
  ListViewProjekcije(
      {super.key, required this.projekcije, this.isAdmin = false});
  List<Projekcija> projekcije;
  bool isAdmin = false;

  @override
  State<ListViewProjekcije> createState() => _ListViewProjekcijeState();
}

class _ListViewProjekcijeState extends State<ListViewProjekcije> {
  double counter = 1;
  int getPrice(Projekcija proj) {
    int sat = int.parse(proj.vreme.substring(0, 2));
    if (sat >= 11 && sat <= 15) return 300;
    if (sat >= 15 && sat <= 18) return 400;
    if (sat >= 18 && sat <= 23) return 500;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.projekcije.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Card(
            elevation: 10,
            color: Colors.grey.shade100,
            child: Row(children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2.6,
                  height: MediaQuery.of(context).size.height / 10,
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.projekcije[index].film,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  )),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2.6,
                  height: MediaQuery.of(context).size.height / 10,
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: Column(
                          children: [
                            Text(
                              widget.projekcije[index].datum,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              widget.projekcije[index].vreme,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        )),
                  )),
              Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Text(
                    '${getPrice(widget.projekcije[index]).toString()} RSD'),
              )
            ]),
          ),
        );
      },
    );
  }
}
