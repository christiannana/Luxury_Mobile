import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:luxury/parametres/themeGeneral.dart';
import 'package:luxury/services/http_Ref.dart';
import 'package:luxury/services/storage.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EvolutionMarchePage extends StatefulWidget {
  EvolutionMarchePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _EvolutionMarchePageState createState() => _EvolutionMarchePageState();
}

class _EvolutionMarchePageState extends State<EvolutionMarchePage> {
  var data;
  Map produitData;
  List datas;
  onHttpTradingCall() async {
    var response = await Dio()
        .post(HttpRef().baseUrl + "produits/proposition/restantes", data: {
      "produit_id": produitData["id"],
      "email_utilisateur": StorageSrevice().onReadData("email"),
    });
    print(response.data);
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
     produitData = ModalRoute.of(context).settings.arguments;

    return GestureDetector(
      onTap: () {
        data = onHttpTradingCall();
        datas = data["offres"];
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeGeneral().color_AppBar,
          elevation: 2,
          title: Text(AppLocalizations.of(context).trading_evolution),
        ),
        backgroundColor: Colors.white,
        body: Card(
          child: Column(
            children: [
              // Container( height: 300, width: MediaQuery.of(context).size.width,
              //    decoration: BoxDecoration(
              //      borderRadius: BorderRadius.circular(5),
              //   image: DecorationImage(
              //     image: NetworkImage("https://image.freepik.com/free-vector/stock-market-forex-trading-graph-graphic-concept_73426-35.jpg"),
              //     fit: BoxFit.cover,
              //   ),),
              //   child: Text("")),

              SizedBox(
                height: MediaQuery.of(context).size.height /2,
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder<dynamic>(
                  future: onHttpTradingCall(),
                  builder: (BuildContext context, snapshot) {
                    print(snapshot);
                    if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 38.0),
                        child: Text("Erreur réseau..."),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      List data = snapshot.data["offres"];
                      if (data.length == 0)
                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 38.0, bottom: 15),
                              child: Icon(
                                Icons.sick,
                                size: 60,
                                color: Colors.blueGrey[200],
                              ),
                            ),
                            Text("Aucune donnée presente."),
                          ],
                        );

                      return SfCartesianChart(
                        //  primaryXAxis: DateTimeAxis(
                        //      interval: 0.5,
                        // ),
                       // primaryXAxis: NumericAxis(),
                          // Initialize category axis
                          primaryXAxis: CategoryAxis(),
                          series: <ChartSeries>[
                            // Initialize line series
                            AreaSeries <SalesData, String>(
                                color: Colors.indigo,
                                dataSource: data
                                    .map((item) => new SalesData(
                                       DateTime.tryParse(item["Date"]).toHumanString().toString(),
                                         item["prix_offre"]))
                                    .toList(),
                                dataLabelSettings:DataLabelSettings(isVisible : true),
                                // [
                                //     // Bind data source
                                //     SalesData('Jan', 35),
                                //     SalesData('Feb', 28),
                                //     SalesData('Mar', 34),
                                //     SalesData('Apr', 32),
                                //     SalesData('May', 40)
                                // ],

                                xValueMapper: (SalesData sales, _) =>
                                    sales.year,
                                yValueMapper: (SalesData sales, _) =>
                                    sales.sales),
                          ]);
                    }

                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text("Courbe évolution des offres."),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final dynamic year;
  final dynamic sales;
}
