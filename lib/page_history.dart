import 'package:charts_flutter/flutter.dart' as Charts;
import 'package:covid19counter/api/history.dart';
import 'package:covid19counter/models/stat.dart';
import 'package:covid19counter/widgets/InfoTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class page_history extends StatefulWidget {
  final String countryName;

  const page_history({Key key, this.countryName}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new page_history_state();
}

class page_history_state extends State<page_history> {
  api_history _historyAPI = new api_history();
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text("Covid19 History " + widget.countryName)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scrollController?.animateTo(0, curve: Curves.easeOutExpo, duration: Duration(seconds: 1));
        },
        child: Icon(Icons.keyboard_arrow_up),
      ),
      body: FutureBuilder<List<model_stat>>(
        builder: (BuildContext bc, AsyncSnapshot<List<model_stat>> snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data.length == 0) {
            return SizedBox.expand(child: new Text("No Data"));
          } else {
            return SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SizedBox(
                      height: 400,
                      child: new Charts.LineChart(
                        _getCountryChartData(snapshot.data),
                        animate: false,
                        defaultRenderer: new Charts.LineRendererConfig(
                            includeArea: true, stacked: true, includePoints: snapshot.data.length < 20),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton.icon(
                          onPressed: () {}, icon: Icon(Icons.linear_scale, color: Colors.amber), label: Text("Cases")),
                      FlatButton.icon(onPressed: () {}, icon: Icon(Icons.linear_scale, color: Colors.red), label: Text("Deaths")),
                      FlatButton.icon(
                          onPressed: () {}, icon: Icon(Icons.linear_scale, color: Colors.green), label: Text("Recovered")),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ListView.builder(
                    itemBuilder: (BuildContext c, int index) {
                      model_stat stat = snapshot.data.elementAt(index);
                      String formattedTime = DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(stat.stat_time));
                      return ExpansionTile(
                        leading: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            (snapshot.data.length - index - 1).toString(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        backgroundColor: Colors.grey[200],
                        title: Text(formattedTime, style: new TextStyle(fontSize: 24)),
                        children: <Widget>[
                          InfoTile(Icons.content_paste, stat.total_cases, "Total Cases"),
                          InfoTile(Icons.airline_seat_individual_suite, stat.total_deaths, "Total Deaths"),
                          InfoTile(Icons.sync, stat.recovered_cases, "Total Recovered"),
                          InfoTile(Icons.new_releases, stat.active_cases, "Active Cases"),
                          InfoTile(Icons.group_add, stat.new_cases, "New Cases"),
                          InfoTile(Icons.sentiment_very_dissatisfied, stat.new_deaths, "New Deaths"),
                          InfoTile(Icons.airline_seat_flat_angled, stat.critical_cases, "Critical Cases"),
                        ],
                      );
                    },
                    itemCount: snapshot.data.length,
                    physics: BouncingScrollPhysics(),
                    cacheExtent: 10,
                    shrinkWrap: true,
                  ),
                ],
              ),
            );
          }
        },
        future: _historyAPI.getHistory(widget.countryName),
      ),
    );
  }

  List<Charts.Series<model_stat, int>> _getCountryChartData(List<model_stat> data) {
    return [
      new Charts.Series<model_stat, int>(
          id: 'recovered',
          data: data.reversed.toList(),
          domainFn: (item, _) => _,
          measureFn: (item, _) => int.parse(item.recovered_cases),
          colorFn: (i, _) => Charts.MaterialPalette.green.shadeDefault),
      new Charts.Series<model_stat, int>(
          id: 'deaths',
          data: data.reversed.toList(),
          domainFn: (item, _) => _,
          measureFn: (item, _) => int.parse(item.total_deaths) - int.parse(item.recovered_cases),
          colorFn: (i, _) => Charts.MaterialPalette.red.shadeDefault),
      new Charts.Series<model_stat, int>(
          id: 'cases',
          data: data.reversed.toList(),
          domainFn: (item, _) => _,
          measureFn: (item, _) => int.parse(item.total_cases) - (int.parse(item.total_deaths)),
          colorFn: (i, _) => Charts.MaterialPalette.yellow.shadeDefault.darker),
    ];
  }
}
