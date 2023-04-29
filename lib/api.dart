import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather/model.dart';

Future<Model> fetchForecastWeatherData(String city) async {
  final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?q=Malout&appid=9d05cafc251c85ad7b580cc94e1ed46c'));

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    final jsonData = json.decode(response.body);
    Model data = Model.fromJson(jsonData);
    return data;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load forecast weather data');
  }
}
