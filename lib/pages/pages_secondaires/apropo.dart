import 'package:flutter/material.dart';
import 'package:luxury/parametres/themeGeneral.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AproposPage extends StatefulWidget {
  AproposPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _AproposPageState createState() => _AproposPageState();
}

class _AproposPageState extends State<AproposPage> {
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
          title: Text(AppLocalizations.of(context).apropos_titre),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Text(
                    "Luxury LTD",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Text(AppLocalizations.of(context).apropos_message)
            ],
          ),
        )),
      ),
    );
  }
}
