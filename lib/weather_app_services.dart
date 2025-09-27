import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather_app/api_resonse_modal.dart';
import 'package:flutter_weather_app/constants.dart';
import 'package:flutter_weather_app/weather_app_modal.dart';
import 'package:http/http.dart' as http;

class WeatherAppServices {
  static Future<WeatherAppModal?> makeApiCall(String cityName) async {
    try {
      var url = Uri.http(WeatherAppConstants.apiBaseUrl, "/v1/current.json", {'key': "e17d8c95a4554b7a9ed43905252709", 'q': cityName, 'qi': "no"});
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        var apiResponse = ApiResponseModal.fromJson(jsonResponse);
        return WeatherAppModal.fromApiResponse(apiResponse);
      } else if (response.statusCode == 400) {
        debugPrint("401 from server $response");
      } else {
        debugPrint("${response.statusCode} from server $response");
        return null;
      }
    } catch (e) {
      debugPrint("error in the api call ${e.toString()}");
      return null;
    }
  }
}
