import 'package:covid19counter/CountrySearchView.dart';
import 'package:covid19counter/api/stats.dart';
import 'package:covid19counter/flagUrl.dart';
import 'package:covid19counter/models/stat.dart';
import 'package:covid19counter/widgets/InfoTile.dart';
import 'package:covid19counter/widgets/bigNumber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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

  // Data variables
  List<model_stat> _loadedData = [];
  Future<bool> _dataLoadStatus;

  // Component variables
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey();
  SwiperController controllerFlags = new SwiperController();
  SwiperController controllerInfoPage = new SwiperController();
  api_statistics StatsAPI = new api_statistics();
  NumberFormat formatter = new NumberFormat("##,##,##,###");

  @override
  void initState() {
    // Load data asynchronously on initialization
    _dataLoadStatus = loadData();
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
                showSearch(
                    context: context,
                    delegate: CountrySearchView(_loadedData.map((st) {
                      return st.country;
                    }).toList()))
                    .then((result) {
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
                    // If data isn't loaded, don't open the sheet
                    if (_dataLoadStatus == null) return;

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
                                  itemCount: _loadedData.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return ListTile(
                                      dense: true,
                                      trailing: Text(formatter.format(int.parse(_loadedData
                                          .elementAt(index)
                                          .total_cases))),
                                      title: Text(_loadedData
                                          .elementAt(index)
                                          .country),
                                      leading: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(getFlagImageUrl(_loadedData
                                            .elementAt(index)
                                            .country)),
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
                    return loadData();
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
                          itemCount: _loadedData.length,
                          onIndexChanged: (index) {
                            // We move the info page in sync with the flags swiper
                            // So we use the controller of page and call to move to page
                            // every time the flags scroller is scrolled (i.e. index is changed)
                            controllerInfoPage.move(index);
                          },
                          itemBuilder: (BuildContext c, int index) {
                            // Firstly we get the flag url by country name using this function
                            String flagUrl = getFlagImageUrl(_loadedData
                                .elementAt(index)
                                .country);
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                              decoration: new BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, offset: Offset(0, 6))
                                  ]),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    FadeInImage(
                                      image: NetworkImage(flagUrl),
                                      fit: BoxFit.fill,
                                      placeholder: AssetImage("assets/images/placeholder.png"),
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
                                        _loadedData
                                            .elementAt(index)
                                            .country,
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
                        height: MediaQuery
                            .of(context)
                            .copyWith()
                            .size
                            .height,
                        child: new Swiper(
                          controller: controllerInfoPage,
                          itemCount: _loadedData.length,
                          // We don't allow swiping here!
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext c, int index) {
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                              child: Column(
                                children: <Widget>[
                                  ...BigNumberWidget(
                                      Icons.content_paste, Colors.orange, _loadedData
                                      .elementAt(index)
                                      .total_cases, "Total Cases"),
                                  SizedBox(height: 20),
                                  ...BigNumberWidget(Icons.airline_seat_individual_suite, Colors.red,
                                      _loadedData
                                          .elementAt(index)
                                          .total_deaths, "Total Deaths"),
                                  SizedBox(height: 20),
                                  ...BigNumberWidget(
                                      Icons.autorenew, Colors.green, _loadedData
                                      .elementAt(index)
                                      .recovered_cases, "Total Recovered"),
                                  Divider(height: 40),
                                  // Generating info tiles
                                  InfoTile(Icons.new_releases, _loadedData
                                      .elementAt(index)
                                      .active_cases, "Active Cases"),
                                  InfoTile(
                                      Icons.group_add,
                                      (_loadedData
                                          .elementAt(index)
                                          .new_cases == "null")
                                          ? "0"
                                          : _loadedData
                                          .elementAt(index)
                                          .new_cases,
                                      "New Cases"),
                                  InfoTile(Icons.sentiment_very_dissatisfied, _loadedData
                                      .elementAt(index)
                                      .new_deaths, "New Deaths"),
                                  InfoTile(
                                      Icons.airline_seat_flat_angled, _loadedData
                                      .elementAt(index)
                                      .critical_cases, "Critical Cases"),
                                ],
                              ),
                            );
                          },
                        ),
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
            future: _dataLoadStatus,
          )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<bool> loadData() async {
    _loadedData = await StatsAPI.getAllStats();
    setState(() {});
    return true;
  }
}
