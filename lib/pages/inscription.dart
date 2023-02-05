import 'package:flutter/material.dart';
import 'package:luxury/pages/authentification.dart';
import 'package:luxury/services/http_Ref.dart';
import '../parametres/themeGeneral.dart';
// import '../services/firebase_Reference.dart';
import 'package:country_picker/country_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:dio/dio.dart';

class InscriptionPage extends StatefulWidget {
  InscriptionPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _InscriptionPageState createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  var nom = TextEditingController();
  var prenom = TextEditingController();
  var email = TextEditingController();
  var adresse = TextEditingController();
  var pays = TextEditingController();
  var phone = TextEditingController();
  var password = TextEditingController();
  var confirPassword = TextEditingController();
  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();

  @override
  void initState() {}

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
          appBar: AppBar(
            backgroundColor: ThemeGeneral().color_AppBar,
            elevation: 2,
            title: Text(AppLocalizations.of(context).inscription_title),
          ),
          body: ListView(
            padding: EdgeInsets.all(15),
            children: [
              SizedBox(height: 15),
              TextFormField(
                controller: nom,
                textCapitalization: TextCapitalization.characters,
                keyboardType: TextInputType.text,
                style: TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: AppLocalizations.of(context).inscription_nom),
                obscureText: false,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: prenom,
                keyboardType: TextInputType.text,
                style: TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: AppLocalizations.of(context).inscription_prenom),
                obscureText: false,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: AppLocalizations.of(context).inscription_email),
                obscureText: false,
              ),
              SizedBox(height: 10),
              // TextFormField(
              //   controller: adresse,
              //   keyboardType: TextInputType.text,
              //   style: TextStyle(fontWeight: FontWeight.bold),
              //   decoration: InputDecoration(
              //       border: OutlineInputBorder(), labelText: AppLocalizations.of(context).inscription_adresse),
              //   obscureText: false,
              // ),
              SizedBox(height: 10),
              TextFormField(
                readOnly: true,
                controller: pays,
                keyboardType: TextInputType.text,
                style: TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: AppLocalizations.of(context).inscription_pays),
                onTap: () {
                  showCountryPicker(
                      context: context,
                      countryListTheme: CountryListThemeData(
                        flagSize: 25,
                        backgroundColor: Colors.white,
                        textStyle:
                            TextStyle(fontSize: 16, color: Colors.blueGrey),
                      ),
                      onSelect: (Country country) {
                        pays.text = country.displayNameNoCountryCode;
                        phone.text = '+' + country.phoneCode;
                      });
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: phone,
                keyboardType: TextInputType.phone,
                style: TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: AppLocalizations.of(context).inscription_telephone),
                obscureText: false,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: password,
                keyboardType: TextInputType.text,
                style: TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: AppLocalizations.of(context).inscription_motDePasse),
                obscureText: true,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: confirPassword,
                keyboardType: TextInputType.text,
                style: TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: AppLocalizations.of(context).inscription_confirmerMotPasse),
                obscureText: true,
              ),
              SizedBox(height: 15),
              RoundedLoadingButton(
                width: MediaQuery.of(context).size.width,
                color: ThemeGeneral().color_Boutton,
                successColor: Colors.green,
                child: Text(AppLocalizations.of(context).inscription_title,
                    style: TextStyle(
                        color: ThemeGeneral().color_TextBoutton,
                        fontWeight: FontWeight.bold)),
                controller: btnController,
                onPressed: () async {
                  if (nom.text == "" ||
                      prenom.text == "" ||
                      email.text == "" ||
                      // pays.text == "" ||
                      // phone.text == "" ||
                      password.text == "" ||
                      password.text != confirPassword.text) {
                    btnController.stop();
                    CoolAlert.show(
                      context: context,
                      barrierDismissible: false,
                      confirmBtnColor: ThemeGeneral().color_Boutton,
                      type: CoolAlertType.warning,
                      title: AppLocalizations.of(context).inscription_donneIncompletTitre,
                      text: AppLocalizations.of(context).inscription_donneIncompletMessage,
                    );
                    return null;
                  }
                  print("YES NANA OOOOOOOOHHHH");

                 
                 try {
                  Response<Map> response = await Dio()
                      .post(HttpRef().baseUrl + 'utilisateurs/create', data: {
                    "nom": nom.text,
                    "prenom": prenom.text,
                    "email": email.text,
                    "adresse": adresse.text,
                    "pays": pays.text,
                    "telephone": phone.text,
                    "password": password.text,
                  });

                  btnController.stop();

                  if (response.data["status"] == false)
                      return CoolAlert.show(
                      context: context,
                      barrierDismissible: false,
                      confirmBtnColor: ThemeGeneral().color_Boutton,
                      type: CoolAlertType.error,
                      title: "Erreur !!!",
                      text: response.data["message"],
                    );

                  if (response.data["status"] == true)
                  return onAuthenticate_Dialog();
                  print(response.data["status"]);
                          return null;
                        } catch (e) { 
                          btnController.stop(); 
                          CoolAlert.show(
                                        context: context,
                                        barrierDismissible: false,
                                        confirmBtnColor:
                                            ThemeGeneral().color_Boutton,
                                        type: CoolAlertType.warning,
                                        title: AppLocalizations.of(context).inscription_erreurReseautTitre,
                                        text:
                                            AppLocalizations.of(context).inscription_erreurReseauMessage,
                                      );
                          return null;
                        }


                  // FirebaseReference()
                  //     .firebaseRef
                  //     .collection("UTILISATEURS")
                  //     .add({
                  //   "nom": nom.text,
                  //   "prenom": prenom.text,
                  //   "email": email.text,
                  //   "adresse": adresse.text,
                  //   "pays": pays.text,
                  //   "telephone": phone.text,
                  //   "password": password.text,
                  //   "date": DateTime.now(),
                  // }).then((value) {
                  //   btnController.success();
                  //   Navigator.pop(context);
                  //   print("User Added");
                  //   CoolAlert.show(
                  //     context: context,
                  //     barrierDismissible: false,
                  //     confirmBtnColor: ThemeGeneral().color_Boutton,
                  //     type: CoolAlertType.success,
                  //     title: "Félicitation !!!",
                  //     text:
                  //         "Votre compte à bien été créer sur la plate forme. Merci de nous faire confiance.",
                  //   );
                  // }).catchError((error) {
                  //   print(error);
                  //   btnController.stop();
                  //   CoolAlert.show(
                  //     context: context,
                  //     barrierDismissible: false,
                  //     confirmBtnColor: ThemeGeneral().color_Boutton,
                  //     type: CoolAlertType.error,
                  //     title: "Erreur !!!",
                  //     text:
                  //         "Echec de la creation de compte. veuillez reprendre.",
                  //   );
                  // });
                },
              ),
              SizedBox(height: 10),
            ],
          ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     // Add your onPressed code here!
          //   },
          //   child: Icon(Icons.apps),
          //   backgroundColor: Colors.deepPurple,
          // ),
        ));
  }

  onAuthenticate_Dialog() {
    var alert = showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(15),
          title: Row(
            children: <Widget>[
              Text(AppLocalizations.of(context).inscription_authentification),
              Spacer(),
              Icon(
                Icons.done_all,
                size: 40,
                color: Colors.indigo,
              )
            ],
          ),
          content: Text(
            AppLocalizations.of(context).inscription_authentificationMessage,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 12),
          ),
          actions: <Widget>[
             Padding(
              padding: const EdgeInsets.only(
                top: 0,
                right: 12,
              ),
              child: ElevatedButton(
                // color: Colors.grey[200],
                // textColor: Colors.black,
                child: Text(AppLocalizations.of(context).inscription_felicitationPlutTard),
                onPressed: () {
                   Navigator.of(context).pop();
                   Navigator.of(context).pop();
                    CoolAlert.show(
                      context: context,
                      barrierDismissible: false,
                      confirmBtnColor: ThemeGeneral().color_Boutton,
                      type: CoolAlertType.success,
                      title: AppLocalizations.of(context).inscription_felicitation,
                      text:
                         AppLocalizations.of(context).inscription_felicitationMessage,
                    );
                  // storage.clear();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 0,
                right: 12,
              ),
              child: ElevatedButton(
                // color: Colors.amber,
                // textColor: Colors.black,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                child: Text(AppLocalizations.of(context).inscription_activerMaintenant),
                onPressed: () {
                   Navigator.of(context).pop();
                   Navigator.of(context).pop();
                   Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthentificationPage(),
                          settings:
                              RouteSettings(arguments: {"email":  email.text, "phone": phone.text, "password": password.text, "nom": nom.text, "prenom": prenom.text }),
                        ),
                      );
                },
              ),
            ),
          ],
        );
      },
    );
    return alert;
  }
}
