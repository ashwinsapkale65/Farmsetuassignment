import 'package:farm_setu/providers/layer_provider.dart';
import 'package:farm_setu/view/home.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_)=>LayerTypeProvider(),
    
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: _checkSharedPrefs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!) {
              return home();
            } else {
              
              return FutureBuilder<Position>(
                future: _getCurrentPosition(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      
                      return const Text('Error');
                    }
                    return home();
                  } else {
               
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              );
            }
          } else {
         
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    )
  ,
    );


    }
}

Future<bool> _checkSharedPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.containsKey('latitude') && prefs.containsKey('longitude');
}

Future<Position> _getCurrentPosition() async {
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();

    // Store latitude and longitude in shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', position.latitude);
    prefs.setDouble('longitude', position.longitude);

    return position;
  } catch (e) {
    print('Error getting current position: $e');
    rethrow; 
  }
}
