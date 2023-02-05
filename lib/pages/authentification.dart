
import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:luxury/parametres/themeGeneral.dart';
import 'package:luxury/services/http_Ref.dart';
import 'package:luxury/services/storage.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'menu_principale.dart';

class AuthentificationPage extends StatefulWidget {
  AuthentificationPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AuthentificationPageState createState() => _AuthentificationPageState();
}

class _AuthentificationPageState extends State<AuthentificationPage> {
  var code = TextEditingController();
  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    Map data_route = ModalRoute.of(context).settings.arguments;

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
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.close,
              color: Colors.black87,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.grey[100],
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 30),
              child: Text(
                AppLocalizations.of(context).activation_title,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                AppLocalizations.of(context).activation_message1 +
                    data_route["email"] +
                    AppLocalizations.of(context).activation_message2,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                controller: code,
                keyboardType: TextInputType.text,
                style: TextStyle(fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText:  AppLocalizations.of(context).activation_codeSecret,),
                obscureText: false,
              ),
            ),
            RoundedLoadingButton(
                width: MediaQuery.of(context).size.width,
                color: ThemeGeneral().color_Boutton,
                successColor: Colors.green,
                child: Text('Activer mon compte',
                    style: TextStyle(
                        color: ThemeGeneral().color_TextBoutton,
                        fontWeight: FontWeight.bold)),
                controller: btnController,
                onPressed: () async {
                  if (code.text == "") {
                    btnController.stop();
                    CoolAlert.show(
                      context: context,
                      barrierDismissible: false,
                      confirmBtnColor: ThemeGeneral().color_Boutton,
                      type: CoolAlertType.warning,
                      title:  AppLocalizations.of(context).activation_codeIncompletTile,
                      text:  AppLocalizations.of(context).activation_codeIncompletMessage,
                    );
                    return null;
                  }

                  Response<Map> response = await Dio().post(
                      HttpRef().baseUrl + 'utilisateurs/code_activation',
                      data: {
                        "email": data_route["email"],
                        "password": data_route["password"],
                        "telephone": data_route["phone"],
                        "code": code.text,
                      });
                  print("YES NANA OOOOOOOOHHHH");
                  btnController.stop();
                  if (response.data["status"] == false) {
                    CoolAlert.show(
                      context: context,
                      barrierDismissible: false,
                      confirmBtnColor: ThemeGeneral().color_Boutton,
                      type: CoolAlertType.warning,
                      title:  AppLocalizations.of(context).activation_erreurCode,
                      text:  AppLocalizations.of(context).activation_erreurCodeInvalide,
                    );
                    return null;
                  }

                  if (response.data["status"] == true) {
                  
                                     StorageSrevice().onSaveData("nom", data_route["nom"]);
                                     StorageSrevice().onSaveData("prenom", data_route["prenom"]);
                                     StorageSrevice().onSaveData("email", data_route["email"]);
                                     StorageSrevice().onSaveData("telephone", data_route["phone"]);
                                      Navigator.pop(context); 
                                     Timer(Duration(seconds: 1), (){
                                       Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MenuPage(), 
                                        ),
                                      ); 
                                     });
                    CoolAlert.show(
                      context: context,
                      barrierDismissible: false,
                      confirmBtnColor: ThemeGeneral().color_Boutton,
                      type: CoolAlertType.success,
                      title:  AppLocalizations.of(context).activation_felicitationTilte,
                      text:  AppLocalizations.of(context).activation_felicitationMessage,
                    );
                    return null;
                  }

                  if (0 == 1)
                    return CoolAlert.show(
                      context: context,
                      barrierDismissible: false,
                      confirmBtnColor: ThemeGeneral().color_Boutton,
                      type: CoolAlertType.warning,
                      title:  AppLocalizations.of(context).activation_erreurCodeInvalide,
                      text:  AppLocalizations.of(context).activation_erreurCodeMessageInconnue,
                    );
                }),
            Padding(
              padding: const EdgeInsets.only(top: 38.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                     AppLocalizations.of(context).activation_codeNonRecu,
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 13,
                        color: Colors.black54),
                  ),
                  TextButton(
                    // textColor: Colors.white,
                    child: Text(
                       AppLocalizations.of(context).activation_codeRenvoyer,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.indigo,
                          decoration: TextDecoration.underline),
                    ),
                    onPressed: () async {
                     
                      setState(() {
                         visible = true;
                      });
                     Response<Map> response = await Dio().post(
                      HttpRef().baseUrl + 'utilisateurs/code_renvoyer',
                      data: {
                        "email": data_route["email"],
                        "password": data_route["password"],
                        "telephone": data_route["phone"],
                      });
                     setState(() {
                         visible = false;
                      });
                      if(response.data["status"] == false) return  CoolAlert.show(
                      context: context,
                      barrierDismissible: false,
                      confirmBtnColor: ThemeGeneral().color_Boutton,
                      type: CoolAlertType.info,
                      title:  AppLocalizations.of(context).activation_erreurCode,
                      text:  AppLocalizations.of(context).activation_adresseMailInconnu,
                    );
                   if(response.data["status"] == true) return  CoolAlert.show(
                      context: context,
                      barrierDismissible: false,
                      confirmBtnColor: ThemeGeneral().color_Boutton,
                      type: CoolAlertType.info,
                      title:  AppLocalizations.of(context).activation_nouveauCodeTitle,
                      text:  AppLocalizations.of(context).activation_nouveauCodeMessage + data_route["email"],
                    );

                    },
                  ),

   

                ],
              ),
            ),
          Visibility(visible: visible, child: LinearProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
