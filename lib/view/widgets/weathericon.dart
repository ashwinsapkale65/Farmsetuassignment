import 'package:flutter/material.dart';

Widget weathericon(BuildContext context, String weathericon) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.1,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(
          "http://openweathermap.org/img/w/$weathericon.png",
        ),
      ),
    ),
  );
}
