import 'package:firebase_auth/firebase_auth.dart';
import 'package:bstrade/models/person.dart';
import 'package:bstrade/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on FirebaseUser
  Person _userFromFirebaseUser(User user) {
    return user != null ? Person(uid: user.uid) : null;
  }

  // auth change user stream
  // every time a user sign in -> return user uid
  // every time a user sign out -> return null
  Stream<Person> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // sign in anon

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email & password
  Future signInWithEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      print(user.uid);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email & password
  Future registerWithEmailandPassword(String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;

      // create  a new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData(username);
      //await user.sendEmailVerification();
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // modifier l'adresse email

  void modifierAdresseEmail(String nouvelleEmail) async {
    var user = await FirebaseAuth.instance.currentUser;

    user.updateEmail(nouvelleEmail).then((_) {
      print("L'adresse email a bien été modifiée");
    }).catchError((error) {
      print("L'adresse email n'a pas pu être modifié " + error.toString());
    });
  }

  // modifier le mot de passe

  void modifierMotDePasse(String nouveauMotDePasse) async {
    var user = await FirebaseAuth.instance.currentUser;

    user.updatePassword(nouveauMotDePasse).then((_) {
      print("Le mot de passe a bien été modifié");
    }).catchError((error) {
      print("Le mot de passe n'a pas pu être modifié " + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut(); // signOut is a method from Firebase_auth class
    } catch (e) {
      print(e.toString);
      return null;
    }
  }
}
