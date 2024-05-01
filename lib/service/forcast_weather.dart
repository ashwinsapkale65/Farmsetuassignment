import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WeatherForecast {
  final int dt;
  final double temperature;
  final String date;
  final String icon;
  final String description;

  WeatherForecast({
    required this.dt,
    required this.temperature,
    required this.date,
    required this.icon,
    required this.description,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      dt: json['dt'],
      temperature: json['main']['temp'].toDouble(),
      date: json['dt_txt'],
      icon: json['weather'][0]['icon'],
      description: json['weather'][0]['description'],
    );
  }

  static Future<Map<String, double>> _getLocationFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double latitude = prefs.getDouble('latitude') ?? 0.0;
    double longitude = prefs.getDouble('longitude') ?? 0.0;
    return {'latitude': latitude, 'longitude': longitude};
  }

  static Future<List<WeatherForecast>>
      fetchForecastsFromSharedPreferences() async {
    Map<String, double> locationData =
        await _getLocationFromSharedPreferences();
    double latitude = locationData['latitude']!;
    double longitude = locationData['longitude']!;
    return fetchForecasts(latitude, longitude);
  }

  static Future<List<WeatherForecast>> fetchForecasts(
      double latitude, double longitude) async {
    final apiKey = '2bbdc07ef3c4cba193a6b74a0d6417e5';
    final url =
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=metric&appid=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> dataList = jsonResponse['list'];

      return dataList.map((data) => WeatherForecast.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load weather forecast');
    }
  }
}
