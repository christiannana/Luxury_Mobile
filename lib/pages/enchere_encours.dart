import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:luxury/component/categorie_dialog.dart';
import 'package:luxury/parametres/themeGeneral.dart';
import 'package:luxury/services/firebase_Reference.dart';
import 'package:luxury/services/storage.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'trading_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class EnchereEncoursPage extends StatefulWidget {
//   EnchereEncoursPage({Key key, this.title}) : super(key: key);
//   final String title;
//   @override
//   _EnchereEncoursPageState createState() => _EnchereEncoursPageState();
// }

// class _EnchereEncoursPageState extends State<EnchereEncoursPage> {

  // ignore: must_be_immutable
  class EnchereEncoursPage extends StatelessWidget {
   
    var template;
    String utilisateurEmail;
    onReadEmail() {
    utilisateurEmail = StorageSrevice().onReadData("email");
  }

  // @override
  // void initState() {
  //   super.initState();
  //   onReadEmail(); 

  // }

  @override
  Widget build(BuildContext context) {
    onReadEmail(); 
    print("Je suis un chercheur des Erreurs");
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          backgroundColor: Colors.grey[200],
          body: Scrollbar(
            child: SingleChildScrollView (
                    child: Column(             
                    children: [  

                   StreamBuilder<QuerySnapshot>(
                        stream: FirebaseReference()
                            .firebaseRef
                            .collection("PLACES_ACHETE_PRODUCTION").where("email_utilisateur", isEqualTo: utilisateurEmail).where("status", isEqualTo: true)
                            .snapshots(),
                            builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) { 
         
                           if (! snapshot.hasData) return Center(
                              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: MediaQuery.of(context).size.height /4 - 50,),
                                   Icon(
                                Icons.sick,
                                size: 120,
                                color: Colors.blueGrey[200],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                AppLocalizations.of(context).enchereEnCours_acheterDesPlace,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w500),
                                ),
                              ),
                                        ],
                                      ),
                            ); 
                          


                  if (snapshot.connectionState == ConnectionState.waiting) { 
                        return Center(child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(),
                        ),
                        
                     );
                  }


                          // if (snapshot.connectionState == ConnectionState.waiting) {
                          //   return Center(child: Text(AppLocalizations.of(context).enchereEncours_rafraichissement));
                          // }


                    // print(snapshot.data.docs.length);
                              return new Column(
                              children:
                              snapshot.data.docs.map((DocumentSnapshot document) {
                              return new    

      //////////////////////////  STREAM BUILDER POUR LA SECONDE LECTURE ////////////////////////////////////
   

                            StreamBuilder<QuerySnapshot>( 
                            stream: FirebaseReference()
                                .firebaseRef
                                .collection("PRODUITS").where("id", isEqualTo: document['produit_id']).where("enchere", isEqualTo: "encours")
                                .snapshots(),
                            builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Center(child: Padding(
                          padding: const EdgeInsets.only(top: 58.0),
                          child: Text("Désolé une erreur c'est produite..."),
                          ),);
                          }


                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) { 
                                return Center(child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(),
                          ), );
                               }

                              
                     
                              print(snapshot.data.docs);
                              return new Column(
                                children: snapshot.data.docs
                                    .map((DocumentSnapshot document) {
                                  return new
                                  
                                  //  ListTile(
                                  //   title: new Text(document['nom']),
                                  //   subtitle:
                                  //       new Text(document['nbr_place'].toString() +' à '+document['prix_place'].toString() ),
                                  // );

                       Center(
                        child: SizedBox( width: MediaQuery.of(context).size.width - 10,
                        child: InkWell( onTap: (){
                           Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TradingPage(),
                                  settings: RouteSettings(
                                      arguments: document.data()),
                                ),
                              );
                        },
                                                  child: Card(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row( crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                
                   Column( crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(AppLocalizations.of(context).enchereEncours_nomProduit + ' ' + document['categorie'] +'.' , style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500, fontSize: 10),),
                       Padding(
                             padding: const EdgeInsets.only(bottom:8.0,top: 4),
                             child: SizedBox(width: 160,
                               child: Text(document['nom'], 
                               overflow: TextOverflow.ellipsis,
                             style: TextStyle(
                            color: Colors.blueGrey[800],
                            fontWeight: FontWeight.bold, fontSize: 14),),
                             ),
                       ),
                       Container( height: 88,width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(             
                            image: NetworkImage(document['image_principale'] ),
                            fit: BoxFit.cover,
                          ),),
                          child: Text("")),
                     ],
                   ),

                
                 Column(
                   children: [
                     SizedBox(width: MediaQuery.of(context).size.width/2-15,
                       child: Row(mainAxisAlignment: MainAxisAlignment.end,
                           children: [
                            
                             Column(mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                  Text(AppLocalizations.of(context).enchereEncours_offreGagnante, style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500, fontSize: 10),),
                                  Card(elevation: 0, color: document['trading'] == true ? Colors.amber[100] : Colors.blue[200] , child: Row(
                                  children: [
                                  Padding(
                                   padding: const EdgeInsets.all(2.0),
                                   child: Text(document['prix_offre'].toString() + " €",    style: TextStyle(
                                   color: Colors.black,
                                   fontWeight: FontWeight.bold, fontSize: 16),),
                                     ),
                                    //  Icon(Icons.euro, color: Colors.black54,size: 16),
                                   ],
                                 ),
                                ),
                               ],
                             ),
                           ],
                       ),
                     ),

                     Padding(
                       padding: const EdgeInsets.only(top:18.0),
                       child: Row(mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             Icon(Icons.av_timer, color: Colors.grey,size: 16),
                             Text( document['date_fin_vente'] == 1111 ? AppLocalizations.of(context).enchereEncours_enchereNonOuverte: "- " +  DateTime.fromMillisecondsSinceEpoch(document['date_fin_vente']).format('dd MMMM  y, HH').toString(),   
                             style: TextStyle(
                                  color: Colors.blueGrey[600],
                                  fontWeight: FontWeight.bold, fontSize: 14),),
                           ],
                       ),
                     ),

                      Padding(
                       padding: const EdgeInsets.only(top:8.0),
                       child: Row(mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             Icon(Icons.person, color:  document['email_utilisateur'] == StorageSrevice().onReadData("email") ? Colors.green : Colors.red ,size: 16),
                             Padding(
                               padding: const EdgeInsets.only(left:4.0, right: 5),
                               child: Text(document['prenom_utilisateur'],style: TextStyle(
                                    color: Colors.blueGrey[400],
                                    fontWeight: FontWeight.w500, fontSize: 12),),
                             ),

                                  Container(color: document['email_utilisateur'] == StorageSrevice().onReadData("email") ? Colors.green : Colors.red ,
                                    child: Text("+ ${document['prix_offre']}  £",style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold, fontSize: 12,),),
                                    ),
                           ],
                       ),
                     ),

                      Padding(
                       padding: const EdgeInsets.only(top:2.0),
                       child: Row(mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             Icon(Icons.calendar_today, color: Colors.grey,size: 10),
                             Padding(
                               padding: const EdgeInsets.all(4.0),
                               child: Text( DateTime.fromMillisecondsSinceEpoch(document['date']).format('dd MMMM  y, HH:mm').toString(),style: TextStyle(
                                    color: Colors.blueGrey[800],
                                    fontWeight: FontWeight.w500, fontSize: 8),),
                             ),
                              ],
                          ),
                        )
                      ],
                    )


                       ],
                            ),
                          )),
                        ),
                  ),
                );

                                }).toList(),
                              );
                            },
                          );

                            }).toList(),
                          );
                        },
                     
                  ),
                     
                     SizedBox(height:10),  
                       
                     SizedBox(height:70)
                  
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: ThemeGeneral().color_Boutton,
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => NouveauQuickCash()),
              // );
              // onEnchereStart(context);
              
              CategorieDialog().onCategorieList(context);
            },
            icon: Icon(Icons.queue),
            label: Text(
              AppLocalizations.of(context).enchereEncours_acheter,
              style: TextStyle(color: ThemeGeneral().color_TextBoutton),
            ),
          ),
      ),
    );
  }


}
