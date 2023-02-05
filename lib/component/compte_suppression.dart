

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:luxury/pages/connexion.dart';
import 'package:luxury/parametres/themeGeneral.dart';
import 'package:luxury/services/storage.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../services/firebase_Reference.dart';


class CompteSuppression {
  var email = TextEditingController();
  String userId = StorageSrevice().onReadData('user_id');
  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();

  onCompteSuppression(context) {
    final dialog = showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[50],
          contentPadding: EdgeInsets.symmetric(horizontal: 7),
          insetPadding: EdgeInsets.all(20),
          title: Text("Supprimer son Compte." ),
          titlePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 80,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text( "Attention vous etes sur le point de supprimer votre compte de la plateforme, NB: Cette action est irreversible, etes vous vraiment sur de vouloir le faire ?\nRenseigner votre email et valider.",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 18),
                    TextFormField(
                      controller: email,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Email"),
                      obscureText: false,
                    ),
                    SizedBox(height: 8),

                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width / 4),
                    height: 35,
                    child: ElevatedButton(           
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          shape: RoundedRectangleBorder( borderRadius: new BorderRadius.circular(30.0), ),
                        ),
                        child: Text(AppLocalizations.of(context).componentPasswordChange_bouttonAnnuler, style: TextStyle(color: Colors.black), ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ),
                ),

                  Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                child: RoundedLoadingButton(
                  height: 35,
                  width: MediaQuery.of(context).size.width / 4,
                  color: ThemeGeneral().color_Boutton,
                  successColor: Colors.green,
                  child: Text(AppLocalizations.of(context).componentPasswordChange_bouttonValider,
                      style: TextStyle(
                          color: ThemeGeneral().color_TextBoutton,
                          fontWeight: FontWeight.bold)),
                  controller: btnController,
                  onPressed: () async {
                    if (email.text == "" &&
                        email.text != StorageSrevice().onReadData("email") ) {
                      btnController.stop();
                      CoolAlert.show(
                        context: context,
                        barrierDismissible: false,
                        confirmBtnColor: ThemeGeneral().color_Boutton,
                        type: CoolAlertType.warning,
                        title: "Erreur !!!",
                        text: "votre email est invalid.",
                      );
                      return null;
                    }

                    try {
                   
                    // var utilisateurData = await FirebaseReference().firebaseRef.collection("UTILISATEURS").where("email", isEqualTo: email.text).get();

                    //    var dataId =   utilisateurData.docs.map((DocumentSnapshot document) {
                    //        String id = document.id; 
                    //        userId = id;
                    //        return id;
                    //      });
                    //  print(dataId); 

                      await FirebaseReference().firebaseRef.collection("UTILISATEURS").doc(userId).delete().then((value) async {

                           btnController.success();
                          Navigator.of(context).pop();
                         
                          final storage = await SharedPreferences.getInstance() ;
                          await  storage.remove("email");
                          StorageSrevice().onDeleteData("email");                     
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => ConnexionPage(),
                            ),
                            (route) => false,
                          );
                       
                        CoolAlert.show(
                          context: context,
                          barrierDismissible: false,
                          confirmBtnColor: ThemeGeneral().color_Boutton,
                          type: CoolAlertType.success,
                          title: "Compte supprimer !!!",
                          text:
                              "Vous avez supprimer avec succès votre compte sur la plateforme Luxury.",
                        );
                        
                      });

                      return null;
                    } catch (e) {
                      btnController.stop();
                      CoolAlert.show(
                        context: context,
                        barrierDismissible: false,
                        confirmBtnColor: ThemeGeneral().color_Boutton,
                        type: CoolAlertType.warning,
                        title: "Erreur réseau !",
                        text: "Vérifier votre connxion internet.",
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



 /////////////////////////////////  FONCTION POUR SUPPRIMER SON COMPTE  ///////////////////////////////////





}
