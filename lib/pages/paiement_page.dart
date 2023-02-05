
// import 'package:flutter/material.dart';
// import 'package:flutter_credit_card/credit_card_form.dart';
// import 'package:flutter_credit_card/flutter_credit_card.dart';
// import 'package:luxury/parametres/themeGeneral.dart';
// // import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class CardPaiementPage extends StatefulWidget {
//   CardPaiementPage({Key key, this.title}) : super(key: key);
//   final String title;
//   @override
//   _CardPaiementPageState createState() => _CardPaiementPageState();
// }

// class _CardPaiementPageState extends State<CardPaiementPage> {
//   String cardNumberInput;
//  String cardNumber = '';
//   String expiryDate = '';
//   String cardHolderName = '';
//   String cvvCode = '';
//   bool isCvvFocused = false;
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
//         appBar: AppBar(
//           backgroundColor: ThemeGeneral().color_AppBar,
//           elevation: 2,
//           title: Text("Achat de places."),
//         ),
//         backgroundColor: Colors.grey[200],
//         body: SafeArea(
//           child: Column(
//             children: <Widget>[
            
//               SingleChildScrollView(
//                 child: Column(
//                   children: <Widget>[
//                    CreditCardWidget(
//                     cardNumber: cardNumber,
//                     expiryDate: expiryDate,
//                     cardHolderName: cardHolderName,
//                     cvvCode: cvvCode,
//                     showBackView: isCvvFocused,
//                     obscureCardNumber: true,
//                     obscureCardCvv: true,
//                   ),
//                     CreditCardForm(
//                       formKey: formKey,
//                       obscureCvv: true,
//                       obscureNumber: true,
//                       cardNumber: cardNumber,
//                       cvvCode: cvvCode,
//                       cardHolderName: cardHolderName,
//                       expiryDate: expiryDate,
//                       themeColor: Colors.blue,
//                       cardNumberDecoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'Number',
//                         hintText: 'XXXX XXXX XXXX XXXX',
//                       ),
//                       expiryDateDecoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'Expired Date',
//                         hintText: 'XX/XX',
//                       ),
//                       cvvCodeDecoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'CVV',
//                         hintText: 'XXX',
//                       ),
//                       cardHolderDecoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'Card Holder',
//                       ),
//                       onCreditCardModelChange: onCreditCardModelChange,
//                     ),
//                     SizedBox(width: MediaQuery.of(context).size.width,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(18.0),
//                           ),
//                           primary: ThemeGeneral().color_Boutton,
//                         ),
//                         child: Container(
//                           margin: const EdgeInsets.all(8),
//                           child: const Text(
//                             'Validate',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontFamily: 'halter',
//                               fontSize: 14,
//                               package: 'flutter_credit_card',
//                             ),
//                           ),
//                         ),
//                         onPressed: () {
//                           if (formKey.currentState.validate()) {
//                             print('valid!');
//                           } else {
//                             print('invalid!');
//                           }
//                         },
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void onCreditCardModelChange(CreditCardModel creditCardModel) {
//     setState(() {
//       cardNumber = creditCardModel.cardNumber;
//       expiryDate = creditCardModel.expiryDate;
//       cardHolderName = creditCardModel.cardHolderName;
//       cvvCode = creditCardModel.cvvCode;
//       isCvvFocused = creditCardModel.isCvvFocused;
//     });
//   }
// }


//  // "access_token": "6smPQf4O_tvPksut3LAVto7duNLS1XZE"