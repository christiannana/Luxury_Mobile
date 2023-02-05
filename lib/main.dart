import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:localstorage/localstorage.dart';

import 'package:luxury/pages/menu_principale.dart';
import 'package:luxury/services/storage.dart';

import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';

import 'introPage.dart';




// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Luxury',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({
//     Key key,
//   }) : super(key: key);
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   bool _initialized = false;
//   bool _error = false;
//   dynamic  emailData;

//   // Define an async function to initialize FlutterFire
//   void initializeFlutterFire() async {
//     try {
//       // emailData = StorageSrevice().onReadData("email");
//       // Wait for Firebase to initialize and set `_initialized` state to true
//       await Firebase.initializeApp();
//       setState(() {
//         emailData = StorageSrevice().onReadData("email");
//         _initialized = true;
//           print(emailData);
//       });

//     } catch (e) {
//       // Set `_error` state to true if Firebase initialization fails
//       setState(() {
//         _error = true;
//       });
//     }
//   }

//   @override
//   void initState() {
//     initializeFlutterFire();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // LocalStorage storage =  LocalStorage('luxury_db');
//     // var emailData =  StorageSrevice().onReadData('email');
//     // Show error message if initialization failed
//     if (_error) {
//       return Text("Echec initialisation");
//     }

//     // Show a loader until FlutterFire is initialized
//     if (!_initialized) {
//        return Container(color: Colors.white, child: Center(child: Text("Initialisation en cours...",style: TextStyle(fontSize:10  ),)));
//     }

//     if(StorageSrevice().onReadData("email") == null) return ConnexionPage();
//     if(StorageSrevice().onReadData("email") != null) return MenuPage();

//     //  Scaffold(
//     //   body: Center(),
//     //   floatingActionButton: FloatingActionButton(
//     //     onPressed: () {},
//     //     tooltip: 'Increment',
//     //     child: Icon(Icons.add),
//     //   ), // This trailing comma makes auto-formatting nicer for build methods.
//     // );
//   }
// }

// import 'package:flutter/material.dart';

// class EnchereEncoursPage extends StatefulWidget {
//   EnchereEncoursPage({Key key, this.title}) : super(key: key);
//   final String title;
//   @override
//   _EnchereEncoursPageState createState() => _EnchereEncoursPageState();
// }

// class _EnchereEncoursPageState extends State<EnchereEncoursPage> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScopeNode currentFocus = FocusScope.of(context);
//         if (!currentFocus.hasPrimaryFocus) {
//           currentFocus.unfocus();
//         }
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Center(child: Text("ce,eter")),
//       ),
//     );
//   }
// }

void main() async {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.grey, // status bar color
    ));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await GetStorage.init();
   
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

   

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
    
      title: 'Luxury',
      debugShowCheckedModeBanner: false,

        localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English, no country code
        const Locale('es', ''), // Spanish, no country code
        const Locale('fr', ''),
        const Locale('de', ''),
        const Locale('it', ''),
      ],

      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      // supportedLocales: AppLocalizations.supportedLocales,

      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      //initialRoute: AppRoutes.splashScreen,
      home:   SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  AnimationController animationController;
  Animation<double> animation;
  Timer timer;
  startTime() async {
    var _duration = new Duration(milliseconds: 350);
    timer = Timer(_duration, navigationPage);
    return timer;
  }

  void navigationPage() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String email = prefs.getString("email");

    if (email == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => AppStartPage()),
      ); //ton login
    } else {
      StorageSrevice().onReadData("email");
      Timer(Duration(milliseconds: 180), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => MenuPage()),
        ); //ton acceuil
      });
    }

    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginTypeScreen()));
  }

  @override
  dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // animationController = new AnimationController(
    //   vsync: this,
    //   duration: new Duration(milliseconds: 100),
    // );
    // animation =
    //     new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    // animation.addListener(
    //   () => this.setState(() {}),
    // );
    // animationController.forward();
    
  
    startTime();
    FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "Luxury reverse",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[800]),
        ),
      ),
    );
  }
}
