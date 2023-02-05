import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../pages/produits_deatails.dart';
import '../services/firebase_Reference.dart';
import '../parametres/themeGeneral.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProduitsPage extends StatefulWidget {
  ProduitsPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _ProduitsPageState createState() => _ProduitsPageState();
}

class _ProduitsPageState extends State<ProduitsPage> {
  @override
  Widget build(BuildContext context) {
    final categorie_name = ModalRoute.of(context).settings.arguments;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: ThemeGeneral().color_AppBar,
          elevation: 2,
          title: Text(AppLocalizations.of(context).produit_title + ' ' + categorie_name.toString().toLowerCase()),
        ),
        body: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseReference()
                .firebaseRef
                .collection("PRODUITS")
                .where("categorie", isEqualTo: categorie_name)
                .where("vente_start", isEqualTo: "true").where("trading", isEqualTo: false)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Désolé une erreur est survenue.'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LinearProgressIndicator(), 
                      Padding( 
                        padding: const EdgeInsets.all(12.0),
                        child: Text(AppLocalizations.of(context).produit_chargement,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                );
              }
              print(snapshot.data.docs);
              if (snapshot.data.docs.length == 0) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sick,
                        size: 120,
                        color: Colors.blueGrey[200],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(AppLocalizations.of(context).produit_empty,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                );
              }
        
                  return new ListView(               
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) => ProduitsDetailsPage(),
                          settings: RouteSettings(arguments: {"data": document.data(), "id": document.id} ),
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
                                    document['image_principale']),
                                    fit: BoxFit.fill),
                          ),
                        ),
                        Container(
                          height: 120,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Container(
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  2) -
                                              25,
                                      child: Text(
                                        document['nom'],
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                   Container(
                                    width: (MediaQuery.of(context).size.width /
                                            2) -
                                        25,
                                    height: 15,
                                    child: Text(AppLocalizations.of(context).produit_PrixVente + ": " +
                                      document['prix_vente'].toString() + " €",
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                   Container(
                                    width: (MediaQuery.of(context).size.width /
                                            2) -
                                        25,
                                    height: 15,
                                    child: Text(AppLocalizations.of(context).produit_NombrePlace + " " + document['nbr_place'].toString(),  // 100%
                                      //document['nbr_place'].toString() ,
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                   Container(
                                    width: (MediaQuery.of(context).size.width /
                                            2) -
                                        25,
                                    height: 15,
                                    child: Text(AppLocalizations.of(context).produit_PrixPlace + ": " +
                                      document['prix_place'].toString() + " €",
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blueGrey[800],
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Container(
                                    width: (MediaQuery.of(context).size.width /
                                            2) -
                                        10,
                                    height: 25,
                                    child: Text(
                                      document['description'],
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                          fontSize: 10,
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
        ),
      ),
    );
  }
}
