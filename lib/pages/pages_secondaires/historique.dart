


import 'package:flutter/material.dart';
import 'package:luxury/parametres/themeGeneral.dart';

class HistoriquePage extends StatefulWidget {
  HistoriquePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HistoriquePageState createState() => _HistoriquePageState();
}

class _HistoriquePageState extends State<HistoriquePage> {
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
          title: Text("Historique d'activité"),
        ),
        backgroundColor: Colors.white,
        body: Center(child: Text("Aucune activité enregistrée...")),
      ),
    );
  }
}
