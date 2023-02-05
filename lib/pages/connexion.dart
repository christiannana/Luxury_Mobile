import 'dart:async';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:luxury/component/passwwordRecovry_dialog.dart';

import 'package:luxury/services/http_Ref.dart';
import 'package:luxury/services/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../parametres/themeGeneral.dart';


import '../pages/menu_principale.dart';
import 'authentification.dart';
import 'inscription.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConnexionPage extends StatefulWidget {
  ConnexionPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _ConnexionPageState createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  var password = TextEditingController();
  var email = TextEditingController();
  bool visible = true;
  var phone = TextEditingController();

   final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
  
  final _formKey = GlobalKey<FormState>();
  String titre = 'Luxury';

  onEmailInit()async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    return email.text = prefs.getString("email");
    
  }
    
  @override
  initState(){
   onEmailInit();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
   return  GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          body: Container(
            alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromRGBO(30, 40, 49, 1),
                 image: DecorationImage(
                   image: NetworkImage(
                      'https://images.unsplash.com/flagged/photo-1569430044663-054ffc0c50c5?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MjF8fHxlbnwwfHx8&auto=format&fit=crop&w=400&q=60'),
                  fit: BoxFit.cover,
                  
                  colorFilter: ColorFilter.mode(
                 Colors.black.withOpacity(0.6), BlendMode.darken)),
              // gradient: LinearGradient(
              //     begin: Alignment.topRight,
              //     end: Alignment.bottomLeft,
              //     colors: [Colors.amber, Colors.black]),
            ),
            //  margin: EdgeInsets.only(top:0,right:0,left:0),

            child: SingleChildScrollView(
              child: Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    titre,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 35),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      margin: EdgeInsets.all(0),
                      elevation: 5,
                      child: Form(
                        //  autovalidate: true,
                        key: _formKey,
                        child: ListView(shrinkWrap: true,
                            //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    right: 10, left: 10, bottom: 3),
                                child: TextFormField(
                                  validator: (value) {
                                    // var potentialNumber = int.tryParse(value);
                                    if (value.isEmpty ||
                                        value.length < 9 ||
                                        value.length > 13) {
                                      return 'Téléphone incorrect';
                                    }
                                  },
                                  controller: email,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                    labelStyle:
                                        TextStyle(fontStyle: FontStyle.italic),
                                    border: OutlineInputBorder(),
                                    labelText: AppLocalizations.of(context).connexion_email,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(),
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    // var potentialNumber = int.tryParse(value);
                                    if (value.isEmpty ||
                                        value.length < 6 ||
                                        value.length > 7) {
                                      return 'Mot de passe invalid';
                                    }
                                  },
                                  controller: password,
                                  obscureText: visible,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                    labelStyle:
                                        TextStyle(fontStyle: FontStyle.italic),
                                    suffixIcon: IconButton(
                                        icon: Icon(Icons.visibility_off),
                                        onPressed: () {
                                          if (visible == true) {
                                            visible = false;
                                            setState(() {});
                                          } else {
                                            visible = true;
                                            setState(() {});
                                          }
                                        }),
                                    border: OutlineInputBorder(),
                                    labelText: AppLocalizations.of(context).connexion_mdp,
                                  ),
                                ),
                              ),
                              // SizedBox(height:10),

                              Container(
                                height: 45,
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: RoundedLoadingButton(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width,
                                  color: ThemeGeneral().color_Boutton,
                                  successColor: Colors.green,
                                  child: Text(AppLocalizations.of(context).connexion_seConneceter,
                                      style: TextStyle(
                                          color:
                                              ThemeGeneral().color_TextBoutton,
                                          fontWeight: FontWeight.bold)),
                                  controller: btnController,
                                  onPressed: () async {

                                    print(  StorageSrevice().onReadData("email") );

                                    FocusScopeNode currentFocus = 
                                        FocusScope.of(context);
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }

                                    if (email.text == "" ||
                                        password.text == "") {
                                      btnController.stop();
                                      CoolAlert.show(
                                        context: context,
                                        barrierDismissible: false,
                                        confirmBtnColor:
                                            ThemeGeneral().color_Boutton,
                                        type: CoolAlertType.warning,
                                        title:  AppLocalizations.of(context).connexion_donneeIncomplet,
                                        text:  AppLocalizations.of(context).connexion_donneeIncompletMessage                                           
                                      );
                                      return null;
                                    }


                               try {
                                   if (email.text == "" ||
                                        password.text == "") {
                                      btnController.stop();
                                      CoolAlert.show(
                                        context: context,
                                        barrierDismissible: false,
                                        confirmBtnColor:
                                            ThemeGeneral().color_Boutton,
                                        type: CoolAlertType.warning,
                                        title:  AppLocalizations.of(context).connexion_donneeIncomplet,
                                        text:  AppLocalizations.of(context).connexion_donneeIncompletMessage,
                                      );
                                      return null;
                                    }

                                    Response<Map> response = await Dio().post(
                                        HttpRef().baseUrl +
                                            'utilisateurs/login',
                                        data: {
                                          "email": email.text,
                                          "password": password.text,
                                        });

                                    print(response.data);
                                    btnController.stop();
                                    if (response.data["status"] == false)
                                      return CoolAlert.show(
                                        context: context,
                                      barrierDismissible: false,
                                        confirmBtnColor:
                                            ThemeGeneral().color_Boutton,
                                        type: CoolAlertType.error,
                                        title: AppLocalizations.of(context).connexion_erreurTilte,
                                        text: AppLocalizations.of(context).connexion_erreurMessage,
                                      );
                                    if (response.data["data"]["authenticate"] != "validate") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AuthentificationPage(),
                                          settings: RouteSettings(arguments: {
                                            "email": email.text,
                                            "phone": response.data["data"]["telephone"],
                                            "password": password.text,
                                            "nom": response.data["data"]["nom"],
                                            "prenom": response.data["data"]["prenom"]
                                          }),
                                        ),
                                      ); 
                                       password.text = ""; 
                                    }

                                    if (response.data["data"]["authenticate"] == "validate") {
                                       final storage = await SharedPreferences.getInstance() ;
                                       await  storage.setString("email", response.data["data"]["email"]);

                                     StorageSrevice().onSaveData("nom", response.data["data"]["nom"] == null ? "0" : response.data["data"]["nom"] );
                                     StorageSrevice().onSaveData("prenom", response.data["data"]["prenom"] == null ? "0" :  response.data["data"]["prenom"]);
                                     StorageSrevice().onSaveData("email", response.data["data"]["email"]);
                                     StorageSrevice().onSaveData("telephone", response.data["data"]["telephone"] == null ? "0" : response.data["data"]["telephone"] );
                                     StorageSrevice().onSaveData("user_id", response.data["data"]["id"]);
                                     
                                  Timer(Duration(seconds: 1), (){
                                             
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => MenuPage(),
                                    ),
                                    (route) => false,
                                  );
                              });
                                     
                                      password.text = "";                                 
                                    }
                          return null;
                         } catch (e) {
                           btnController.stop();
                           CoolAlert.show(
                                        context: context,
                                        barrierDismissible: false,
                                        confirmBtnColor:
                                            ThemeGeneral().color_Boutton,
                                        type: CoolAlertType.warning,
                                        title: AppLocalizations.of(context).connexion_erreurTilte,
                                        text: AppLocalizations.of(context).connexion_erreurMessage,
                                            // "Vérifier votre connxion internet.",
                                      );
                          return null;
                          
                         }


                                    // FirebaseReference()
                                    //     .firebaseRef
                                    //     .collection("UTILISATEURS")
                                    //     .where("email", isEqualTo: email.text)
                                    //     .where("password",
                                    //         isEqualTo: password.text)
                                    //     .get()
                                    //     .then((value) async {
                                    //   btnController.stop();
                                    //   if (value.size > 0) {
                                    //     password.text = "";
                                    //     Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //           builder: (context) => MenuPage()),
                                    //     );
                                    //   } else {
                                    //     CoolAlert.show(
                                    //       context: context,
                                    //       barrierDismissible: false,
                                    //       confirmBtnColor:
                                    //           ThemeGeneral().color_Boutton,
                                    //       type: CoolAlertType.error,
                                    //       title: "Compte introuvable.",
                                    //       text:
                                    //           "Votre login ou mot de passe est incorrete.",
                                    //     );
                                    //   }
                                    //   print(value.size);
                                    // }).catchError((error) {
                                    //   print(error);
                                    //   btnController.stop();
                                    // });
                                  },
                                ),
                              ),

                             TextButton(
                               
                                child: Text(AppLocalizations.of(context).connexion_mdpOublier,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.deepPurple)),
                                onPressed: () {
                                  // ServicePopUp().onAlerteSucces(
                                  //   context,
                                  //   'Information',
                                  //   'Module en cours de developpement, Veuillez patienter.',
                                  //   'Compris',
                                  // );
                                 
                                 PasswordRecovry().onPasswordForget(context);
                                },
                              ),
                            ]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).connexion_nouveau,
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 15,
                              color: Colors.white),
                        ),
                        TextButton(
                          // textColor: Colors.white,
                          child: Text(
                            AppLocalizations.of(context).connexion_inscription,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.amber,
                                decoration: TextDecoration.underline),
                          ),
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InscriptionPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

}
