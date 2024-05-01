import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WeatherData {
  final double temperature;
  final int dt;
  final String name;
  final String weatherIcon;
  final String description;

  WeatherData({
    required this.temperature,
    required this.dt,
    required this.name,
    required this.weatherIcon,
    required this.description,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: json['main']['temp'].toDouble(),
      dt: json['dt'],
      name: json['name'],
      weatherIcon: json['weather'][0]['icon'],
      description: json['weather'][0]['description'],
    );
  }

  static Future<WeatherData> fetchWeatherData(
      double latitude, double longitude) async {
    final apiKey =
        '2bbdc07ef3c4cba193a6b74a0d6417e5';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return WeatherData.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  static Future<Map<String, double>> _getLocationFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double latitude = prefs.getDouble('latitude') ?? 0.0;
    double longitude = prefs.getDouble('longitude') ?? 0.0;
    return {'latitude': latitude, 'longitude': longitude};
  }

  static Future<WeatherData> fetchWeatherDataFromSharedPreferences() async {
    Map<String, double> locationData =
        await _getLocationFromSharedPreferences();
    double latitude = locationData['latitude']!;
    double longitude = locationData['longitude']!;
    return fetchWeatherData(latitude, longitude);
  }
}
