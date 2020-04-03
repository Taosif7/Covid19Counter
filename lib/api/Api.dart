import 'dart:convert';

import 'package:http/http.dart' as http;

class Api {
  final String BASE_URL = "https://covid-193.p.rapidapi.com";

  Map<String, String> headers = {
    'x-rapidapi-host': 'covid-193.p.rapidapi.com',
    'x-rapidapi-key': '1a2bd39174mshb2c277fb9c45a9cp185b5djsn22dd2bea2eba'
  };

  Future<dynamic> getAPIResponse(String endPoint) async {
    http.Response response = await http.get(BASE_URL + "/" + endPoint, headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("API Error, Status Code : " + response.statusCode.toString());
      return null;
    }
  }
}
