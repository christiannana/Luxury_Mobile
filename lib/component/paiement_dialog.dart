

import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
// import 'package:country_picker/country_picker.dart';
// import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:luxury/parametres/themeGeneral.dart';
import 'package:luxury/services/storage.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/http_Ref.dart';

// import 'package:http/http.dart' as http;



class DialogPayment {
   RoundedLoadingButtonController btnController;
   var nbrPlace = TextEditingController();
   var paysName = TextEditingController();
   var phoneCode = TextEditingController();
   var _url;
   String pays = "";
   bool codeCheck = false;

  String nom;
  String prenom;
  String email;
  String telephone;
  var code = TextEditingController();

  DialogPayment() {
    this.btnController = RoundedLoadingButtonController();

    nom = StorageSrevice().onReadData('nom');
    prenom = StorageSrevice().onReadData('prenom');
    email = StorageSrevice().onReadData('email');
    telephone = StorageSrevice().onReadData('telephone');
    nbrPlace.text = ""; 
  }

  onDialogPayment(
      context, produitId, produitName, email, nom, prixPlace, nbr_place, categorie, duree_enchere) {
    final dialog = showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, Function setStateP) {
            return AlertDialog(
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
              insetPadding: EdgeInsets.all(5),
              title: Row(
                children: [
                  Text(AppLocalizations.of(context).componentPaiement_titre + " " + prixPlace + " €", style: TextStyle(fontSize:18, fontWeight: FontWeight.w700),),
                 Spacer(),
                 IconButton(icon: Icon(Icons.close, color: Colors.red,), onPressed: (){Navigator.pop(context);})
                ],
              ),
              titlePadding: EdgeInsets.symmetric(horizontal: 18, vertical: 24),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 60,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        autofocus: true,
                        controller: nbrPlace,
                        keyboardType: TextInputType.number,
                        textCapitalization: TextCapitalization.characters,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                         // contentPadding: EdgeInsets.only(bottom: 1, top: 22),
                          border: OutlineInputBorder(),
                          labelText: AppLocalizations.of(context).componentPaiement_nombrePlace,
                          labelStyle: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        autofocus: true,
                        controller: code,
                        keyboardType: TextInputType.text,
                        // textCapitalization: TextCapitalization.characters,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                         // contentPadding: EdgeInsets.only(bottom: 1, top: 22),
                          border: OutlineInputBorder(),
                          labelText: AppLocalizations.of(context).componentPaiement_codeVendeur,
                          labelStyle: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(height: 10),
                  // TextFormField(
                  //   readOnly: true,
                  //   controller: paysName,
                  //   keyboardType: TextInputType.text,
                  //   style: TextStyle(fontWeight: FontWeight.bold),
                  //   decoration: InputDecoration(
                  //       border: OutlineInputBorder(), labelText: AppLocalizations.of(context).inscription_pays),
                  //   obscureText: false,
                  //   onTap: () {
                  //     showCountryPicker(
                  //         context: context,
                  //         countryListTheme: CountryListThemeData(
                  //           flagSize: 25,
                  //           backgroundColor: Colors.white,
                  //           textStyle:
                  //               TextStyle(fontSize: 16, color: Colors.blueGrey),
                  //         ),
                  //         onSelect: (Country country) {
                  //           paysName.text = country.displayNameNoCountryCode.toString();
                  //           pays = country.countryCode.toString();
                  //           phoneCode.text = country.phoneCode.toString();
                  //         });
                  //   },
                  // ),
                  // SizedBox(height: 10),
                  //  TextFormField(
                  //   controller: phoneCode,
                  //   keyboardType: TextInputType.phone,
                  //   style: TextStyle(fontWeight: FontWeight.bold),
                  //   decoration: InputDecoration(
                  //       border: OutlineInputBorder(), labelText: AppLocalizations.of(context).inscription_telephone),
                  //   obscureText: false,
                  // ),

                  //    Padding(
                  //      padding: const EdgeInsets.all(18.0),
                  //      child: Text("Choisir votre mode de paiement.",  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey[600]),),
                  //    ),
                  

                  Visibility(
                    visible: codeCheck,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LinearProgressIndicator( backgroundColor: Colors.amber,),
                    ),
                  ),
                      
                      
                      Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                      InkWell( onTap: () async {
                          if (nbrPlace.text.isEmpty) {
                          CoolAlert.show(
                            context: context,
                            barrierDismissible: false,
                            confirmBtnColor: ThemeGeneral().color_Boutton,
                            type: CoolAlertType.warning,
                            title: AppLocalizations.of(context).componentPaiement_erreurTitre,
                            text: AppLocalizations.of(context).componentPaiement_erreurMessageInvalide,
                          );
                          return null;
                        } 
                          if (code.text.isEmpty) {
                          CoolAlert.show(
                            context: context,
                            barrierDismissible: false,
                            confirmBtnColor: ThemeGeneral().color_Boutton,
                            type: CoolAlertType.warning,
                            title: AppLocalizations.of(context).componentPaiement_erreurTitre,
                            text:  "Vendor code invalid" , // AppLocalizations.of(context).componentPaiement_erreurMessageInvalide,
                          );
                          return null;
                        }
                       if (int.parse(nbr_place)  < int.parse(nbrPlace.text)) {
                          CoolAlert.show(
                            context: context,
                            barrierDismissible: false,
                            confirmBtnColor: ThemeGeneral().color_Boutton,
                            type: CoolAlertType.warning,
                            title: AppLocalizations.of(context).componentPaiement_erreurTitre,
                            text: AppLocalizations.of(context).componentPaiement_erreurEleverMessage,
                                //"Nombre de place trop élévé. Il ne reste plus autant de places.",
                          );
                          return null;
                        }

                             setStateP((){codeCheck = true;});

                             Response<Map> response = await Dio().post(
                                      HttpRef().baseUrl +
                                          'utilisateurs/vendeur/verify/code',
                                      data: {
                                        "codeVendeur": code.text,
                                      });

                             setStateP((){codeCheck = false;});

                             if (response.data["statut"] == false)
                                    return CoolAlert.show(
                                      context: context,
                                      barrierDismissible: false,
                                      confirmBtnColor:
                                          ThemeGeneral().color_Boutton,
                                      type: CoolAlertType.error,
                                      title: "ERROR",  //AppLocalizations.of(context).connexion_erreurTilte,
                                      text:  "Vendor code invalid" ,  // AppLocalizations.of(context).connexion_erreurMessage,
                                    );


                            var nbrPlaces = int.parse(nbr_place);
                            var nbrPlacesAcheter = int.parse(nbrPlace.text);
                            var prix_Place =  double.parse(prixPlace);
                            var prix_total = nbrPlacesAcheter * prix_Place;
                            String codeVendeur = code.text;
                          
                             this._url = "https://luxury-reverse-auction-limited.firebaseapp.com/#/paypal_checkout/"+produitId+"/"+produitName.toString().trim().replaceAll(' ', '_')+"/"+categorie.toString().trim().replaceAll(' ', '_')+"/"+nbrPlaces.toString()+"/"+nbrPlacesAcheter.toString()+"/"+prix_Place.toString()+"/"+email+"/"+nom.toString().trim().replaceAll(' ', '_')+"/"+duree_enchere.toString()+"/"+codeVendeur;                    
                          // this._url = "https://luxury-reverse-auction-limited.firebaseapp.com/#/paypal_checkout/$produitId/$produitName/$categorie/$nbrPlaces/$nbrPlacesAcheter/$prix_Place/$email/$nom/$duree_enchere";                              
                         
                           _launchURL();
                           Navigator.of(context).pop();
                           Navigator.of(context).pop();

                          },
                            child: Card( color: Colors.grey[100],
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    SizedBox( width: 82, height: 40, child: Image.network("https://logo-marque.com/wp-content/uploads/2020/04/PayPal-Logo.png")),
                                   // Text("Paypal",  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                           
                        ],
                      ),

                        SizedBox(height: 20,)
                    ],
                  ),
                ),
              ),
              // actions: <Widget>[
              //   Padding(
              //     padding: const EdgeInsets.all(10.0),
              //     child: SizedBox(
              //       width: (MediaQuery.of(context).size.width / 3), height: 35,
              //       child: 
              //       RaisedButton(
              //           shape: RoundedRectangleBorder(
              //             borderRadius: new BorderRadius.circular(30.0),
              //           ),
              //           child: Text(AppLocalizations.of(context).componentPaiement_bouttonAnnuler),
              //           onPressed: () {

              //           Navigator.of(context).pop();
              //           // Navigator.push(
              //           //   context,
              //           //   MaterialPageRoute(
              //           //     builder: (context) => CardPaiementPage(),
              //           //   ),
              //           // );
              //           }),

              //         // GooglePayButton(
              //         //   paymentConfigurationAsset: 'gpay.json',
              //         //   paymentItems: paymentItems,
              //         //   style: GooglePayButtonStyle.black,
              //         //   type: GooglePayButtonType.pay,
              //         //   margin: const EdgeInsets.only(top: 15.0),
              //         //   onPaymentResult: onGooglePayResult,
              //         //   loadingIndicator: const Center(
              //         //     child: CircularProgressIndicator(),
              //         //   ),
              //         // ), 

              //     ),
              //   ),
              //   Padding(
              //     padding: const EdgeInsets.all(4.0),
              //     child: SizedBox(
                  
              //       child: RoundedLoadingButton(
              //         height: 35,
              //         width: MediaQuery.of(context).size.width / 3,
              //         color: ThemeGeneral().color_Boutton,
              //         successColor: Colors.green,
              //         child: Text(AppLocalizations.of(context).componentPaiement_bouttonAchetter,
              //             style: TextStyle(
              //                 color: ThemeGeneral().color_TextBoutton,
              //                 fontWeight: FontWeight.bold)),
              //         controller: btnController,
              //         onPressed: () async {


              //           //  this._url = "https://luxury-reverse-auction-limited.firebaseapp.com/#/paypal_checkout/$produitId/$produitName/$categorie/$nbrPlaces/$nbrPlacesAcheter/$prix_Place/$email/$nom/$duree_enchere";
                         
              //           //    _launchURL();

              //           //    Navigator.of(context).pop();
              //           //    Navigator.of(context).pop();

              //       ////////////////////////////////////// PACERELLE REALISTO /////////////////////////////// 
                  
                      
                    
                      









                    
                              
              //               // try {
              //               // print("IO OIO KI OKIO K IO K I O KK");
              //               // print(produitId + produitName + categorie + nom );        
                             
              //               //    var response = await Dio().post(HttpRef().baseUrl + "produits/achat/place", 
              //               //       data: {
              //               //       "produit_id": produitId,
              //               //       "nom_produit": produitName, 
              //               //       "categorie": categorie, 
              //               //       "nbr_place": int.parse(nbr_place), 
              //               //       "nbr_place_acheter": int.parse(nbrPlace.text),
              //               //       "prix_place": prixPlace,
              //               //       "email_utilisateur": email,
              //               //       "nom_utilisateur": nom,
              //               //       "duree_enchere": duree_enchere,
              //               //       // "paiement_id": result.paymentMethodNonce.nonce,
              //               //       });
              //               //            if (response.data["status"] == false){
              //               //              btnController.stop();
              //               //                CoolAlert.show(
              //               //                 context: context,
              //               //                 barrierDismissible: false,
              //               //                 confirmBtnColor:
              //               //                     ThemeGeneral().color_Boutton,
              //               //                 type: CoolAlertType.error,
              //               //                 title: AppLocalizations.of(context).componentPaiement_erreurTitre,
              //               //                 text: response.data["message"],
              //               //               );

              //               //            }
                                         

              //               //          if (response.data["status"] == true){
              //               //         btnController.success();
              //               //         Navigator.pop(context);
              //               //         Navigator.of(context).pop();
              //               //         print("User Added");
              //               //         CoolAlert.show(
              //               //           context: context,
              //               //           barrierDismissible: false,
              //               //           confirmBtnColor: ThemeGeneral().color_Boutton,
              //               //           type: CoolAlertType.success,
              //               //           title: AppLocalizations.of(context).componentPaiement_felicitationTitre,
              //               //           text:
              //               //               AppLocalizations.of(context).componentPaiement_felicitationMessage1 +  '  ${response.data["data"]["proposition_restante"]}  '  + AppLocalizations.of(context).componentPaiement_felicitationMessage2 ,
              //               //         );
                                        

              //               //       }
      
              //               //   print(response.data);
              //               //  return null;
              //               // } catch (e) {
              //               // print(e);
              //               //   CoolAlert.show(
              //               //                 context: context,
              //               //                 barrierDismissible: false,
              //               //                 confirmBtnColor:
              //               //                     ThemeGeneral().color_Boutton,
              //               //                 type: CoolAlertType.warning,
              //               //                 title:AppLocalizations.of(context).componentPaiement_erreurReseauTitre,
              //               //                 text: AppLocalizations.of(context).componentPaiement_erreurReseauMessage,
                                               
              //               //               );
              //               //   return null;
              //               // }

                      


              //           /////////////////////////////////////////////////////////////////////////////////////////////////

              //           // FirebaseReference()
              //           //     .firebaseRef
              //           //     .collection("PLACES_ACHETE")
              //           //     .add({
              //           //   "produit_id": produitId,
              //           //   "nom_produit": produitName, // John Doe
              //           //   "cetgorie": categorie, // Stokes and Sons
              //           //   "nbr_place": int.parse(nbrPlace.text),
              //           //   "prix_place": prixPlace,
              //           //   "email_utilisateur": email,
              //           //   "nom_utilisateur": nom,
              //           //   "proposition_restante": int.parse(nbrPlace.text) * 10,
              //           //   "date": DateTime.now(),
              //           // }).then((value) {
              //           //   btnController.success();
              //           //   Navigator.pop(context);
              //           //   Navigator.of(context).pop();
              //           //   print("User Added");
              //           //   CoolAlert.show(
              //           //     context: context,
              //           //     barrierDismissible: false,
              //           //     confirmBtnColor: ThemeGeneral().color_Boutton,
              //           //     type: CoolAlertType.success,
              //           //     title: "Félicitation !!!",
              //           //     text:
              //           //         "Nombre de place acheté avec succès sur la plate forme. Vonus avez droit à ${int.parse(nbrPlace.text) * 10} propositions.\nMerci de nous faire confiance.",
              //           //   );
              //           // }).catchError((error) {
              //           //   print(error);
              //           //   btnController.stop();
              //           //   CoolAlert.show(
              //           //     context: context,
              //           //     barrierDismissible: false,
              //           //     confirmBtnColor: ThemeGeneral().color_Boutton,
              //           //     type: CoolAlertType.error,
              //           //     title: "Erreur !!!",
              //           //     text:
              //           //         "Echec de la creation de compte. veuillez reprendre.",
              //           //   );
              //           // });
              //         },
              //       ),
              //     ),
              //   ),
              // ],
            );
          }
        );
      },
    );

    return dialog;
  }


 void _launchURL() async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

}
