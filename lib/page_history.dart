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
      body: FutureBuilder<List<model_stat>>(
        builder: (BuildContext bc, AsyncSnapshot<List<model_stat>> snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data.length == 0) {
            return SizedBox.expand(child: new Text("No Data"));
          } else {
            return ListView.builder(
              itemBuilder: (BuildContext c, int index) {
                model_stat stat = snapshot.data.elementAt(index);
                String formattedTime = DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(stat.stat_time));
                return ExpansionTile(
                  backgroundColor: Colors.grey[200],
                  title: Text(
                    formattedTime,
                    style: new TextStyle(fontSize: 24),
                  ),
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
            );
          }
        },
        future: _historyAPI.getHistory(widget.countryName),
      ),
    );
  }
}
