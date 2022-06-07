import 'package:flutter/material.dart';
import 'package:bstrade/services/auth.dart';
import 'package:bstrade/shared/loading.dart';

import 'package:bstrade/components/default_button.dart';
import 'package:bstrade/constants.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _fromKey = GlobalKey<FormState>();
  bool loading = false;

  // Text field state
  String email = '';
  String username = '';
  String password = '';
  String error = '';
  bool checkboxEstCoche = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.green;
      }
      return kCouleurPrincipale;
    }

    return loading
        ? Loading()
        : Scaffold(
            /*
            appBar: AppBar(backgroundColor: Colors.green[400], elevation: 0.0, title: Text('Créer un compte'), actions: <Widget>[
              FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Se connecter'),
                  onPressed: () {
                    widget.toggleView();
                  }),
            ]), // AppBar*/
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              child: Form(
                key: _fromKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    Text("Créer un compte", style: headingStyle),
                    SizedBox(height: 40.0),
                    TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                          labelText: "Email",
                          hintText: "Email",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (val) => val.isEmpty ? 'Saisir un email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        }), // TextFormField
                    SizedBox(height: 40.0),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                          labelText: "Nom d'utilisateur",
                          hintText: "Nom d'utilisateur",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Padding(
                            padding: const EdgeInsetsDirectional.only(end: 15.0),
                            child: Icon(Icons.person_outline),
                          ),
                        ),
                        validator: (val) => val.isEmpty ? 'Saisir un nom d\'utilisateur' : null,
                        onChanged: (val) {
                          setState(() => username = val);
                        }), // TextFormField
                    SizedBox(height: 40.0),
                    TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                          labelText: "Mot de passe",
                          hintText: "Mot de passe",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Icon(Icons.lock_outline),
                        ),
                        validator: (val) => val.length < 6 ? 'Saisir un mot de passe de plus de 6 caractère' : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        }),
                    SizedBox(height: 60.0),
                    Row(children: [
                      Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.resolveWith(getColor),
                          value: checkboxEstCoche,
                          onChanged: (bool value) {
                            setState(() {
                              print(checkboxEstCoche);
                              checkboxEstCoche = value;
                              print(checkboxEstCoche);
                            });
                          }),
                      SizedBox(width: 20),
                      Row(children: [
                        Text(
                          "J\'accepte les",
                          style: TextStyle(color: Colors.black, fontSize: 14.0),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("je suis activé !");
                          },
                          child: Text(
                            " CGU ",
                            style: TextStyle(color: Colors.green, fontSize: 14.0),
                          ),
                        ),
                        Text(
                          "de BS'Trade",
                          style: TextStyle(color: Colors.black, fontSize: 14.0),
                        ),
                      ]),
                    ]),

                    SizedBox(height: 12.0),
                    DefaultButton(
                        text: "Continue",
                        press: () async {
                          if (_fromKey.currentState.validate()) {
                            if (checkboxEstCoche == false) {
                              setState(() {
                                error = 'Vous devez accepter les CGU Pour créer un compte';
                                loading = false;
                              });
                            } else {
                              setState(() => loading = true);
                              dynamic result = await _auth.registerWithEmailandPassword(email, password, username);
                              if (result == null) {
                                setState(() {
                                  error = 'email invalide ou déjà existant';
                                  loading = false;
                                });
                              }
                            }
                          }
                        }),
                    /*
                    RaisedButton(
                        color: Colors.pink[400],
                        child: Text(
                          'Créer un compte',
                          style: TextStyle(color: Colors.white),
                        ), // Text
                        onPressed: () async {
                          if (_fromKey.currentState.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _auth.registerWithEmailandPassword(email, password, username);
                            if (result == null) {
                              setState(() {
                                error = 'email invalide ou déjà existant';
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
                    GestureDetector(
                      onTap: () => widget.toggleView(),
                      child: Text(
                        "Retour",
                        style: TextStyle(fontSize: 16, color: kCouleurPrincipale),
                      ),
                    ),
                  ], // children
                ),
              ),
            ),
          );
  }
}
