

import 'package:flutter/material.dart';
import 'package:luxury/pages/connexion.dart';
import 'package:luxury/parametres/themeGeneral.dart';
import 'package:luxury/services/storage.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class ServicePopUp {
  
  
  ////////////////////////////////  GESTION DES COULEUR  //////////////////////////////////
  final primary = Colors.amber;
  final secondary = Colors.deepPurple;
  final btnText = Colors.black;
  final text = Colors.black;
  /////////////////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////  GESTION DE LA DATE  /////////////////////////////////


  /////////////////////////////  GESTION DES IMAGES EN LIGNE ///////////////////////////////

 

  ////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////  GESTION DES SONGS //////////////////////////////

  

////////////////////////////////////////////////////////////////////////////////

  // onSnacbar(BuildContext context, message) {
  //   return Scaffold.of(context).showSnackBar(SnackBar(
  //     content: Text(message),
  //     backgroundColor: Colors.blue,
  //     elevation: 15,
  //   ));
  // }

 
  onDeconnction(context) {
    final dialog = showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[50],
          contentPadding: EdgeInsets.symmetric(horizontal: 7),
          insetPadding: EdgeInsets.all(20),
          title: Text(AppLocalizations.of(context).componentDeconnexion_title,    
          ),
          titlePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 80,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                 Text(AppLocalizations.of(context).componentDeconnexion_message,
            style: TextStyle(fontSize: 14),
          ),
                           
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
           Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: (MediaQuery.of(context).size.width / 3), height: 35,
                child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          shape: RoundedRectangleBorder( borderRadius: new BorderRadius.circular(30.0), ),
                        ),
                    child: Text(AppLocalizations.of(context).componentDeconnexion_Annuler, style: TextStyle(color: Colors.black),),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
              
                child: SizedBox(
                width: (MediaQuery.of(context).size.width / 3), height: 35,
                child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder( borderRadius: new BorderRadius.circular(30.0), ),
                ),

                    child: Text(AppLocalizations.of(context).componentDeconnexion_valider),
                    onPressed: () async {
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
                    }),
              ),
              ),
            ),
          ],
        );
      },
    );

    return dialog;
  }

    


 

  onAlerteSucces(context, titre, message, btntext) {
    // AwesomeDialog(
    //         aligment: Alignment.center,
    //         dismissOnTouchOutside: false,
    //         context: alert,
    //         dialogType: DialogType.SUCCES,
    //         headerAnimationLoop: false,
    //         animType: AnimType.TOPSLIDE,
    //         title: titre,
    //         btnOkColor: primary,
    //         isDense: true,
    //         desc: message,
    //         btnOkText: btntext,
    //         btnOkOnPress: () {
    //          // AwesomeDialog(context: null).dissmiss();
    //          Navigator.pop(alert);
    //         })
    //     .show();

    var alert = showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(15),
          title: Row(
            children: <Widget>[
              Text(titre),
              Spacer(),
              Icon(
                Icons.done_all,
                size: 40,
                color: Colors.indigo,
              )
            ],
          ),
          content: Text(
            message,
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
                style: ElevatedButton.styleFrom(),
                // color: Colors.amber,
                // textColor: Colors.black,
                child: Text('Compris'),
                onPressed: () {
                  Navigator.of(context).pop();
                  // storage.clear();
                },
              ),
            ),
          ],
        );
      },
    );
    return alert;
  }

 

  onAlerteInfo1(context, titre, message) {
    var alert = showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titre),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  message,
                  textAlign: TextAlign.left,
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.characters,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Nom'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  textCapitalization: TextCapitalization.characters,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Nom'),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Compris'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return alert;
  }

 

  onAlerteWarning(
    context,
    titre,
    message,
    btntext,
   // {onSeconde()}
  ) {
    var alert = showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(15),
          title: Row(
            children: <Widget>[
              Text(
                titre,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              Icon(
                Icons.report_problem,
                size: 40,
                color: Colors.amber,
              )
            ],
          ),
          content: Text(
            message,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 14),
          ),
          actions: <Widget>[
            Column(
              children: <Widget>[
                 SizedBox(
                    width: MediaQuery.of(context).size.width-20,
                    child:ElevatedButton(
                     style: ElevatedButton.styleFrom(),
                      // shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
                      // color: Colors.blue,
                      // textColor: Colors.white,
                      child: Text('Mettre a jour son compte'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        // storage.clear();
                      },
                    ),
                  ),
                // Padding(
                //   padding: const EdgeInsets.only(
                //     top: 0,
                //     right: 12,
                //   ),
                //   child: SizedBox(
                //     width: 100,
                //     child: RaisedButton(
                //       shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
                //       color: Colors.amber,
                //       child: Text(btntext),
                //       onPressed: () {
                //         Navigator.of(context).pop();
                //         // storage.clear();
                //       },
                //     ),
                //   ),
                // ),
              ],
            ),
          
          ],
        );
      },
    );
    return alert;
  }



  
  onAlerteInfoLoading(context) {
    var alert = showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(height: 100,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SizedBox(width: 40,height: 40,child: CircularProgressIndicator()),
                  ),
                  Text("Veuillez patienter.",textAlign: TextAlign.center,),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
    return alert;
  }
  
}
 