


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'pages/connexion.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/menu_principale.dart';
import 'services/storage.dart';

class AppStartPage extends StatefulWidget {
  AppStartPage({Key key}) : super(key: key);
  @override
  AppStartPageState createState() => AppStartPageState();
}

class AppStartPageState extends State<AppStartPage> {

  
  void navigationPage() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String email = prefs.getString("email");

    if (email != null) {
    StorageSrevice().onReadData("email");
    StorageSrevice().onReadData("email");  
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => MenuPage()),
        ); 
    }

    print(email);
  }

  @override
  void initState() {
    super.initState();
    // navigationPage();
  }

  @override
  Widget build(BuildContext context) {

  List<PageViewModel> listPagesViewModel = <PageViewModel>[
    PageViewModel(
      title: "Des voitures de luxe.",
      bodyWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Participer aux enchères et remporter des voitures de luxe toutes marques confondues en proposant le prix unique le plus bas possible.",
            textAlign: TextAlign.center,
          ),
          // Icon(Icons.edit),
          // Text(" to edit a post"),
        ],
      ),
      // footer: ElevatedButton(
      //   onPressed: () {
      //    DialogInfo().onDialogInfo(context, "Freelancers.");
      //   },
      //   child: const Text("En savoir plus"),
      // ),
      image: Container(
        width: 230.0,
        height: 230.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: Colors.indigo, width: 10.0, style: BorderStyle.solid),
          image: new DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  "https://images.unsplash.com/photo-1503376780353-7e6692767b70?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80"),),
        ),
      ),
    ),
    PageViewModel(
      title: "Des maisons de luxe",
      bodyWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Gagner des villas et des maisons de luxe Avec le même principe vous allez découvrir les détails de chaque produit à l'intérieur de l'application..",
            textAlign: TextAlign.center,
          ),
          // Icon(Icons.edit),
          // Text(" to edit a post"),
        ],
      ),
      // footer: ElevatedButton(
      //   onPressed: () {
      //      DialogInfo().onDialogInfo(context, "Entreprises.");
      //   },
      //   child: const Text("En savoir plus"),
      // ),
      image: Container(
        width: 230.0,
        height: 230.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: Colors.indigo, width: 10.0, style: BorderStyle.solid),
          image: new DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage("https://images.unsplash.com/photo-1583608205776-bfd35f0d9f83?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80"),
                  
          ),
        ),
      ),
    ),
    PageViewModel(
      title: "Luxury reverse",
      bodyWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Gagner des maisons et des voitures de luxe en vous amusant, le principe est très simple.\nIl vous suffit de proposer pour chaque produit le prix unique le plus bas possible. \n\nPour commencer, créez votre compte sur l'application. Ce compte sera automatiquement crédité de 300 offres sur un produit choisir aléatoirement. \n L'enchère' commence lorsque le nombre total de place sur un produit est complètement vendus, Vous allez recevoir une notification qui vous informe sur l'ouverture le l’enchères.",
            textAlign: TextAlign.justify,
          ),
          // Icon(Icons.edit),
          // Text(" to edit a post"),
        ],
      ),
      image: Container(
        width: 230.0,
        height: 230.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all( 
            color: Colors.indigo, width: 10.0, style: BorderStyle.solid),
            image: new DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(
                  "https://luxuryreverseauctionlimited.com/img/logo.png"),),
        ),
      ),
    ),
  ];






    return Scaffold(
      body: IntroductionScreen(    
        pages: listPagesViewModel,
        onDone: () {
          // When done button is press
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ConnexionPage(),
            ),
            (route) => false,
          );
        },
        onSkip: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ConnexionPage(),
            ),
            (route) => false,
          );
          //  Navigator.pushNamed(context, '/menu_principal');
        },
              
        showSkipButton: true,
        skip: const Icon(Icons.skip_next),
        next: const Icon(Icons.forward),
        done: const Text("Continuer",
            style: TextStyle(fontWeight: FontWeight.w600)),
        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),),),
      ),
    );
  }
}










// import 'package:flutter/material.dart';

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//   final String title;
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(),
//     );
//   }
// }
