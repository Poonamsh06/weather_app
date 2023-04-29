import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weather/model.dart';
import 'package:http/http.dart' as http;
import 'package:weather/mongodb.dart';
import 'package:weather/readData.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  List<WeatherList>? _weatherData;

  @override
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final weatherList = await _fetchWeatherData();
      await MongoDatabase.connect(weatherList);
    });
  }

  Future<List<WeatherList>> _fetchWeatherData() async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=Malout&appid=9d05cafc251c85ad7b580cc94e1ed46c'));
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded != null) {
        final List<WeatherList> weatherList = [];
        for (var i = 0; i < 5; i++) {
          weatherList.add(WeatherList.fromJson(decoded['list'][i]));
        }
        return weatherList;
      } else {
        // handle the case where the data is missing or invalid
        print("null");
        return [];
      }
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Weather'),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
            future: readData.readAllDataFromCollection(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                var data = snapshot.data ?? [];
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var item = data[index];
                      var date = item['dt_txt'];
                      var temperature = item['main']['temp'];
                      // var description = item['description'];
                      // var iconCode = item['iconCode'];
                      return ListTile(
                        title: Text(temperature.toString()),
                      );
                    });
              }
            }));
  }
}
