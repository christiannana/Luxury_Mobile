

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ParametresPage extends StatefulWidget {
  ParametresPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _ParametresPageState createState() => _ParametresPageState();
}

class _ParametresPageState extends State<ParametresPage> {
  String _url = "https://play.google.com/store/apps/details?id=com.luxury.app2021";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Version obselette'),
        backgroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
           Text("Cette application n'est plus à jour, pour continuer à la utiliser, vous devez la mettre à jour. \n La mise à jour ne modifie pas les données de votre compte."),
         
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: ElevatedButton(onPressed: (){
                       this._url = "https://play.google.com/store/apps/details?id=com.luxury.app2021";                    
                       _launchURL();
            }, child: Text("Mettre à jour l'application"),),
          )
          ],
        ),
      )
    );
  }

    void _launchURL() async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

}
