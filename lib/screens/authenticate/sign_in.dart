import 'package:flutter/material.dart';
import 'package:bstrade/services/auth.dart';
import 'package:bstrade/shared/loading.dart';
import 'package:bstrade/screens/home/home_screen.dart';

import 'package:bstrade/components/default_button.dart';
import 'package:bstrade/constants.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _fromKey = GlobalKey<FormState>();
  bool loading = false;

  // Text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.green,
                title: const Text("Se connecter"),
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (Route<dynamic> route) => false),
                  //onPressed: () => Navigator.pop(context),
                )),
            /*appBar: AppBar(backgroundColor: Colors.green[400], elevation: 0.0, title: Text('Se connecter'), actions: <Widget>[
              FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Créer un compte'),
                  onPressed: () {
                    widget.toggleView();
                  }),
            ]),*/
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
              child: Form(
                key: _fromKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 50),
                    Text(
                      "BS’Trade",
                      style: TextStyle(
                        color: Colors.green[300],
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 80.0),
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
                    SizedBox(height: 60),
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
                        text: "Continue",
                        press: () async {
                          if (_fromKey.currentState.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _auth.signInWithEmailandPassword(email, password);
                            if (result == null) {
                              setState(() {
                                error = 'Impossible de se connecter avec ces identifiants';
                                loading = false;
                              });
                            }
                          }
                        }),
                    /*RaisedButton(
                        color: Colors.green,
                        child: Text(
                          'Se connecter',
                          style: TextStyle(color: Colors.white),
                        ), // Text
                        onPressed: () async {
                          if (_fromKey.currentState.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _auth.signInWithEmailandPassword(email, password);
                            if (result == null) {
                              setState(() {
                                error = 'Impossible de se connecter avec ces identifiants';
                                loading = false;
                              });
                            }
                          }
                        }), // RaisedButton*/
                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ), // Text
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () => widget.toggleView(),
                      child: Text(
                        "Créer un compte",
                        style: TextStyle(fontSize: 16, color: kCouleurPrincipale),
                      ),
                    ),
                  ], // children
                ), // Column
              ), // Form
            ), // Container
          ); // Scaffold
  }
}
