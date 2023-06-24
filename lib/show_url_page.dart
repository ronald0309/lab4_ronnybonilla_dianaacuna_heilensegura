import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class InformacionPage extends StatefulWidget {
  @override
  _InformacionPageState createState() => _InformacionPageState();
}

class _InformacionPageState extends State<InformacionPage> {
  TextEditingController urlController = TextEditingController();
  String? cedula;
  String? nombre;
  String? primerApellido;
  String? segundoApellido;
  String? edad;
  String? ubicacionString;
  LatLng? ubicacion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: TextFormField(
                  controller: urlController,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    labelText: 'URL',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    String url = urlController.text;
                    extractDataFromText(url);

                    // Actualizar la vista
                    setState(() {});
                  },
                  child: Text(
                    'Mostrar Datos',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Datos:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Cédula: $cedula',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Nombre: $nombre',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Primer Apellido: $primerApellido',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Segundo Apellido: $segundoApellido',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Edad: $edad',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Ubicación:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              if (ubicacion != null)
                Container(
                  height: 200,
                  child: FlutterMap(
                    options: MapOptions(
                      center: ubicacion!,
                      zoom: 14,
                    ),
                    layers: [
                      TileLayerOptions(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayerOptions(
                        markers: [
                          Marker(
                            width: 40.0,
                            height: 40.0,
                            point: ubicacion!,
                            builder: (ctx) => Container(
                              child: Icon(
                                Icons.location_pin,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void extractDataFromText(String text) {
    cedula = extractValueFromText(text, 'Cedula:');
    nombre = extractValueFromText(text, 'Nombre:');
    primerApellido = extractValueFromText(text, 'PrimerApellido:');
    segundoApellido = extractValueFromText(text, 'SegundoApellido:');
    edad = extractValueFromText(text, 'Edad:');
    ubicacionString = extractValueFromText(text, 'Ubicacion:');

    // Convertir la ubicación a LatLng
    if (ubicacionString != null) {
      final regex = RegExp(r'LatLng\(latitude:(.*), longitude:(.*)\)');
      final match = regex.firstMatch(ubicacionString!);
      if (match != null && match.groupCount == 2) {
        double latitud = double.parse(match.group(1)!);
        double longitud = double.parse(match.group(2)!);
        ubicacion = LatLng(latitud, longitud);
      }
    }
  }

  String? extractValueFromText(String text, String key) {
    int startIndex = text.indexOf(key);
    if (startIndex != -1) {
      int endIndex = text.indexOf('?', startIndex);
      if (endIndex != -1) {
        return text.substring(startIndex + key.length, endIndex);
      }
    }
    return null;
  }
}
