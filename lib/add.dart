import 'package:bioskop/film.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Add extends StatefulWidget {
  const Add({super.key});
  @override
  State<Add> createState() {
    return _AddState();
  }
}

class _AddState extends State<Add> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final TextEditingController _movieNameController = TextEditingController();
  final TextEditingController _movieActorsController = TextEditingController();
  final TextEditingController _movieDescriptionController =
      TextEditingController();
  final TextEditingController _movieLongDescriptcionController =
      TextEditingController();

  File? _selectedImage;
  String zanr = 'Romansa';
  Movie? film;

  @override
  void dispose() {
    _movieNameController.dispose();
    super.dispose();
  }

  void selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: MediaQuery.of(context).size.width / 3,
        maxHeight: MediaQuery.of(context).size.height / 4,
        imageQuality: 100);
    if (image == null) {
      return;
    }
    setState(() {
      _selectedImage = File(image.path);
    });
  }

  void addMovie() async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('${_movieNameController.text}.jpg');
      await storageRef.putFile(_selectedImage!);
      final imageUrl = await storageRef.getDownloadURL();
      film = Movie(
        ime: _movieNameController.text,
        glumci: _movieActorsController.text,
        zanr: zanr,
        opis: _movieDescriptionController.text,
        imageUrl: imageUrl,
        dugacakOpis: '',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      try {
        await FirebaseFirestore.instance
            .collection('movies')
            .doc(film!.ime)
            .set({
          'ime': film!.ime,
          'glumci': film!.glumci,
          'opis': film!.opis,
          'zanr': film!.zanr,
          'slika': film!.imageUrl,
          'dugacakOpis': film!.dugacakOpis,
        });
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Firestore ${e.toString()}')));
      } finally {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Film dodat'),
        ));
        _movieActorsController.clear();
        _movieDescriptionController.clear();
        _movieNameController.clear();
        setState(() {
          _selectedImage = null;
        });
      }
    }
    // try {
    //   final storageRef = FirebaseStorage.instance
    //       .ref()
    //       .child('images')
    //       .child('${_movieNameController.text}.jpg');
    //   await storageRef.putFile(_selectedImage!);
    //   final imageUrl = await storageRef.getDownloadURL();
    //   final Movie film = Movie(
    //       ime: _movieNameController.text,
    //       glumci: _movieActorsController.text,
    //       zanr: zanr,
    //       opis: _movieDescriptionController.text,
    //       imageUrl: imageUrl);
    //   await FirebaseFirestore.instance
    //       .collection('movies')
    //       .doc('${film.ime}')
    //       .set({
    //     'ime': film.ime,
    //     'glumci': film.glumci,
    //     'opis': film.opis,
    //     'zanr': film.zanr,
    //     'slika': film.imageUrl
    //   });
    // } catch (e) {
    //   ScaffoldMessenger.of(context).clearSnackBars();
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(SnackBar(content: Text(e.toString())));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      controller: _movieNameController,
                      decoration: const InputDecoration(
                          labelText: 'Ime filma', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                      onPressed: selectImage,
                      child: const Text('Select image')),
                ),
                const SizedBox(
                  width: 64,
                ),
                if (_selectedImage == null)
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Colors.red.shade900,
                      width: 1,
                    )),
                    child: const Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('Mesto za sliku'),
                    ),
                  ),
                if (_selectedImage != null)
                  CircleAvatar(
                    maxRadius: 64,
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
              ],
            ),
          ),
          Form(
            key: _formKey2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _movieDescriptionController,
                    decoration: const InputDecoration(
                        labelText: 'Kratak opis filma',
                        border: OutlineInputBorder()),
                    maxLength: 200,
                    keyboardType: TextInputType.text,
                    minLines: 1,
                    maxLines: 5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _movieLongDescriptcionController,
                    decoration: const InputDecoration(
                        labelText: 'Opis filma', border: OutlineInputBorder()),
                    maxLength: 1000,
                    keyboardType: TextInputType.text,
                    minLines: 1,
                    maxLines: 15,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _movieActorsController,
                    decoration: const InputDecoration(
                        labelText: 'Glumci', border: OutlineInputBorder()),
                    maxLength: 200,
                    keyboardType: TextInputType.text,
                    minLines: 1,
                    maxLines: 5,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: DropdownButton<String>(
                        value: zanr,
                        underline: Container(
                          height: 2,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        items: const [
                          DropdownMenuItem<String>(
                              value: 'Romansa', child: Text('Romansa')),
                          DropdownMenuItem<String>(
                              value: 'Horor', child: Text('Horor')),
                          DropdownMenuItem<String>(
                              value: 'Crtani', child: Text('Crtani')),
                          DropdownMenuItem<String>(
                              value: 'Triler', child: Text('Triler')),
                        ],
                        onChanged: (String? value) {
                          setState(() {
                            zanr = value!;
                          });
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          SizedBox(
            height: 50,
            width: 100,
            child: ElevatedButton(
              onPressed: addMovie,
              child: const Icon(Icons.send),
            ),
          ),
        ],
      ),
    );
  }
}
