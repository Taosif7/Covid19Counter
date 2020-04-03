import 'package:covid19counter/api/Api.dart';
import 'package:covid19counter/models/stat.dart';

class api_history extends Api {
  final String ENDPOINT = "history";
  final String PARAM_COUNTRY = "country";

  Future<List<model_stat>> getHistory(String country) async {
    String url = ENDPOINT + "?" + PARAM_COUNTRY + "=" + country;
    List<model_stat> stat_list = [];

    dynamic responseData = await getAPIResponse(url);
    if (responseData == null) return stat_list;

    for (dynamic item in responseData["response"]) {
      model_stat stat = model_stat.fromJson(item);
      stat_list.add(stat);
    }

    stat_list.sort((a, b) => int.parse(b.total_cases).compareTo(int.parse(a.total_cases)));

    return stat_list;
  }
}
