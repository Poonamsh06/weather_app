import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:weather/constent.dart';
import 'package:weather/model.dart';
import 'package:weather/mongodb.dart';
import 'package:http/http.dart' as http;
import 'package:weather/readData.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  bool isChecked = true;
  bool isChecked2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 90),
        child: Center(
          child: FutureBuilder<List<Map<String, dynamic>>>(
              future: readData.readAllDataFromCollection(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  var data = snapshot.data ?? [];
                  return Column(
                    //  crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          "TEMPRATURE IN CELCIUS",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.11),
                      CircularPercentIndicator(
                        radius: 110.0,
                        lineWidth: 30.0,
                        animation: true,
                        percent: 0.3,
                        center: const Text(
                          "23 °C",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Color.fromARGB(255, 158, 157, 157)),
                        ),
                        //  progressColor:,
                        linearGradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 217, 208, 111),
                            Color.fromARGB(255, 255, 158, 12)
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          stops: [
                            0.1,
                            0.9,
                          ],
                        ),

                        // Colors.orange,
                        circularStrokeCap: CircularStrokeCap.round,
                        backgroundColor:
                            const Color.fromARGB(255, 232, 231, 231),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            checkColor: Colors.black,
                            activeColor: Colors.orange,
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.005),
                          const Text(
                            "CURRENT TEMP",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromARGB(255, 158, 157, 157)),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03),
                          Checkbox(
                              checkColor: Colors.black,
                              activeColor: Colors.orange,
                              value: isChecked2,
                              onChanged: (value) {
                                setState(() {
                                  isChecked2 = value!;
                                });
                              }),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.005),
                          const Text(
                            "MAXIMUM TEMP",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromARGB(255, 158, 157, 157)),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.12),
                      SizedBox(
                        height: 500,
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: ((context, index) {
                              var item = data[index];
                              var date = item['dt_txt'];
                              String substr = date.substring(0, 8);
                              var tempInKelvin = item['main']['temp'];
                              double tempInCelsius = tempInKelvin - 273.15;
                              String formattedTemp =
                                  tempInCelsius.toStringAsFixed(2);

                              var maxTempInKelvin = item['main']['temp'];
                              double MaxTempInCelsius =
                                  maxTempInKelvin - 273.15;
                              String maxformattedTemp =
                                  MaxTempInCelsius.toStringAsFixed(2);

                              return fields(
                                maxformattedTemp: maxformattedTemp,
                                index: index,
                              );
                            })),
                      )
                    ],
                  );
                }
              }),
        ),
      ),
    ));
  }
}
