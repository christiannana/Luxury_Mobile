
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:luxury/component/paiement_dialog.dart';

import 'package:luxury/pages/pages_secondaires/evolution_marche.dart';
import 'package:luxury/pages/pages_secondaires/historique.dart';
import 'package:luxury/pages/pages_secondaires/parametres.dart';
import 'package:luxury/pages/produits_deatails.dart';
import 'package:luxury/parametres/themeGeneral.dart';
import 'package:luxury/services/firebase_Reference.dart';
import 'package:luxury/services/http_Ref.dart';
import 'package:luxury/services/storage.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TradingPage extends StatefulWidget {
  TradingPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _TradingPageState createState() => _TradingPageState();
}

class _TradingPageState extends State<TradingPage> {
  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
  var offre = TextEditingController();
  dynamic prix_trading;

    onAppVersionController() async {
       var response = await Dio().get(HttpRef().baseUrl + "produits/application_version",);
       print(response.data);
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
    onAppVersionController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    int date_cloture;
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
          leadingWidth: 30,
          toolbarHeight: 70,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black87,
            ),
          ),
          title: Row(children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProduitsDetailsPage(),
                    settings: RouteSettings(
                        arguments: {"data": data, "id": "document.id"}),
                  ),
                );
              },
              child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                      image: NetworkImage(data['image_principale']),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Text("")),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(AppLocalizations.of(context).trading_depotOffre,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black87, fontSize: 15, letterSpacing: 0),
                  ),
                )),
          ]),
          actions: [
            PopupMenuButton(
              icon: Icon(Icons.more_vert, color: Colors.black),
              onSelected: (result) {
                setState(() {
                  if (result == "detail")
                    return Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProduitsDetailsPage(),
                        settings: RouteSettings(
                            arguments: {"data": data, "id": "document.id"}),
                      ),
                    );

                  if (result == "achat")
                    return DialogPayment().onDialogPayment(
                      context,
                      data['id'].toString(),
                      data['nom'],
                      StorageSrevice().onReadData("email"),
                      StorageSrevice().onReadData("nom"),
                      data['prix_place'].toString(),
                      data['nbr_place'].toString(),
                      data['categorie'],
                      data['duree_enchere'],
                    );

                  if (result == "evolution")
                    return Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EvolutionMarchePage(),
                        settings: RouteSettings(arguments: {
                          "data": data,
                          "id": data['id'].toString()
                        }),
                      ),
                    );
                  print(data["id"]);
                  if (result == "historique")
                    return Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoriquePage(),
                        settings: RouteSettings(
                            arguments: {"data": data, "id": "document.id"}),
                      ),
                    );
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  value: "detail",
                  child: Text(AppLocalizations.of(context).trading_voireDetail),
                ),
                PopupMenuItem(
                  value: "achat",
                  child: Text(AppLocalizations.of(context).trading_acheterPluce),
                ),
                PopupMenuItem(
                  value: "evolution",
                  child: Text(AppLocalizations.of(context).trading_evolution),
                ),
                // PopupMenuItem(
                //   value: "C",
                //   child: Text('Bloquez les notifications'),
                // ),
                // PopupMenuItem(
                //   value: "historique",
                //   child: Text('Mon historique'),
                // ),
              ],
            ),
          ],
          elevation: 0,
          backgroundColor: Colors.grey[100],
        ),
        body: Stack(
          children: [
            Card(
              child: Column(
                children: [
                  Container(
                    color: Colors.blueGrey[50],
                    width: double.infinity,
                    height: 220,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseReference()
                              .firebaseRef
                              .collection("PRODUITS")
                              .where("id", isEqualTo: data['id'])
                              .where("vente_start", isEqualTo: "true")
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text(AppLocalizations.of(context).trading_erreur);
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text("Loading");
                            }

                            if (snapshot.data.docs.length == 0) {
                              return Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.sick,
                                        size: 80,
                                        color: Colors.blueGrey[200],
                                      ),
                                    ),
                                    Text(AppLocalizations.of(context).trading_venteCloture),
                                  ],
                                ),
                              ));
                            }

                            return new ListBody(
                              children: snapshot.data.docs
                                  .map((DocumentSnapshot document) {
                                prix_trading = document['prix_trading'];
                                date_cloture = document['date_fin_vente'];
                                return Column(
                                  children: [
                                    Container(
                                        child: Center(
                                            child:
                                                Text(document['nom']))),
                                    Text(AppLocalizations.of(context).trading_offreGagnante,
                                      style: TextStyle(
                                          color: Colors.blueGrey[600],
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      document
                                              ['prix_offre']
                                              .toString() +
                                          " €",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 34,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(AppLocalizations.of(context).trading_dateCloture,
                                        style: TextStyle(
                                            color: Colors.blueGrey[600],
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.av_timer,
                                            color: Colors.blueGrey[800],
                                            size: 18),
                                        Text( document['date_fin_vente'] == 1111 ? AppLocalizations.of(context).trading_enchereNonOuvert + " ":
                                          "- " + DateTime.fromMillisecondsSinceEpoch(
                                                      document['date_fin_vente'])
                                                  .format('dd MMMM  y, HH:mm')
                                                  .toString(), //+ DateTime.now().format('dd MMMM  y, h:mm:ss').toString(),
                                        
                                          style: TextStyle(
                                              color: Colors.blueGrey[600],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }).toList(),
                            );
                          },
                        ),
                        FutureBuilder<dynamic>(
                          future: onHttpTradingCall(
                              data["id"], StorageSrevice().onReadData("email")),
                          builder: (BuildContext context, snapshot) {
                            print(snapshot);
                            if (snapshot.hasError) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 28.0),
                                child: Text(AppLocalizations.of(context).trading_erreurReseau),
                              );
                            }

                            if (snapshot.hasData) {
                              if (snapshot.data == true ||
                                  snapshot.data["quotat"] == null ||
                                  snapshot.data["offres"] == []) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 18.0),
                                  child: Text(
                                    'Il vous reste 0 Offres.',
                                    style: TextStyle(
                                        color: Colors.red[600],
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                );
                              }
                              ;
                              return Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Text(AppLocalizations.of(context).trading_resteOffre + 
                                  '  ${snapshot.data["quotat"]["proposition_restante"].toString()} Offres.',
                                  style: TextStyle(
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12),
                                ),
                              );
                            }

                            if (snapshot.connectionState == ConnectionState.done) {
                              Map<String, dynamic> data = snapshot.data;
                              return Text("Full Name: ${data['status']} ${data['status']}");
                            }

                            return Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: SizedBox(
                                  height: 3,
                                  width: 120,
                                  child: LinearProgressIndicator()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            FutureBuilder<dynamic>(
                              future: onHttpTradingCall(data["id"],
                                  StorageSrevice().onReadData("email")),
                              builder: (BuildContext context, snapshot) {
                                print(snapshot);
                                if (snapshot.hasError) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 38.0),
                                    child: Text(AppLocalizations.of(context).trading_erreurReseau),
                                  );
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  List data = snapshot.data["offres"];
                                  if (data.length == 0)
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 38.0, bottom: 15),
                                          child: Icon(
                                            Icons.sick,
                                            size: 60,
                                            color: Colors.blueGrey[200],
                                          ),
                                        ),
                                        Text(AppLocalizations.of(context).trading_aucuneOffreDepose),
                                      ],
                                    );

                                   return Column(
                                      children: data
                                          .map((item) => new SizedBox(
                                                  child: onTradeurs(
                                                item["prenom_utilisateur"],
                                                item["Date"],
                                                item["prix_offre"].toString(),
                                                item["email_utilisateur"].toString(),
                                                item["status"],
                                              ),),)
                                          .toList() // Text(item["Date"])).toList()

                                      // [
                                      //   onTradeurs(data['offres'][1]["prenom_utilisateur"], data['offres'][1]["Date"], data['offres'][1]["prix_offre"].toString(),),
                                      // ],

                                      );
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(top: 18.0),
                                  child: SizedBox(
                                      height: 15,
                                      width: 120,
                                      child: Text("...")),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                child: Container(
                  color: Colors.grey[100],
                  height: 70,
                  child: Column(
                    children: [
                      // Padding(
                      //   padding:
                      //       const EdgeInsets.only(right: 12, left: 12, top: 12),
                      //   child: TextFormField(
                      //     //autofocus: true,
                      //     controller: offre,
                      //     keyboardType: TextInputType.number,
                      //     textCapitalization: TextCapitalization.characters,
                      //     style: TextStyle(fontWeight: FontWeight.bold),
                      //     decoration: InputDecoration(
                      //       contentPadding:
                      //           EdgeInsets.only(bottom: 1, top: 22, left: 20),
                      //       border: OutlineInputBorder(),
                      //       labelText: 'Montant de votre offre(en €)',
                      //       labelStyle: TextStyle(fontWeight: FontWeight.w500),
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                          },
                          child: SizedBox(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                            style: ElevatedButton.styleFrom( backgroundColor: Colors.black87,
                             shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                                ),),
                                child: Text(AppLocalizations.of(context).trading_deposerOffre,
                                      style: TextStyle(
                                      color: ThemeGeneral().color_TextBoutton,
                                      fontWeight: FontWeight.bold),),
                                 onPressed: () async {

                                   if (date_cloture == 1111) return CoolAlert.show(
                                                              context: context,
                                                              barrierDismissible: false,
                                                              confirmBtnColor:
                                                                  ThemeGeneral().color_Boutton,
                                                              type: CoolAlertType.warning,
                                                              title:AppLocalizations.of(context).trading_attente,
                                                              text: AppLocalizations.of(context).trading_attenteMessage,
                                                            );
                               
                                 onTradingDepot(data["id"], date_cloture );
                                 setState(() {
                                   
                                 });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onHttpTradingCall(produit_id, email_utilisateur) async {
    var response = await Dio()
      .post(HttpRef().baseUrl + "produits/proposition/restantes", data: {
      "produit_id": produit_id,
      "email_utilisateur": email_utilisateur
    });
    return response.data;
  }

  onTradingDepot(id, date_cloture){
    final dialog = showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[50],
          contentPadding: EdgeInsets.symmetric(horizontal: 7),
          insetPadding: EdgeInsets.all(20),
          title: Text(AppLocalizations.of(context).trading_offre,
            style: TextStyle(fontSize: 14),
          ),
          titlePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 80,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                   TextFormField(
                  autofocus: true,
                  controller: offre,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: AppLocalizations.of(context).trading_montantOffre,),
                  obscureText: false,
                ),
                           
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
           Row(mainAxisAlignment: MainAxisAlignment.end,
             children: [
               Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: ((MediaQuery.of(context).size.width / 3)  - 15), height: 35,
                    child: ElevatedButton(
                      
                      style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[100],
                            shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                      ),
                        child: Text(AppLocalizations.of(context).trading_Cancel, style: TextStyle(color: Colors.red),),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ),
                ),

             Padding(
                padding: const EdgeInsets.all(4.0),
                child: SizedBox(
                width: ((MediaQuery.of(context).size.width / 3) - 15), height: 35,
                child: RoundedLoadingButton(
                  height: 35,
                  width: (MediaQuery.of(context).size.width / 3)  - 15,
                  color: ThemeGeneral().color_Boutton,
                  successColor: Colors.green,
                  child: Text(AppLocalizations.of(context).trading_valider,
                      style: TextStyle(
                          color: ThemeGeneral().color_TextBoutton,
                          fontWeight: FontWeight.bold)),
                  controller: btnController,
                  onPressed: () async {
                    
                           try {
                                Response<Map> response = await Dio().post(
                                    HttpRef().baseUrl +
                                        'produits/trading/depot',
                                    data: {
                                      "produit_id": id, // data["id"],
                                      "prenom_utilisateur":
                                          StorageSrevice().onReadData("prenom"),
                                      "prix_trading": double.parse(prix_trading) + double.parse(offre.text),
                                      "prix_offre": double.parse(offre.text),
                                      "email_utilisateur":
                                          StorageSrevice().onReadData("email"),
                                      "nom_utilisateur":
                                          StorageSrevice().onReadData("nom"),
                                      "date_cloture": date_cloture
                                    });
                                btnController.stop();

                                if (response.data["status"] == false){
                                 Navigator.pop(context);
                                  return CoolAlert.show(
                                    context: context,
                                    barrierDismissible: false,
                                    confirmBtnColor:
                                        ThemeGeneral().color_Boutton,
                                    type: CoolAlertType.error,
                                    title: "Erreur !!!",
                                    text: response.data["message"],
                                  );
                                }


                                if (response.data["status"] == true) {
                                Navigator.pop(context);
                                  //  btnController.success();
                                  CoolAlert.show(
                                    context: context,
                                    barrierDismissible: false,
                                    confirmBtnColor:
                                        ThemeGeneral().color_Boutton,
                                    type: CoolAlertType.success,
                                    title: AppLocalizations.of(context).trading_felicitation,
                                    text:AppLocalizations.of(context).trading_felicitationMessage,
                                  );
                                }
                              } catch (e) {
                                btnController.stop();
                                CoolAlert.show(
                                  context: context,
                                  barrierDismissible: false,
                                  confirmBtnColor: ThemeGeneral().color_Boutton,
                                  type: CoolAlertType.warning,
                                  title: AppLocalizations.of(context).trading_erreur,
                                  text: AppLocalizations.of(context).trading_erreurMessage,
                                );
                                return null;
                              }
                     },
                 ),
                ),
               ),
             ],
           ),
            
          ],
        ); 
      },
    );

    return dialog;
  }












  Widget onBouttonClavier(numero) {
    return Expanded(
      child: InkWell(
        onTap: () {
          print(numero);

          print(DateTime.fromMillisecondsSinceEpoch(1622084432784)
              .format('dd MMMM  y, h:mm:ss')
              .toString());
          setState(() {});
        },
        child: Card(
          child: Container(
            height: 40,
            color: Colors.blueGrey[800],
            child: Center(
              child: Text(
                numero,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget onTradeurs(prenom_utilisateur, date, prix_offre, email, status) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.person, color:  status == "annuler" ? Colors.red[400] : status == "gagnant" ? Colors.green :  Colors.yellow, size: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3 - 10,
            child: Text(
              prenom_utilisateur,
              overflow: TextOverflow.fade,
              style: TextStyle(
                  color: Colors.blueGrey[400],
                  fontWeight: FontWeight.w500,
                  fontSize: 10),
            ),
          ),
          Text(
            date, //DateTime.fromMillisecondsSinceEpoch(date).format('dd MMMM  y, h:mm:ss').toString(),

            style: TextStyle(
                color: Colors.blueGrey[800],
                fontWeight: FontWeight.w500,
                fontSize: 10),
          ),
          //  Divider(height: 2,color: Colors.amber,),
          Spacer(),
          Container(
            color: status == "annuler" ? Colors.red : status == "gagnant" ? Colors.green : Colors.yellow,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                "+ $prix_offre  €",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



