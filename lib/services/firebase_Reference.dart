
// import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseReference {
   DocumentReference firebaseRef = FirebaseFirestore.instance.collection('Trading_DB').doc("modeles");
   CollectionReference firebaseColRef = FirebaseFirestore.instance.collection('Trading_DB').doc("modeles").collection("PRODUITS");
}

