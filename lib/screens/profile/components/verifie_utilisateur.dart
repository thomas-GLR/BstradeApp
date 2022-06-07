import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:bstrade/services/auth.dart';
import 'package:bstrade/screens/profile/profile_screen.dart';
import 'package:bstrade/components/default_button.dart';
import 'package:bstrade/models/person.dart';
import 'modify_profile.dart';

class VerifieUtilisateur extends StatefulWidget {
  //final Function toggleView;
  //SignIn({this.toggleView});
  VerifieUtilisateur({
    Key key,
    this.utilisateurActuelle,
  }) : super(key: key);

  final Map<String, dynamic> utilisateurActuelle;

  @override
  _VerifieUtilisateurState createState() => _VerifieUtilisateurState();
}

class _VerifieUtilisateurState extends State<VerifieUtilisateur> {
  final AuthService _auth = AuthService();
  final _fromKey = GlobalKey<FormState>();

  // Text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    final idUtilisateurActuellementConnecte = Provider.of<Person>(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text("BS’Trade"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(ProfileScreen.routeName, (Route<dynamic> route) => false),
            //onPressed: () => Navigator.pop(context),
          )),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
        child: Form(
          key: _fromKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 50),
              Text(
                "Confirmation utilisateur",
                style: TextStyle(
                  color: Colors.green[300],
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 80.0),
              Text(
                "Veuillez confirmer votre identité afin de modifier votre profile",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 50.0),
              TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    labelText: "Email",
                    hintText: "Entrez votre email",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (val) => val.isEmpty ? 'Saisir un email' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  }), // TextFormField
              SizedBox(height: 30),
              TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    labelText: "Password",
                    hintText: "Entrez votre mot de passe",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (val) => val.length < 6 ? 'Saisir un mot de passe de plus de 6 caractère' : null,
                  onChanged: (val) {
                    setState(() => password = val);
                  }),
              SizedBox(height: 60.0),
              DefaultButton(
                  text: "Confirmer",
                  press: () async {
                    if (_fromKey.currentState.validate()) {
                      //setState(() => loading = true);
                      dynamic result = await _auth.signInWithEmailandPassword(email, password);
                      if (result == null) {
                        setState(() {
                          error = 'Identifiants incorrects';
                        });
                      } else {
                        if (result.uid == idUtilisateurActuellementConnecte.uid) {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ModifyProfile(utilisateurActuelle: widget.utilisateurActuelle)));
                        }
                      }
                    }
                  }), // RaisedButton*/
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ], // children
          ),
        ),
      ),
    );
  }
}
