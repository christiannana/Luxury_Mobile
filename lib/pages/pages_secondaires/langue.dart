// import 'package:flutter/material.dart';
// import 'package:luxury/parametres/themeGeneral.dart';
// import 'package:checkbox_grouped/checkbox_grouped.dart';
// // import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class LanguesPage extends StatefulWidget {
//   LanguesPage({Key key, this.title}) : super(key: key);
//   final String title;
//   @override
//   _LanguesPageState createState() => _LanguesPageState();
// }

// class _LanguesPageState extends State<LanguesPage> {
//   List<String> allItemList = [
//     'Français',
//     'Anglais',
//     'Allemand',
//     'Espagnole',
//     'Italy',
//     'Russe',
//   ];

//   List<String> checkedItemList = [
//     'Français',
//   ];

//   GroupController controller = GroupController(initSelectedItem: [1]);
//   GroupController switchController = GroupController();
//   GroupController chipsController =
//       GroupController(initSelectedItem: [2], isMultipleSelection: false);
 

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
//         appBar: AppBar(
//           backgroundColor: ThemeGeneral().color_AppBar,
//           elevation: 2,
//           title: Text("Langues"),
//         ),
//         body: SingleChildScrollView(
//             child: Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: Column(crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(28.0),
//                 child: Text("", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600 ),),
//               ),

//               //             GroupedCheckbox(
//               //               wrapAlignment: WrapAlignment.spaceBetween,
//               //               wrapCrossAxisAlignment: WrapCrossAlignment.center,
//               //               textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600 ),
//               //   itemList: allItemList,
//               //   checkedItemList: checkedItemList,
//               //   onChanged: (itemList) {
//               //       setState(() {
//               //          var selectedItemList = itemList;
//               //          print('SELECTED ITEM LIST $itemList');
//               //         });
//               //   },
//               //   orientation: CheckboxOrientation.VERTICAL,
//               //   checkColor: Colors.blue,
//               //   activeColor: Colors.red
//               // ),

//               // Divider(),
//               //     SimpleGroupedChips<int>(
//               //       controller: chipsController,
//               //       values: [1, 2, 3, 4, 5, 6,],
//               //       itemTitle: ["Français", "Anglais", "Allemand", "Espagnole", "Italy", "Russe",],
//               //       backgroundColorItem: Colors.black26,
//               //       isScrolling: false,
//               //       onItemSelected: (values) {
//               //         print(values);
//               //       },
//               //     ),
//               Divider(),
//               SimpleGroupedCheckbox<int>(
//                 controller: controller,
//                 itemsTitle: [
//                   "Français",
//                   "Anglais",
//                   "Allemand",
//                   "Espagnole",
//                   "Italy",
//                   "Russe",
//                 ],
//                 values: [1, 2, 3, 4, 5, 6],
//                 checkFirstElement: false,
//                 isLeading: true,
//                 activeColor: Colors.indigo,
//                 groupTitleStyle:
//                     TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                 onItemSelected: (value) {
//                   print(value);
//                 },
//               )
//             ],
//           ),
//         )),
//       ),
//     );
//   }
// }
