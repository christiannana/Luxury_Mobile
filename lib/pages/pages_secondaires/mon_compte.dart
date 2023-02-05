import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:luxury/component/passwordChange.dart';
import 'package:luxury/parametres/themeGeneral.dart';
import 'package:luxury/services/http_Ref.dart';
import 'package:luxury/services/storage.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../component/compte_suppression.dart';
import '../../services/firebase_Reference.dart';
import '../connexion.dart';



class MonComptePage extends StatefulWidget {
  MonComptePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MonComptePageState createState() => _MonComptePageState();
}

class _MonComptePageState extends State<MonComptePage> {
  var nom = TextEditingController();
  var prenom = TextEditingController();
  var email = TextEditingController();
  var telephone = TextEditingController();
  String userId;

  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
 
  
 @override
  initState() {
    nom.text = StorageSrevice().onReadData('nom');
    prenom.text = StorageSrevice().onReadData('prenom');
    email.text = StorageSrevice().onReadData('email');
    telephone.text = StorageSrevice().onReadData('telephone');
    userId = StorageSrevice().onReadData('user_id');

    super.initState();
  }
   
  @override
  Widget build(BuildContext context) {
   
   
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
          title: Text(AppLocalizations.of(context).monCompte_titre),
          actions: [
             IconButton(
                icon: Icon(Icons.account_circle_outlined), 
                onPressed: () {
                  CompteSuppression().onCompteSuppression(context);
                }),

            IconButton(
                icon: Icon(Icons.lock_open_outlined), 
                onPressed: () {
                  PasswordChange().onPasswordChange(context);
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: SizedBox(
                      height: 120,
                      width: 110,
                      child: Stack(
                        children: [
                          Positioned(
                            right: -10,
                            bottom: 1,
                            child: IconButton(
                                icon: Icon(
                                  Icons.camera_enhance,
                                  size: 26,
                                  color: Colors.blueGrey[800],
                                ),
                                onPressed: () {}),
                          ),
                          Container(
                            height: 100,
                            width: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black54,
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  controller: nom,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: AppLocalizations.of(context).monCompte_nom),
                  obscureText: false,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: prenom,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: AppLocalizations.of(context).monCompte_prenom),
                  obscureText: false,
                ),
                SizedBox(height: 10),
                TextFormField(
                  readOnly: true,
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: AppLocalizations.of(context).monCompte_email),
                  obscureText: false,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: telephone,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: AppLocalizations.of(context).monCompte_telephone),
                  obscureText: false,
                ),
                SizedBox(height: 26),
                RoundedLoadingButton(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  color: ThemeGeneral().color_Boutton,
                  successColor: Colors.green,
                  child: Text(AppLocalizations.of(context).monCompte_enregistrerModification,
                      style: TextStyle(
                          color: ThemeGeneral().color_TextBoutton,
                          fontWeight: FontWeight.bold)),
                  controller: btnController,
                  onPressed: () async {
                    try {

                 FirebaseReference()
                            .firebaseRef
                            .collection("UTILISATEURS").doc(userId).update({
                              "nom": nom.text.toUpperCase(),
                              "prenom": prenom.text,
                              "telephone": telephone.text,
                              "statutCompte": "Déjà mise à jout une fois."
                            }).then((value) async {
                        
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
                          // title: "Félicitation !!!",
                          // text: "Votre mot de passe a été mit ajour. Vous devez vous reconnecter.",
                        );
                       })
                      .catchError((error){ 
                          btnController.stop();
                          CoolAlert.show(
                          context: context,
                          barrierDismissible: false,
                          confirmBtnColor: ThemeGeneral().color_Boutton,
                          type: CoolAlertType.error,
                          // title: "Félicitation !!!",
                          // text: "Votre mot de passe a été mit ajour. Vous devez vous reconnecter.",
                        ); 
                        },);

                     
                      var response = await Dio().get(HttpRef().baseUrl);
                      print(response.data);
                      return null;
                    } catch (e) {
                      btnController.stop();
                      print('wio XIOX WIOA RIOIOIOIOIOIO');
                      print(e);
                      return null;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
