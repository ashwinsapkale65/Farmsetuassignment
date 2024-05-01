import 'package:farm_setu/providers/layer_provider.dart';
import 'package:farm_setu/view/layers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget showmap() {
  return Consumer<LayerTypeProvider>(
    builder: (context, layerTypeProvider, child) {
      return SizedBox(
        height: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Layer Type: "),
            DropdownButton<String>(
              value: layerTypeProvider.selectedLayerType,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  layerTypeProvider.update(newValue);
                }
              },
              items: ['Precipitation', 'Temperature']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              
              onPressed: () {
                String layerType = layerTypeProvider.selectedLayerType;
                if (layerType == 'Precipitation') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GenrateLayer(layertype: "PR0"),
                    ),
                  );
                } else if (layerType == 'Temperature') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GenrateLayer(layertype: "TA2"),
                    ),
                  );
                }
              },
              child: Text('Show Map'),
            ),
          ],
        ),
      );
    },
  );
}
