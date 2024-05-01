import 'package:farm_setu/providers/layer_provider.dart';
import 'package:farm_setu/service/current_weather.dart';
import 'package:farm_setu/service/forcast_weather.dart';
import 'package:farm_setu/view/layers.dart';
import 'package:farm_setu/view/widgets/showmap.dart';
import 'package:farm_setu/view/widgets/weathercard.dart';
import 'package:farm_setu/view/widgets/weathericon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Weathermain extends StatefulWidget {
  final WeatherData weatherData;

  Weathermain({required this.weatherData});

  @override
  _WeathermainState createState() => _WeathermainState();
}

class _WeathermainState extends State<Weathermain> {
  String _selectedLayerType = 'Precipitation'; // Default layer type

  @override
  Widget build(BuildContext context) {
    DateTime now =
        DateTime.fromMillisecondsSinceEpoch(widget.weatherData.dt * 1000);

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                "Weather Report For",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              widget.weatherData.name,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              DateFormat("h:mm a").format(now),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.black54,
              ),
            ),
            Text(
              DateFormat("EEE d.MMM.y").format(now),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Color.fromARGB(255, 156, 45, 220),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 92, 62, 148).withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.weatherData.description,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '${widget.weatherData.temperature.toStringAsFixed(0)}°C',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    "Upcoming Weather Forecast",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                cards(context),
                SizedBox(height: 20),
                showmap()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
