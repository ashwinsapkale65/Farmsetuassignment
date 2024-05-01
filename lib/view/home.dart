import 'package:farm_setu/service/current_weather.dart';

import 'package:farm_setu/view/weathermain.dart';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class home extends StatefulWidget {
  home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  WeatherData? weatherData;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'FarmSetu',
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 156, 45, 220),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25.0),
              bottomRight: Radius.circular(25.0),
            ),
          ),
        ),
        body: FutureBuilder<WeatherData>(
          future: WeatherData.fetchWeatherDataFromSharedPreferences(),
          builder: (BuildContext context, AsyncSnapshot<WeatherData> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              WeatherData? currentWeather = snapshot.data;
              if (currentWeather != null) {
                return Weathermain(
                  weatherData: currentWeather,
                );
              } else {
                return Text('No weather data available');
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
