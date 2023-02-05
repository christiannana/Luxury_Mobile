import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:luxury/pages/produits.dart';
import '../services/firebase_Reference.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategorieDialog {
  onCategorieList(context) {
    final dialog = showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[50],
          contentPadding: EdgeInsets.symmetric(horizontal: 7),
          insetPadding: EdgeInsets.all(5),
          title: Text(AppLocalizations.of(context).componentCategorie_titre,
            style: TextStyle(fontSize: 14),
          ),
          titlePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: Column(
                children: <Widget>[
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseReference()
                        .firebaseRef
                        .collection("CATEGORIES")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LinearProgressIndicator(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Chargement en cours...",
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        );
                      }
                      print(snapshot.data.docs);
                      return new ListBody(
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProduitsPage(),
                                  settings: RouteSettings(
                                      arguments: document['nom']),
                                ),
                              );
                            },
                            child: new Card(
                              child: Row(children: [
                                Container(
                                  width: 150,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            document['image']),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                Container(
                                  height: 100,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Text(
                                              document['nom'],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2) -
                                                44,
                                            height: 50,
                                            child: Text(
                                              document['description'],
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.fade,
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.blueGrey,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                              ]),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                width: 100,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[100]
                  ),
                    child: Text(AppLocalizations.of(context).componentCategorie_boutton, style: TextStyle(color: Colors.red),),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ),
            ),
          ],
        );
      },
    );
    return dialog;
  }
}
