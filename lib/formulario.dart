import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:flutter_share/flutter_share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class FormularioPage extends StatefulWidget {
  @override
  _FormularioPageState createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController cedulaController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController primerApellidoController = TextEditingController();
  TextEditingController segundoApellidoController = TextEditingController();
  TextEditingController edadController = TextEditingController();
  latLng.LatLng? currentLocation;
  MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    solicitarPermisosUbicacion();
  }

  void solicitarPermisosUbicacion() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      // Location permissions granted
      obtenerUbicacion();
    } else if (status.isDenied) {
      // Location permissions denied
      mostrarAlertaErrores('Permiso de localización denegado');
    } else if (status.isPermanentlyDenied) {
      // Location permissions permanently denied
      mostrarAlertaErrores('Permiso de localización denegado permanentemente');
    }
  }

  void mostrarAlertaErrores(String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void obtenerUbicacion() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        currentLocation = latLng.LatLng(position.latitude, position.longitude);
        print(currentLocation.toString());
      });
    } catch (e) {
      print('Error al obtener la ubicación: $e');
    }
  }

  void generarVinculo() async {
    solicitarPermisosUbicacion();
    if (_formKey.currentState!.validate()) {
      String cedula = cedulaController.text;
      String nombre = nombreController.text;
      String primerApellido = primerApellidoController.text;
      String segundoApellido = segundoApellidoController.text;
      String edad = edadController.text;

      String textoVinculo = 'Cedula:$cedula?';
      textoVinculo += 'Nombre:$nombre?';
      textoVinculo += 'PrimerApellido:$primerApellido?';
      textoVinculo += 'SegundoApellido:$segundoApellido?';
      textoVinculo += 'Edad:$edad?';
      textoVinculo += 'Ubicacion:$currentLocation?';

      String encodedText = textoVinculo;
      String url = 'https://www.lab4.com/$encodedText';

      await FlutterShare.share(
        title: 'Compartir',
        text: url,
        chooserTitle: 'Compartir en',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Sistema de Geolocalización Personal',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: cedulaController,
                    decoration: InputDecoration(
                      labelText: 'Cédula',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la cédula';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el nombre';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: primerApellidoController,
                    decoration: InputDecoration(
                      labelText: 'Primer Apellido',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el primer apellido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: segundoApellidoController,
                    decoration: InputDecoration(
                      labelText: 'Segundo Apellido',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el segundo apellido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: edadController,
                    decoration: InputDecoration(
                      labelText: 'Edad',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la edad';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Ubicación actual:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  if (currentLocation != null)
                    Container(
                      height: 200,
                      child: FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          center: currentLocation!,
                          zoom: 16.0,
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
                                point: currentLocation!,
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
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: generarVinculo,
                    child: Text(
                      'Generar Vínculo',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
