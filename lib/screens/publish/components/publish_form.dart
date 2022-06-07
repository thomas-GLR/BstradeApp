import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:image_picker/image_picker.dart';

import 'package:bstrade/models/person.dart';
import 'package:bstrade/services/storage_service.dart';
import 'package:bstrade/services/database.dart';

class PublishForm extends StatefulWidget {
  PublishForm({Key key}) : super(key: key);

  @override
  _PublishFormState createState() => _PublishFormState();
}

class _PublishFormState extends State<PublishForm> {
  File _imageFile;

  final _fromKey = GlobalKey<FormState>();

  // controller necessaire pour les champ récupérant du texte
  final TextEditingController _controllerTitle = new TextEditingController();
  final TextEditingController _controllerState = new TextEditingController();
  final TextEditingController _controllerCategory = new TextEditingController();
  final TextEditingController _controllerPrice = new TextEditingController();
  final TextEditingController _controllerDescription = new TextEditingController();
  final TextEditingController _controllerPriceCVE = new TextEditingController();
  final TextEditingController _controllerContactUtilisateur = new TextEditingController();

  // Variable permettant de stocker temporairement les valeurs remplis par l'utilisateur avant de les envoyer dans la base de données
  String titreProduit = '';
  String prixProduit = '';
  String montantDonCVE = '';
  String descriptionProduit = '';
  String etatProduit = '';
  String categorieProduit = '';
  String contactUtilisateur = '';
  String erreur = '';

  // Permet d'autoriser l'utilisation de la galerie ou de la camera
  bool autoriserAccesCameraOuGalerie = false;

  final CollectionReference collectionDeProduit = FirebaseFirestore.instance.collection('products');

  final List<Map<String, dynamic>> _categories = [
    {
      'value': 'Livre',
      'label': 'Livres',
      //'icon': Icon(Icons.library_books),
    },
    {
      'value': 'Vetement',
      'label': 'Vetements',
      //'icon': Icon(Icons.fiber_manual_record),
      //'textStyle': TextStyle(color: Colors.green),
    },
    {
      'value': 'Informatique',
      'label': 'Informatique',
      //'enable': false,
      //'icon': Icon(Icons.grade),
    },
    {
      'value': 'Services',
      'label': 'Services',
      //'icon': Icon(Icons.grade),
    },
    {
      'value': 'Autres',
      'label': 'Autres',
      //'icon': Icon(Icons.grade),
    },
  ];

  final List<Map<String, dynamic>> _state = [
    {
      'value': 'Etat Neuf',
      'label': 'Neuf',
      //'icon': Icon(Icons.stop),
    },
    {
      'value': 'Très bon état',
      'label': 'Très bon état',
      //'icon': Icon(Icons.fiber_manual_record),
    },
    {
      'value': 'Bon état',
      'label': 'Bon état',
      //'icon': Icon(Icons.grade),
    },
    {
      'value': 'Satisfaisant',
      'label': 'Satisfaisant',
      //'icon': Icon(Icons.grade),
    },
  ];
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Person>(context);
    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _fromKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              ButtonTheme(
                minWidth: 190,
                height: 56,
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: RaisedButton(
                  onPressed: () async {
                    _AffichePopUpAutorisation();
                  }, // onPressed
                  child: SizedBox(
                    width: 150,
                    child: AspectRatio(
                      aspectRatio: 1,
                      //child: Image.file(_imageFile),
                      child: Icon(
                        Icons.add_photo_alternate_outlined,
                        color: Colors.white,
                        size: 150,
                      ),
                    ),
                  ),
                  color: Colors.grey[200],
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                  controller: _controllerTitle,
                  decoration: new InputDecoration(
                    labelText: "Titre *",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (val) => val.isEmpty ? 'Saisir un titre' : null,
                  onChanged: (val) {
                    setState(() => titreProduit = val);
                  }), // TextFormField
              SizedBox(height: 20.0),
              SelectFormField(
                  controller: _controllerCategory,
                  type: SelectFormFieldType.dialog, // or can be dialog
                  labelText: 'Categorie *',
                  items: _categories,
                  validator: (val) => val.isEmpty ? 'Saisir une catégorie' : null,
                  onChanged: (val) {
                    setState(() => categorieProduit = val);
                  }), // TextFormField
              SizedBox(height: 20.0),
              SelectFormField(
                  controller: _controllerState,
                  type: SelectFormFieldType.dialog, // or can be dialog
                  labelText: 'Etat',
                  items: _state,
                  enabled: categorieProduit == 'Services' ? false : true,
                  //validator: (val) => val.isEmpty ? 'Saisir un état' : null,
                  onChanged: (val) {
                    setState(() => etatProduit = val);
                  }),
              SizedBox(height: 20.0),
              TextFormField(
                  controller: _controllerPrice,
                  decoration: new InputDecoration(
                    labelText: "Prix *",
                    //fillColor: Colors.white,
                    border: UnderlineInputBorder(),
                    //fillColor: Colors.green
                  ),
                  keyboardType: TextInputType.number,
                  validator: (val) => val.isEmpty ? 'Saisir un prix' : null,
                  onChanged: (val) {
                    setState(() => prixProduit = val);
                  }),
              SizedBox(height: 20.0),
              TextFormField(
                  controller: _controllerDescription,
                  decoration: new InputDecoration(
                    labelText: "Description",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.all(Radius.circular(10)),
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (val) {
                    setState(() => descriptionProduit = val);
                  }),
              SizedBox(height: 20.0),
              TextFormField(
                  controller: _controllerContactUtilisateur,
                  decoration: new InputDecoration(
                    labelText: "Informations de contact *",
                    border: UnderlineInputBorder(),
                  ),
                  keyboardType: TextInputType.multiline,
                  validator: (val) => val.isEmpty ? 'Veuillez Saisir un ou plusieurs moyen de contact' : null,
                  onChanged: (val) {
                    setState(() => contactUtilisateur = val);
                  }),
              Text(''),
              SizedBox(height: 20.0),
              SizedBox(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text(
                              "Donner au CVE",
                              style: TextStyle(
                                fontSize: 20,
                              ), // TextStyle
                            ), // Text
                          ), // Container
                        ),
                        Spacer(),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            padding: EdgeInsets.only(right: 30.0),
                            icon: const Icon(
                              Icons.info_outline,
                              color: Colors.black,
                              size: 30.0,
                            ), // Icon
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Qu\'est ce que le CVE'),
                                content: const Text('Le Conseil de Vie Étudiante est composé d\'élèves et formateurs qui organisent diverses animations et évènements afin d\'apporter un peu de divertissement dans la vie étudiante. En reversant une part de votre recette au CVE, vous encourager et contribuez à la vie du campus et offrez la possibilité de concrétiser divers projets.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            ),
                          ), // IconButton
                        ),
                      ],
                    ), // Align
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Icon(
                          Icons.volunteer_activism,
                          color: Colors.green[300],
                          size: 30.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                        controller: _controllerPriceCVE,
                        decoration: new InputDecoration(
                          labelText: "Montant",
                          //fillColor: Colors.white,
                          border: UnderlineInputBorder(),
                          //fillColor: Colors.green
                        ), // InputDecoration
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          setState(() => montantDonCVE = val);
                        }),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                child: Text(
                  "Les champs marqués d'un * sont obligatoire",
                ),
              ),
              SizedBox(height: 20.0),
              ButtonTheme(
                minWidth: 190,
                height: 56,
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: RaisedButton(
                  onPressed: () async {
                    if (_fromKey.currentState.validate()) {
                      var dateHeureLorsAppelFonction = DateTime.now();
                      String formatDateHeure = DateFormat('yyyyMMddHHmmss').format(dateHeureLorsAppelFonction);
                      int formatDateHeureConvertiInt = int.parse(formatDateHeure);
                      await collectionDeProduit.add({
                        'title': titreProduit,
                        'price': prixProduit,
                        'priceCVE': montantDonCVE,
                        'description': descriptionProduit,
                        'state': etatProduit,
                        'category': categorieProduit,
                        'idUtilisateur': user.uid,
                        'nomVendeur': '',
                        'cheminImageCloudStorage': '',
                        'contactUtilisateur': contactUtilisateur,
                        'heurePublication': formatDateHeureConvertiInt,
                      })
                          // J'upload l'image dans cloud storage
                          .then((value) {
                        if (_imageFile != null) {
                          Storage().uploadImageDansCloudStorage(_imageFile, value.id, true);
                        }
                        DatabaseService(uid: user.uid).ajouterNomUtilisateurProduit(value.id);
                        _AffichePopUpAnnoncePublie();
                      }).catchError((error) => print("Failed to add product: $error"));

                      _controllerTitle.clear();
                      _controllerPrice.clear();
                      _imageFile = null;
                      //_nettoyerImage;

                    }
                  }, // onPressed
                  child: Text(
                    'Publier',
                    style: TextStyle(fontSize: 20, color: Colors.white), // TextStyle
                  ), // Text
                  color: Colors.green,
                ), // RaisedButton
              ),
              SizedBox(height: 12.0),
              Text(
                erreur,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ), // Text
            ], // children
          ), // Column
        ), // Form
      ), // SingleChildScrollView
    ); // SafeArea
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      //width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Ajouter une photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.camera),
                onPressed: () {
                  if (autoriserAccesCameraOuGalerie == true) {
                    _choisirUneImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                label: Text("Camera"),
              ),
              FlatButton.icon(
                icon: Icon(Icons.image),
                onPressed: () {
                  if (autoriserAccesCameraOuGalerie == true) {
                    _choisirUneImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                label: Text("Galerie"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _choisirUneImage(ImageSource source) async {
    var image = await ImagePicker().pickImage(source: source);

    setState(() {
      _imageFile = File(image.path);
      _AffichePopUpImageEnregistre();
    });
  }

  void _nettoyerImage() {
    setState(() => _imageFile = null);
  }

  Future<void> _AffichePopUpImageEnregistre() {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: Text('L\'image a bien été enregistré !'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _AffichePopUpAnnoncePublie() {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: Text('Votre annonce a bien été publié !'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _AffichePopUpAutorisation() {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: Text("Autorisez-vous l'applicaiton BS'Trade à accéder à votre caméra et votre galerie ?"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Non'),
              onPressed: () {
                autoriserAccesCameraOuGalerie = false;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("J'autorise"),
              onPressed: () {
                autoriserAccesCameraOuGalerie = true;
                Navigator.of(context).pop();
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
              },
            ),
          ],
        );
      },
    );
  }
} // build
