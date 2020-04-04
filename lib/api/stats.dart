import 'package:covid19counter/models/stat.dart';

import 'Api.dart';

class api_statistics extends Api {
  final String ENDPOINT = "statistics";
  final String PARAM_COUNTRY = "country";

  Future<List<model_stat>> getAllStats() async {
    List<model_stat> stat_list = [];

    dynamic responseData = await getAPIResponse(ENDPOINT);
    if (responseData == null) return stat_list;

    for (dynamic item in responseData["response"]) {
      model_stat stat = model_stat.fromJson(item);
      if (stat.country == "World") continue; // Skip the "World" Data
      stat_list.add(stat);
    }

    stat_list.sort((a, b) => int.parse(b.total_cases).compareTo(int.parse(a.total_cases)));

    return stat_list;
  }

  Future<model_stat> getByCountry(String country) async {
    String url = ENDPOINT + "?" + PARAM_COUNTRY + "=" + country;

    dynamic responseData = await getAPIResponse(url);
    if (responseData == null) return null;

    model_stat stat = model_stat.fromJson(responseData["response"][0]);
    return stat;
  }
}
