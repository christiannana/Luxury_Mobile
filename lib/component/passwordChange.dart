import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:luxury/pages/connexion.dart';
import 'package:luxury/parametres/themeGeneral.dart';
import 'package:luxury/services/http_Ref.dart';
import 'package:luxury/services/storage.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class PasswordChange {
  var ancienPassword = TextEditingController();
  var nouveauPassword = TextEditingController();

  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();

  onPasswordChange(context) {
    final dialog = showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[50],
          contentPadding: EdgeInsets.symmetric(horizontal: 7),
          insetPadding: EdgeInsets.all(20),
          title: Text(AppLocalizations.of(context).componentPasswordChange_titre, ),
          titlePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 80,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text( AppLocalizations.of(context).componentPasswordChange_message,
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 18),
                    TextFormField(
                      controller: ancienPassword,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: AppLocalizations.of(context).componentPasswordChange_ancienPass),
                      obscureText: false,
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: nouveauPassword,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: AppLocalizations.of(context).componentPasswordChange_nouveauPass),
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
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width / 4),
                    height: 35,
                    child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          shape: RoundedRectangleBorder( borderRadius: new BorderRadius.circular(30.0), ),
                        ),
                        child: Text(AppLocalizations.of(context).componentPasswordChange_bouttonAnnuler, style: TextStyle(color: Colors.black),),
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
                    if (ancienPassword.text == "" ||
                        nouveauPassword.text == "") {
                      btnController.stop();
                      CoolAlert.show(
                        context: context,
                        barrierDismissible: false,
                        confirmBtnColor: ThemeGeneral().color_Boutton,
                        type: CoolAlertType.warning,
                        title: "Erreur !!!",
                        text: "Mot de passe invalid.",
                      );
                      return null;
                    }

                    try {
                      print("ANNANA IOIKIOKIOKIO ");
                      var response = await Dio().post(
                          HttpRef().baseUrl + "utilisateurs/password/modify",
                          data: {
                            "email": StorageSrevice().onReadData("email"),
                            "ancien_pass": ancienPassword.text,
                            "nouveau_pass": nouveauPassword.text,
                          });

                      if (response.data["status"] == false) {
                        btnController.stop();
                        Navigator.of(context).pop();
                        CoolAlert.show(
                          context: context,
                          barrierDismissible: false,
                          confirmBtnColor: ThemeGeneral().color_Boutton,
                          type: CoolAlertType.error,
                          title: "Erreur !!!",
                          text: response.data["message"],
                        );
                      }

                      if (response.data["status"] == true) {
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
                          title: "Félicitation !!!",
                          text:
                              "Votre mot de passe a été mit ajour. Vous devez vous reconnecter.",
                        );
                      }
                      print(response.data);
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
