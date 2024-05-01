import 'package:farm_setu/service/forcast_weather.dart';
import 'package:farm_setu/view/widgets/weathericon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget cards(BuildContext context) {
  return FutureBuilder<List<WeatherForecast>>(
    future: WeatherForecast.fetchForecastsFromSharedPreferences(),
    builder:
        (BuildContext context, AsyncSnapshot<List<WeatherForecast>> snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        List<WeatherForecast>? forecasts = snapshot.data;
        if (forecasts != null && forecasts.isNotEmpty) {
          return SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: forecasts.length,
              itemBuilder: (BuildContext context, int index) {
                WeatherForecast forecast = forecasts[index];
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color.fromARGB(255, 220, 219, 139),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Color.fromARGB(255, 166, 32, 206).withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  width: 150,
                  margin: EdgeInsets.all(8),
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        weathericon(context, forecast.icon),
                        Text(
                          DateFormat('EEE').format(
                            DateTime.fromMillisecondsSinceEpoch(
                              forecast.dt * 1000,
                            ),
                          ),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          forecast.description,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat('dd-MM-yyyy').format(
                            DateTime.fromMillisecondsSinceEpoch(
                              forecast.dt * 1000,
                            ),
                          ),
                        ),
                        Text(
                          DateFormat('h:mm a').format(
                            DateTime.fromMillisecondsSinceEpoch(
                              forecast.dt * 1000,
                            ),
                          ),
                        ),
                        Text(
                          'Temperature: ${forecast.temperature.toStringAsFixed(0)}°C',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Text('No forecast data available.');
        }
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
        ],
      );
    },
  );
}
