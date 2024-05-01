import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:farm_setu/service/forecast_tile_provider.dart';

class GenrateLayer extends StatefulWidget {
  const GenrateLayer({Key? key, required this.layertype}) : super(key: key);
  final String layertype;

  @override
  State<GenrateLayer> createState() => MapSampleState();
}

class MapSampleState extends State<GenrateLayer>
    with SingleTickerProviderStateMixin {
  GoogleMapController? _controller;
  TileOverlay? _tileOverlay;
  DateTime _forecastDate = DateTime.now();
  late double _initialLat;
  late double _initialLng;

  @override
  void initState() {
    super.initState();
    _getInitialLocation();
  }

  _getInitialLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _initialLat = prefs.getDouble('latitude') ?? 21.0418;
    _initialLng = prefs.getDouble('longitude') ?? 75.7876;
    setState(() {});
  }

  _initTiles(DateTime date, String layertype) async {
    final String overlayId = date.millisecondsSinceEpoch.toString();

    final TileOverlay tileOverlay = TileOverlay(
      tileOverlayId: TileOverlayId(overlayId),
      tileProvider: ForecastTileProvider(
        dateTime: date,
        mapType: layertype,
        opacity: 0.8,
      ),
    );
    setState(() {
      _tileOverlay = tileOverlay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Layer',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.black),
          ),
        ),
        body: _buildMap(),
      ),
    );
  }

  Widget _buildMap() {
    final CameraPosition _initialPosition = CameraPosition(
      target: LatLng(_initialLat, _initialLng),
      zoom: 10,
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        GoogleMap(
          zoomControlsEnabled: false,
          myLocationEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: _initialPosition,
          onMapCreated: (GoogleMapController controller) {
            setState(() {
              _controller = controller;
            });
            _initTiles(_forecastDate, widget.layertype);
          },
          tileOverlays:
              _tileOverlay == null ? {} : <TileOverlay>{_tileOverlay!},
        )
      ],
    );
  }
}
