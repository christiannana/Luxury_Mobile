import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:luxury/component/paiement_dialog.dart';
import 'package:luxury/services/http_Ref.dart';
import 'package:luxury/services/storage.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../parametres/themeGeneral.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProduitsDetailsPage extends StatefulWidget {
  ProduitsDetailsPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _ProduitsDetailsPageState createState() => _ProduitsDetailsPageState();
}

class _ProduitsDetailsPageState extends State<ProduitsDetailsPage>
    with SingleTickerProviderStateMixin {
  int valeur = 0;
  String videoId;
  var _url = 'https://flutter.dev';
  TabController _tabController;

  final RoundedLoadingButtonController btnController =   RoundedLoadingButtonController();
 
  @override
  void initState() {
   // _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map produit = ModalRoute.of(context).settings.arguments;
    Map produit_data = produit["data"];
    String produit_id = produit["id"];
    videoId = produit_data['video'];
    print(produit_data);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: ThemeGeneral().color_AppBar,
          elevation: 2,
          title: Text(produit_data['nom'].toString().toLowerCase()),
          // bottom: TabBar(
          //     controller: _tabController,
          //     indicatorWeight: 3,
          //     indicatorColor: Colors.amber[100],
              // tabs: <Widget>[
              //   Tab(
              //     child: Text(AppLocalizations.of(context).produitDetails_Produit),
              //   ),
              //   Tab(child: Text(AppLocalizations.of(context).produitDetails_Detail))
              // ]),
        ),
        body:  Scrollbar(
            child: Card(
              child: ListView(
                padding: EdgeInsets.all(10),
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                            produit_data['image_principale'],
                          ),
                          fit: BoxFit.fill),
                    ),
                  ),
                
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(AppLocalizations.of(context).produitDetails_dsecription,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    produit_data['description'],
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(AppLocalizations.of(context).produitDetails_prixVente,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    produit_data['prix_vente'].toString() + " €",
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(AppLocalizations.of(context).produitDetails_nombrePlace,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    produit_data['nbr_place'].toString(),
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(AppLocalizations.of(context).produitDetails_prixPlace,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    produit_data['prix_place'].toString() + " €",
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
            




            /////////////////////////////////////////////////////////////////////////////////////
            
               Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(AppLocalizations.of(context).produitDetails_imageComple,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    ),
                  ),

            SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: CarouselSlider(
                        items: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              // color: Colors.amber,
                              image: DecorationImage(
                                  image: NetworkImage(
                                    produit_data['image1'],
                                  ),
                                  fit: BoxFit.fill),
                            ),
                          ),
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    produit_data['image2'],
                                  ),
                                  fit: BoxFit.fill),
                            ),
                          ),
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    produit_data['image3'],
                                  ),
                                  fit: BoxFit.fill),
                            ),
                          ),
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    produit_data['image4'],
                                  ),
                                  fit: BoxFit.fill),
                            ),
                          ),
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    produit_data['image5'],
                                  ),
                                  fit: BoxFit.fill),
                            ),
                          ),
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    produit_data['image6'],
                                  ),
                                  fit: BoxFit.fill),
                            ),
                          ),
                        ],
                        options: CarouselOptions(
                          height: 450,
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.8,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.linear,
                          enlargeCenterPage: true,
                          // onPageChanged: callbackFunction,
                          scrollDirection: Axis.horizontal,
                        )),
                  ),

            Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(AppLocalizations.of(context).produitDetails_videoPromotionnelle,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    ),
                  ),

 
                  YoutubePlayer(
                    controller: YoutubePlayerController(
                      initialVideoId: videoId,
                      flags: YoutubePlayerFlags(
                        autoPlay: false
                        // mute: true,
                      ),
                    ),
                    showVideoProgressIndicator: true,
                    // videoProgressIndicatorColor: Colors.amber,
                    // progressColors: ProgressColors(
                    //     playedColor: Colors.amber,
                    //     handleColor: Colors.amberAccent,
                    // ),
                    // onReady () {
                    //     _controller.addListener(listener);
                    // },
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(AppLocalizations.of(context).produitDetails_ficheTech,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
               
        
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        this._url = produit_data['fiche_technique'];
                      });
                      _launchURL();
                    },
                    child: Text(AppLocalizations.of(context).produitDetails_ficheTech)
                  ),

                ],
              ),
            ),
          ),
         
       

       bottomNavigationBar: Card(
         child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 18),
                      child: RoundedLoadingButton(
                        height: 45,
                        width: MediaQuery.of(context).size.width,
                        color: ThemeGeneral().color_Boutton,
                        successColor: Colors.green,
                        child: Text(AppLocalizations.of(context).produitDetails_acheterPlace  + '  ' +
                                produit_data['prix_place'].toString() +
                                " €",
                            style: TextStyle(
                                color: ThemeGeneral().color_TextBoutton,
                                fontWeight: FontWeight.bold)),
                        controller: btnController,
                        onPressed: () async {
       
                          DialogPayment().onDialogPayment(
                            context,
                            produit_id,
                            produit_data['nom'],
                            StorageSrevice().onReadData("email"),
                            StorageSrevice().onReadData("nom"),
                            produit_data['prix_place'].toString(),
                            produit_data['nbr_place'].toString(),
                            produit_data['categorie'],
                            produit_data['duree_enchere'],
                          );
                    // print(produit_id);
                          try {
                            btnController.stop();
                            var response = await Dio().get(HttpRef().baseUrl);
                            print(response.data);
                            return null;
                          } catch (e) {
                            print(
                                'wio XIOX WIOS KLIOZ NDIODKIODJ EIO  EIOF JDOED EKJKROE EIEOER DIEOD DKGFOFOED A RIOIOIOIOIOIO');
                            print(e);
                            return null;
                          }
                        },
                      ),
                    ),
       ),


      ),
    );
  }


  void _launchURL() async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
}
