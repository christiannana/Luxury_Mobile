
import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:luxury/parametres/themeGeneral.dart';
import 'package:luxury/services/http_Ref.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class PasswordRecovry {
   var email = TextEditingController();
   final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();

   onPasswordForget(context){
    final dialog = showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[50],
          contentPadding: EdgeInsets.symmetric(horizontal: 7),
          insetPadding: EdgeInsets.all(20),
          title: Text(AppLocalizations.of(context).componentPasswordRecovry_titre,
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
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: AppLocalizations.of(context).componentPasswordRecovry_email ),
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
                    width: (MediaQuery.of(context).size.width / 3), height: 35,
                    child: ElevatedButton(
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: new BorderRadius.circular(30.0),
                      // ),
                      style: ElevatedButton.styleFrom(),
                        child: Text(AppLocalizations.of(context).componentPasswordRecovry_bouttonAnnuler),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ),
                ),

                 Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
              
                child: RoundedLoadingButton(
                  height: 35,
                  width: MediaQuery.of(context).size.width / 3,
                  color: ThemeGeneral().color_Boutton,
                  successColor: Colors.green,
                  child: Text(AppLocalizations.of(context).componentPasswordRecovry_bouttonValider,
                      style: TextStyle(
                          color: ThemeGeneral().color_TextBoutton,
                          fontWeight: FontWeight.bold)),
                  controller: btnController,
                  onPressed: () async {
                    
                    if (email.text == "") {
                      btnController.stop();
                      CoolAlert.show(
                        context: context,
                        barrierDismissible: false,
                        confirmBtnColor: ThemeGeneral().color_Boutton,
                        type: CoolAlertType.warning,
                        title: AppLocalizations.of(context).componentPasswordRecovry_erreur,
                        text: AppLocalizations.of(context).componentPasswordRecovry_emailInvalide
                           
                      );
                      return null;
                    }
                 
                      try {
                         print("ANNANA IOIKIOKIOKIO ");
                          var response = await Dio().post(HttpRef().baseUrl + "utilisateurs/password/recovry", 
                              data: {"email": email.text,  });

                                   if (response.data["status"] == false){
                                     btnController.stop();
                                       CoolAlert.show(
                                        context: context,
                                        barrierDismissible: false,
                                        confirmBtnColor:
                                            ThemeGeneral().color_Boutton,
                                        type: CoolAlertType.error,
                                        title: AppLocalizations.of(context).componentPasswordRecovry_erreur,
                                        text: response.data["message"],
                                      );

                                   }
                                     

                                if (response.data["status"] == true){
                                btnController.success();
                                Navigator.of(context).pop();
                                print("User Added");
                                CoolAlert.show(
                                  context: context,
                                  barrierDismissible: false,
                                  confirmBtnColor: ThemeGeneral().color_Boutton,
                                  type: CoolAlertType.success,
                                  title: AppLocalizations.of(context).componentPasswordRecovry_felicitationTitle,
                                  text: AppLocalizations.of(context).componentPasswordRecovry_felicitationmessage,);
                                    

                                   }  
                          print(response.data);
                          return null;
                        } catch (e) {
                            btnController.stop();
                          CoolAlert.show(
                                        context: context,
                                        barrierDismissible: false,
                                        confirmBtnColor:
                                            ThemeGeneral().color_Boutton,
                                        type: CoolAlertType.warning,
                                        title: "Erreur réseau !",
                                        text:
                                            "Vérifier votre connxion internet.",
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
 
}