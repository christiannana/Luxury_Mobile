import 'package:flutter/material.dart';
import 'package:luxury/parametres/themeGeneral.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AideCommentairePage extends StatefulWidget {
  AideCommentairePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _AideCommentairePageState createState() => _AideCommentairePageState();
}

class _AideCommentairePageState extends State<AideCommentairePage> {
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
          title: Text(AppLocalizations.of(context).aidesCommentaire_titre),
        ),
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [          
              onCardAide("Comment créer son compte ?"),
               onCardAide("Comment Authentifier son adresse mail  ?"),
                onCardAide("Comment acheter des places ?"),
                 onCardAide("Comment déposer une offre de prix ?"),
                  onCardAide("Comment comment changer de langue ?"),
                   onCardAide("Comment acheter plus de place ?"),
                    onCardAide("Comment nous contacter ?")
            ],
          ),
        )),
      ),
    );
  }

  Widget onCardAide(titre) {
    return Card(
      child: Container(
        height: 160,
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 14, top: 10),
              child: Text(titre, overflow: TextOverflow.clip, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text( "Le  psychique en toi ne coïncide pas avec ce dont tu es conscient ; ce sont deux choses différentes, que quelque sois informé des événements que quand ils se sont déjà accomplis et que tu ne peux plus rien y changer. Qui saurait",),
            ),
          ],
        ),
      ),
    );
  }
}
