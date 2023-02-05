

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:luxury/pages/enchere_encours.dart';
// import 'package:luxury/pages/pages_secondaires/aide_commentaires.dart';
// import 'package:luxury/pages/pages_secondaires/apropo.dart';
// import 'package:luxury/pages/pages_secondaires/contact.dart';
// import 'package:luxury/pages/pages_secondaires/langue.dart';
import 'package:luxury/pages/pages_secondaires/mon_compte.dart';
import 'package:luxury/pages/pages_secondaires/parametres.dart';
import 'package:luxury/services/firebase_Reference.dart';
import 'package:luxury/services/http_Ref.dart';
import 'package:luxury/services/storage.dart';
import '../services/popup_service.dart';
import '../parametres/themeGeneral.dart';
import 'package:share/share.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import 'pages_secondaires/apropo.dart';



class MenuPage extends StatefulWidget {
  MenuPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with SingleTickerProviderStateMixin {
  int valeur = 0;
  int date = 1621321475652;
  TabController _tabController;
  String _url = "https://luxuryreverseauctionlimited.com/";


  onAppVersionController() async {
       var response = await Dio().get(HttpRef().baseUrl + "produits/application_version",);
       if (response.data["version"] > 2){  
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ParametresPage(),
                  ),
                  (route) => false,
                );
          }                        
  }

  @override
  void initState() {
     var actived = StorageSrevice().onReadData("email");
    _tabController = new TabController(length: 2, vsync: this);
    onAppVersionController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  var actived = StorageSrevice().onReadData("email");
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: ThemeGeneral().color_AppBar,
        title: Text('Luxury'),
        bottom: TabBar(controller: _tabController, 
        indicatorWeight: 3,
        indicatorColor: Colors.amber[100],
        tabs: <Widget>[
          Tab(
            child: Text(AppLocalizations.of(context).menuPrincipal_enchereEnCours),
          ),
          Tab(child: Text(AppLocalizations.of(context).menuPrincipal_tableauBord))
        ]),
        actions: [
          IconButton(
            color: Colors.black,
            onPressed: () {
              print(DateTime.now().format('MMMM dd y, HH:mm:ss a'));
              print(DateTime.fromMillisecondsSinceEpoch(date).subMilliseconds(12).format(' dd MMMM y, HH:mm:ss a'));
            },
            icon: Icon(
              Icons.notifications_active,
              color: ThemeGeneral().color_Icon,
            ),
          ),



        ],
      ),
      drawer: Drawer(
        child: Scrollbar(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                    //  color:ServicePopUp().primary,
                    color: ThemeGeneral().color_AppBar),
                child: Row(
                  children: <Widget>[
                  TextButton(
                    child: Icon(
                      Icons.account_circle,
                      size: 70,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(  width: 200,
                          child: Text(
                           'nom: '+  StorageSrevice().onReadData("nom") + ' \nprenom: '+  StorageSrevice().onReadData("prenom") + '\nEmail: '+  StorageSrevice().onReadData("email") + '',
                           overflow: TextOverflow.fade,
                            style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontSize: 12,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.portrait),
                title: Text( AppLocalizations.of(context).menuPrincipal_monCompte),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MonComptePage(),
                      ),
                    );
                },
              ),

              // ListTile(
              //   leading: Icon(Icons.language),
              //   title: Text('langue'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) =>LanguesPage(),
              //         ),
              //       );
              //   },
              // ),

              // ListTile(
              //   leading: Icon(Icons.history),
              //   title: Text('Historique'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => Historique()),
              //     );
              //   },
              // ),
              Divider(),
              ListTile(
                leading: Icon(Icons.list),
                title: Text(AppLocalizations.of(context).menuPrincipal_apropos),
                onTap: () {
                  Navigator.pop(context);
                   Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AproposPage(),
                      ),
                    );
                },
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text(AppLocalizations.of(context).menuPrincipal_aideCommentaire),
                onTap: () {
                  // Navigator.pop(context);
                       this._url = "https://luxuryreverseauctionlimited.com/";                    
                       _launchURL();
                        Navigator.pop(context);
                      //  Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => AideCommentairePage(),
                  //     ),
                  //   );
                },
              ),

              ListTile(
                leading: Icon(Icons.contacts),
                title: Text(AppLocalizations.of(context).menuPrincipal_nousContacter),
                onTap: () {
                     this._url = "https://luxuryreverseauctionlimited.com/contact/";                    
                      _launchURL();
                      Navigator.pop(context);
                  // Navigator.pop(context);
                  //  Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => ContactPage(),
                  //     ),
                  //   );
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.share),
                title: Text(AppLocalizations.of(context).menuPrincipal_partager),
                onTap: () {
                  Navigator.pop(context);
                  Share.share( StorageSrevice().onReadData("prenom") + '  ' + StorageSrevice().onReadData("nom") + '  vous invite a installer l\'application Luxury via le lien suivant: https://play.google.com/store/apps/details?id=com.luxury.app2021');
                  // ServicePopUp().onAlerteSucces(
                  //   context,
                  //   'Information',
                  //   'Module en cours de developpement, Veuillez patienter.',
                  //   'Compris',
                  // );
                },
              ),

              // ListTile(
              //   leading: Icon(Icons.settings),
              //   title: Text('Paramètres'),
              //   onTap: () {
              //     Navigator.pop(context);
              //      Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => ParametresPage(),
              //         ),
              //       );
              //   },
              // ),
              ListTile(
                leading: Icon(Icons.lock), 
                title: Text(AppLocalizations.of(context).menuPrincipal_seDeconnecter),
                onTap: () {
                  Navigator.pop(context);
                  ServicePopUp().onDeconnction(context,);
                },
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 15, bottom: 15),
                child: Text(
                  'Luxury V 1.2.2',
                  style: TextStyle(color: Colors.blueGrey[200]),
                ),
              )
            ],
          ),
        ),
      ),
      body: TabBarView(controller: _tabController, children: <Widget>[
        EnchereEncoursPage(),
        
        Column(
          children: [
           SizedBox(height:10),   

                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseReference()
                                .firebaseRef
                                .collection("PRODUITS").where("email_utilisateur", isEqualTo: StorageSrevice().onReadData('email')).where("livraison", isEqualTo: "Non livré")
                                .snapshots(),
                            builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Center(child: Padding(
                                  padding: const EdgeInsets.only(top: 58.0),
                                  child: Text(AppLocalizations.of(context).menuPrincipal_desole),
                                  ),);
                              }


                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) { 
                                return Center(child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: CircularProgressIndicator(),
                                ), );
                              }

                              
                    if (snapshot.data.docs.length == 0) {
                    return Center(child: Card( color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.warning_amber_outlined, size: 52,color: Colors.amber,),
                ),
                Text(AppLocalizations.of(context).menuPrincipal_desole2),
              ],
            ),
                      ),
           ));
         }
                              print(snapshot.data.docs);
                              return new Column(
                                children: snapshot.data.docs
                                    .map((DocumentSnapshot document) {
                                  return new
                                  
                                  //  ListTile(
                                  //   title: new Text(document['nom']),
                                  //   subtitle:
                                  //       new Text(document.data()['nbr_place'].toString() +' à '+document.data()['prix_place'].toString() ),
                                  // );

                                  Center(
            child: SizedBox( width: MediaQuery.of(context).size.width - 10,
                        child: InkWell( onTap: (){
                          //  Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => TradingPage(),
                          //         settings: RouteSettings(
                          //             arguments: document.data()),
                          //       ),
                          //     );
                        },
                            child: Card(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row( crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                
                   Column( crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(AppLocalizations.of(context).menuPrincipal_nomProduit + document['categorie'] +'.' , style: TextStyle(
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
                  image: NetworkImage(document['image_principale']  ),
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
                                  Text(AppLocalizations.of(context).menuPrincipal_netAPayer, style: TextStyle(
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
                             Icon(Icons.redeem, color: Colors.grey,size: 16),
                             Text( AppLocalizations.of(context).menuPrincipal_vousAvezGagner,   
                             style: TextStyle(
                                  color: Colors.blue[600],
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

                                  Container(color: document['email_utilisateur'] == StorageSrevice().onReadData("email") ? Colors.green : Colors.red,
                                    child: Text("+ ${document['prix_offre']}  €",style: TextStyle(
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
                               child: Text( DateTime.fromMillisecondsSinceEpoch(document['date']).format('dd MMMM  y, hh:mm').toString(),style: TextStyle(
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
                          ),
                        ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ]),
    );
  }


   void _launchURL() async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

}
