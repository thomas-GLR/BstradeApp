//import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bstrade/models/individual.dart';
import 'package:bstrade/services/storage_service.dart';

class DatabaseService {
  final String uid;
  //final List<String> adId;
  //final List<String> favoriteId;
  DatabaseService({this.uid}); //, this.favoriteId, this.adId});

  // Collection reference
  final CollectionReference collectionUtilisateur = FirebaseFirestore.instance.collection('users');
  final CollectionReference collectionDeProduit = FirebaseFirestore.instance.collection('products');

  // USER

  // add new user
  Future updateUserData(String name) async {
    return await collectionUtilisateur.doc(uid).set({
      'name': name,
    });
  }

  // modify username

  Future updateUsername(String name) async {
    return await collectionUtilisateur.doc(uid).update({
      'name': name,
    });
  }

  // user list from snapshot
  List<Individual> _individualListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Individual(
        name: (doc.data() as dynamic)['name'] ?? '',
      );
    }).toList();
  }

  // get users stream
  Stream<List<Individual>> get users {
    return collectionUtilisateur.snapshots().map(_individualListFromSnapshot);
  }

  void ajouterNomUtilisateurProduit(produitID) {
    collectionUtilisateur.doc(this.uid).get().then((DocumentSnapshot documentSnapshotUtilisateur) {
      collectionDeProduit
          .doc(produitID)
          .update({
            'nomVendeur': documentSnapshotUtilisateur['name']
          })
          .then((value) => print("le produit a bien été update avec le nom du vendeur"))
          .catchError((error) => print("Erreur lors de l'ajout du nom du vendeur dans le produit: $error"));
    }).catchError((error) => print("Erreur lors de la récupération d'information sur l'utilisateur passsé en paramètre: $error"));
  }

  void supprimerToutesLesAnnoncesLieesUtilisateur() {
    collectionDeProduit.where('idUtilisateur', isEqualTo: this.uid).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((documentProduit) {
        Storage().supprimerImage(documentProduit['cheminImageCloudStorage'].toString());
        supprimerAncienneAnnonceListeFavoris(documentProduit.id);
        collectionDeProduit.doc(documentProduit.id).delete().then((value) => print("L'annonce id : $documentProduit.id, lié à l'utilisateur id:  $this.uid a été supprimé")).catchError((error) => print("Erreur lors de la suppression de l'annonce id : $documentProduit.id, lié à l'utilisateur id:  $this.uid"));
      });
    });
  }

  Future<void> supprimerUtilisateurCloudFirestore() {
    // je supprime préalablement toutes les annonces de l'utilisateur
    supprimerToutesLesAnnoncesLieesUtilisateur();
    return collectionUtilisateur.doc(this.uid).delete().then((value) => print("Suppression de l'utilisateur dans cloud firestore réussit")).catchError((error) => print("Erreur lors de la suppression de l'utilisateur dans cloud firestore: $error"));
  }

  Future recupererDonneeProduitFavoris(produitFavorisUtilisateur) {
    return FirebaseFirestore.instance.collection('products').doc(produitFavorisUtilisateur.id).get().then((DocumentSnapshot donneeProduitActuelle) {
      donneeProduitActuelle;
    });
  }

  // Permet de vider les listes de favoris pour ne pas garder les annonces n'existant plus
  Future<void> supprimerAncienneAnnonceListeFavoris(String idAncienProduit) {
    return collectionUtilisateur.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((utilisateur) {
        collectionUtilisateur.doc(utilisateur.id).collection('listeDeFavoris').doc(idAncienProduit).delete().then((value) => print("Le favoris relatif à l'id : $idAncienProduit a bien été supprimé")).catchError((error) => print("Erreur lors de la suppression du favoris relatif à l'id : $idAncienProduit"));
      });
    });
  }
}
