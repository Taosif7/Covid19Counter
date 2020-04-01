import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_scraper/web_scraper.dart';

import 'CountrySearchView.dart';
import 'flagUrl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid19 Counter',
      theme: ThemeData(primarySwatch: Colors.red, accentColor: Colors.redAccent),
      home: MyHomePage(title: 'Covid19 Counter'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Constants
  String appUpdateUrl = "https://bit.ly/covid19Counter";
  String dataWebsiteEndpoint = "/coronavirus/";

  // Data variables
  List<Map<String, dynamic>> data;
  Future<bool> _futureData;
  List<String> countryNames = [],
      totalCases = [],
      newCases = [],
      totalDeaths = [],
      newDeaths = [],
      totalRecovered = [],
      activeCases = [],
      seriousCases = [],
      firstCases = [];

  // Component variables
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey();
  SwiperController controllerFlags = new SwiperController();
  SwiperController controllerInfoPage = new SwiperController();
  final webScraper = WebScraper('https://www.worldometers.info');

  @override
  void initState() {
    // Load data asynchronously on initialization
    _futureData = loadAndProcessData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.system_update),
              tooltip: "Update App",
              onPressed: () async {
                // Open Url to redirect user to  app update page
                if (await canLaunch(appUpdateUrl)) launch(appUpdateUrl, universalLinksOnly: true);
              }),
          IconButton(
              tooltip: "Refresh",
              icon: Icon(Icons.refresh),
              onPressed: () {
                // Call refresh indicator show method
                // This will fire the onRefresh method of refreshIndicator
                // which will load data
                _refreshIndicatorKey.currentState?.show();
              }),
          IconButton(
              tooltip: "Search",
              icon: Icon(Icons.search),
              onPressed: () {
                // Open search view
                // Provide countryNames and a controller to which it will provide index for scrolling to specified result
                showSearch(context: context, delegate: CountrySearchView(countryNames)).then((result) {
                  if (result == null) return;
                  int val = int.parse(result);
                  controllerFlags.move(val);
                });
              })
        ],
      ),
      persistentFooterButtons: <Widget>[
        Container(
          width: MediaQuery.of(context).copyWith().size.width - 16,
          child: Row(
            children: [
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.first_page),
                  onPressed: () {
                    // Move to first page
                    controllerFlags.move(0);
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.navigate_before),
                  onPressed: () {
                    // Move to previous page
                    controllerFlags.previous();
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.navigate_next),
                  onPressed: () {
                    // Move to next page 🤷‍
                    controllerFlags.next();
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.format_list_bulleted),
                  onPressed: () {
                    // If data isn't loaded, dont open the sheet
                    if (_futureData == null) return;

                    // else open the sheet showing countries and their total cases
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (BuildContext bc) {
                          // We use Draggable scrollable sheet because the list is too large
                          return DraggableScrollableSheet(
                            initialChildSize: 0.5,
                            minChildSize: 0.3,
                            maxChildSize: 0.9,
                            builder: (BuildContext context, ScrollController scrollController) {
                              return Container(
                                padding: EdgeInsets.only(top: 10, right: 10),
                                decoration: BoxDecoration(
                                    // Rounded container
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                    color: Colors.grey.shade200),
                                child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: countryNames.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return ListTile(
                                      dense: true,
                                      trailing: Text(totalCases.elementAt(index)),
                                      title: Text(countryNames.elementAt(index)),
                                      leading: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(getFlagImageUrl(countryNames.elementAt(index))),
                                      ),
                                      onTap: () {
                                        // Move to the page and close the sheet
                                        controllerFlags.move(index);
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        });
                  },
                ),
              )
            ],
          ),
        )
      ],
      body: Center(
          child: FutureBuilder<bool>(
        builder: (BuildContext bc, AsyncSnapshot<bool> snapshot) {
          // We use future builder
          // Either show CircularProgressIndicator
          // Or the Page
          if (snapshot.data == null) {
            return CircularProgressIndicator();
          } else {
            // Using refresh indicator
            // Giving the loadAndProcessData as refresh function to reload the data
            return RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () {
                return loadAndProcessData();
              },
              // Wrapping up everything in a scroll view
              child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  SizedBox(
                    height: 200,
                    // First Swiper is for countries flags
                    child: new Swiper(
                      // We give it a specific controller
                      controller: controllerFlags,
                      viewportFraction: 0.7,
                      scale: 0.9,
                      itemCount: countryNames.length,
                      onIndexChanged: (index) {
                        // We move the info page in sync with the flags swiper
                        // So we use the controller of page and call to move to page
                        // every time the flags scroller is scrolled (i.e. index is changed)
                        controllerInfoPage.move(index);
                      },
                      itemBuilder: (BuildContext c, int index) {
                        // Firstly we get the flag url by country name using this function
                        String flagUrl = getFlagImageUrl(countryNames.elementAt(index));
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                          decoration: new BoxDecoration(
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, offset: Offset(0, 6))]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              fit: StackFit.expand,
                              children: <Widget>[
                                Image.network(
                                  flagUrl,
                                  fit: BoxFit.fill,
                                ),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  padding: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    gradient: new LinearGradient(
                                        colors: <Color>[Colors.grey.withOpacity(0), Colors.black.withOpacity(0.4)],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: <double>[0.2, 0.8]),
                                  ),
                                  child: Text(
                                    countryNames.elementAt(index),
                                    style: TextStyle(fontSize: 45, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Now Here is the Info page
                  // We permit the swiping of the info page
                  // but we allow changing it through bottom buttons
                  // but we don't swipe it, we swipe the controllerFlags
                  // and in turn it swipes the infoPage
                  SizedBox(
                    height: MediaQuery.of(context).copyWith().size.height,
                    child: new Swiper(
                      controller: controllerInfoPage,
                      itemCount: countryNames.length,
                      // We dont allow swiping here!
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext c, int index) {
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                          child: Column(
                            children: <Widget>[
                              ...generateBigNumberWidget(
                                  Icons.content_paste, Colors.orange, totalCases.elementAt(index), "Total Cases"),
                              SizedBox(height: 20),
                              ...generateBigNumberWidget(
                                  Icons.airline_seat_individual_suite, Colors.red, totalDeaths.elementAt(index), "Total Deaths"),
                              SizedBox(height: 20),
                              ...generateBigNumberWidget(
                                  Icons.autorenew, Colors.green, totalRecovered.elementAt(index), "Total Recovered"),
                              Divider(height: 40),
                              // Generating info tiles
                              generateInfoTile(Icons.new_releases, activeCases.elementAt(index), "Active Cases"),
                              generateInfoTile(Icons.group_add, newCases.elementAt(index), "New Cases"),
                              generateInfoTile(Icons.sentiment_very_dissatisfied, newDeaths.elementAt(index), "New Deaths"),
                              generateInfoTile(Icons.airline_seat_flat_angled, seriousCases.elementAt(index), "Critical Cases"),
                              generateInfoTile(Icons.calendar_today, firstCases.elementAt(index) + ", 2020", "First Case"),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Give the Credit for data
                  Text("Data From"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network("https://www.worldometers.info/img/worldometers-logo.gif"),
                  ),

                  // Take the credit for hardwork 😂
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Made With ❤ In India by TAOSIF7",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                ]),
              ),
            );
          }
        },
        future: _futureData,
      )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // Method to load and process data 💁‍♂️
  Future<bool> loadAndProcessData() async {
    // Load data into scraper
    print("Data-Loading");
    await webScraper.loadWebPage(dataWebsiteEndpoint);
    print("Data-Loaded");

    print("processing-start");

    // Get each Table row from scraper
    List<Map<String, dynamic>> data = webScraper.getElement('#main_table_countries_today > tbody > tr', ['title']);

    // Move the world data from last to first
    Map<String, dynamic> worldData = data.elementAt(data.length - 1);
    data.removeLast();
    data.insert(0, worldData);

    // Clear previous data
    countryNames.clear();
    totalCases.clear();
    totalDeaths.clear();
    newDeaths.clear();
    totalRecovered.clear();
    activeCases.clear();
    seriousCases.clear();
    firstCases.clear();

    // Iterate through table row data
    for (int i = 0; i < data.length; i++) {
      // Get tr string and each td is separated by newline(\n) character
      // so get 'em in the list by splitting from string
      String s = data.elementAt(i)['title'];
      List<String> elems = s.split("\n");

      // Now by analysing, we know indexes of each data element
      // store them in specific individual list
      countryNames.add(elems.elementAt(1));
      totalCases.add(elems.elementAt(2).trim().isEmpty ? "0" : elems.elementAt(2));
      newCases.add(elems.elementAt(3).trim().isEmpty ? "0" : elems.elementAt(3));
      totalDeaths.add(elems.elementAt(4).trim().isEmpty ? "0" : elems.elementAt(4));
      newDeaths.add(elems.elementAt(5).trim().isEmpty ? "0" : elems.elementAt(5));
      totalRecovered.add(elems.elementAt(6).trim().isEmpty ? "0" : elems.elementAt(6));
      activeCases.add(elems.elementAt(7).trim().isEmpty ? "0" : elems.elementAt(7));
      seriousCases.add(elems.elementAt(8).trim().isEmpty ? "0" : elems.elementAt(8));
      firstCases.add(elems.elementAt(12).trim().isEmpty ? "0" : elems.elementAt(12));
    }

    // First row is "Total:"
    // Remove it and add "Planet Earth" as name
    countryNames.removeAt(0);
    countryNames.insert(0, "Planet Earth");

    print("processing-ended");

    return true;
  }

  Widget generateInfoTile(IconData icon, String data, String info) {
    return ListTile(
        leading: Icon(icon), title: Text(data), trailing: Text(info), contentPadding: EdgeInsets.symmetric(horizontal: 50));
  }

  List<Widget> generateBigNumberWidget(IconData icon, Color color, String bigNumber, String title) {
    return [
      Text(
        bigNumber,
        style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: color),
        textAlign: TextAlign.center,
      ),
      Row(
        children: <Widget>[
          Icon(
            icon,
            color: color,
          ),
          Text(" " + title, style: TextStyle(color: color))
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    ];
  }
}
