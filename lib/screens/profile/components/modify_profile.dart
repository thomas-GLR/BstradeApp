import 'dart:io';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bstrade/services/database.dart';
import 'package:bstrade/models/person.dart';
import 'package:bstrade/screens/profile/profile_screen.dart';
import 'package:bstrade/screens/home/home_screen.dart';
import 'package:bstrade/services/storage_service.dart';
import 'package:bstrade/services/auth.dart';

class ModifyProfile extends StatefulWidget {
  ModifyProfile({
    Key key,
    this.utilisateurActuelle,
  }) : super(key: key);

  final Map<String, dynamic> utilisateurActuelle;

  @override
  _ModifyProfileState createState() => _ModifyProfileState();
}

class _ModifyProfileState extends State<ModifyProfile> {
  // Permet d'autoriser l'utilisation de la galerie ou de la camera
  bool autoriserAccesCameraOuGalerie = false;

  var utilisateurActuellementConnecte = FirebaseAuth.instance.currentUser;
  final AuthService _auth = AuthService();
  File _imageFile;
  String nouveauNomUtilisateur = '';
  String nouvelleAdresseEmail = '';
  String nouveauMotDePasse = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text("Retour au profil"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(ProfileScreen.routeName, (Route<dynamic> route) => false),
            //onPressed: () => Navigator.pop(context),
          )),
      body: Center(
        //children: [
        //SizedBox(height: 30),
        child: Column(children: [
          SizedBox(height: 30),
          SizedBox(
            height: 150,
            width: 150,
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                Container(
                  child: FutureBuilder(
                      future: Storage().recupererImageURL(widget.utilisateurActuelle['cheminImageCloudStorage'].toString()),
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                          return CircleAvatar(
                            backgroundImage: NetworkImage(snapshot.data),
                            backgroundColor: Colors.white,
                          );
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        return CircleAvatar(
                          backgroundImage: AssetImage("assets/images/profile_image.png"),
                          backgroundColor: Colors.white,
                        );
                      }),
                ),
                Positioned(
                  right: -16,
                  bottom: 0,
                  child: SizedBox(
                    height: 46,
                    width: 46,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(color: Color(0xFFF5F6F9)),
                        ),
                        primary: Colors.white,
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        _AffichePopUpAutorisation();
                      },
                      child: Icon(
                        Icons.add_a_photo_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 60),
          Container(
            width: 300,
            child: TextFormField(
                decoration: new InputDecoration(
                  labelText: "Nouveau nom d'utilisateur",
                  hintText: "Nom d'utilisateur",
                  fillColor: Colors.white,
                  suffixIcon: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 15.0),
                    child: Icon(Icons.person_outline),
                  ),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                  //fillColor: Colors.green
                ),
                keyboardType: TextInputType.text,
                onChanged: (val) {
                  setState(() => nouveauNomUtilisateur = val);
                }),
          ),
          SizedBox(height: 40),
          /*Container(
            width: 300,
            child: TextFormField(
                decoration: new InputDecoration(
                  labelText: "Nouvelle adresse email",
                  fillColor: Colors.white,
                  suffixIcon: Icon(Icons.email_outlined),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                  //fillColor: Colors.green
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (val) {
                  setState(() => nouvelleAdresseEmail = val);
                }),
          ),
          SizedBox(height: 40),*/
          Container(
            width: 300,
            child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                  labelText: "Nouveau mot de passe",
                  hintText: "Mot de passe",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: Icon(Icons.lock_outline),
                ),
                validator: (val) => val.length < 6 ? 'Saisir un mot de passe de plus de 6 caractère' : null,
                onChanged: (val) {
                  setState(() => nouveauMotDePasse = val);
                }),
          ),
          SizedBox(height: 40),
          ButtonTheme(
            minWidth: 300,
            height: 56,
            padding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: RaisedButton(
              child: Text(
                "Modifier le profil",
                style: new TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
              ),
              color: Colors.green,
              onPressed: () {
                if (_imageFile != null) {
                  Storage().uploadImageDansCloudStorage(_imageFile, utilisateurActuellementConnecte.uid, false);
                  Storage().supprimerImage(widget.utilisateurActuelle['cheminImageCloudStorage'].toString());
                }
                if (nouveauNomUtilisateur != '') {
                  DatabaseService(uid: utilisateurActuellementConnecte.uid).updateUsername(nouveauNomUtilisateur);
                }
                /*
                if (nouvelleAdresseEmail != '') {

                  utilisateurActuellementConnecte.updateEmail(nouvelleAdresseEmail).then((_) {
                    print("L'adresse email a bien été modifiée");
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
                    _affichePopupProfilModifie();
                  }).catchError((error) {
                    print("L'adresse email n'a pas pu être modifié " + error.toString());
                    _affichePopupErreurModification('Erreur lors de la mofification de votre adresse mail. Veuillez vérifier que celle-ci soit valide et réessayer');
                  });
                  //_auth.modifierAdresseEmail(nouvelleAdresseEmail);
                } else {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
                  //Navigator.pushNamed(context, HomeScreen.routeName);
                  _affichePopupProfilModifie();
                }*/
                if (nouveauMotDePasse != '') {
                  utilisateurActuellementConnecte.updatePassword(nouveauMotDePasse).then((_) {
                    print("Le mot de passe a bien été modifié");
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
                    _affichePopupProfilModifie();
                  }).catchError((error) {
                    print("Le mot de passe n'a pas pu être modifié " + error.toString());
                    _affichePopupErreurModification('Erreur lors de la modification du mot de passe');
                    //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
                  });
                } else {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
                  //Navigator.pushNamed(context, HomeScreen.routeName);
                  _affichePopupProfilModifie();
                }
              },
            ),
          ),
          SizedBox(height: 40),
          ButtonTheme(
            minWidth: 300,
            height: 56,
            padding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: RaisedButton(
              child: Text(
                "Supprimer mon compte",
                style: new TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
              ),
              color: Colors.green,
              onPressed: () {
                _affichePopupSuppressionProfil();
              },
            ),
          ),
        ]),
        //],
      ),
    );
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
    });
  }

  Future<void> _affichePopupProfilModifie() {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: Text('Votre profil a bien été modifié !'),
          ),
          // Je renvoie sur la page d'accueil pour que la page profil s'actualise (pas trouver comment faire sinon)
          actions: <Widget>[
            TextButton(
              child: const Text('Voir profil'),
              onPressed: () {
                // Je ferme la pop up
                Navigator.of(context).pop();
                // Je renvoie sur le profil
                Navigator.pushNamed(context, ProfileScreen.routeName);
              },
            ),
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

  Future<void> _affichePopupErreurModification(String messageErreur) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: Text(messageErreur),
          ),
          // Je renvoie sur la page d'accueil pour que la page profil s'actualise (pas trouver comment faire sinon)
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

  Future<void> _affichePopupSuppressionProfil() {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: Text(
              'Cette action supprimera toutes vos publications, il ne sera pas possible de revenir en arrière. Souhaitez vous supprimer définitivement votre compte ?',
            ),
          ),
          // Je renvoie sur la page d'accueil pour que la page profil s'actualise (pas trouver comment faire sinon)
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Supprimer'),
              onPressed: () async {
                try {
                  // Je supprime l'image dans cloud storage pour ne pas surcharger le cloud en terme de place
                  Storage().supprimerImage(widget.utilisateurActuelle['cheminImageCloudStorage'].toString());
                  // je supprime mon document utilisateur de cloud firestore
                  DatabaseService(uid: utilisateurActuellementConnecte.uid).supprimerUtilisateurCloudFirestore();
                  // Je supprime l'utilisateur du système d'authentification de firebase
                  await utilisateurActuellementConnecte.delete();
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'requires-recent-login') {
                    print('The user must reauthenticate before this operation can be executed.');
                  }
                }
                Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (Route<dynamic> route) => false);
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
            child: Text("Autorisez-vous l'applicaiton BS'Trade à accéder à votre camera et votre galerie"),
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
}
