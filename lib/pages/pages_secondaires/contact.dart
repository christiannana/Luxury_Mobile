import 'package:flutter/material.dart';
import 'package:luxury/parametres/themeGeneral.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactPage extends StatefulWidget {
  ContactPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
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
          title: Text(AppLocalizations.of(context).contact_titre),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 36, top: 20),
                    child: Text( AppLocalizations.of(context).contact_message,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                SizedBox( height: 50, width: 200,
                  child: ElevatedButton(
                    // color: ThemeGeneral().color_Boutton,
                    // textColor: ThemeGeneral().color_TextBoutton,
                    onPressed: () {
                      _launchURL("tel:+353892642587");
                    },
                    child: Text(AppLocalizations.of(context).contact_appel, style: TextStyle(fontWeight:FontWeight.w400, fontSize: 16),),
                  ),
                ),
          SizedBox(height:20),
                 SizedBox( height: 50, width: 200,
                  child: ElevatedButton(
                    // color: ThemeGeneral().color_Boutton,
                    // textColor: ThemeGeneral().color_TextBoutton,
                    onPressed: () {
                      _launchURL("mailto:luxuryreverseauctionlimited@gmail.com?subject=&body=");
                    },
                    child: Text(AppLocalizations.of(context).contact_email, style: TextStyle(fontWeight:FontWeight.w400, fontSize: 16),),
                  ),
                ),
           SizedBox(height:20),
                 SizedBox( height: 50, width: 200,
                  child: ElevatedButton(
                    // color: ThemeGeneral().color_Boutton,
                    // textColor: ThemeGeneral().color_TextBoutton,
                    onPressed: () {
                      _launchURL("sms:+353892642587");
                    },
                    child: Text(AppLocalizations.of(context).contact_sms, style: TextStyle(fontWeight:FontWeight.w400, fontSize: 16),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _launchURL(url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}
