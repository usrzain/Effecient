// ignore_for_file: avoid_print, unused_field, prefer_const_constructors, prefer_final_fields,    library_private_types_in_public_api

// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  Location _location = Location();
  Set<Marker> _markers = {};

  LatLng _initialPosition = LatLng(24.8607, 67.0011);

  // Create a Variable for Loading

  bool loading = false;

  DatabaseReference ref = FirebaseDatabase.instance.ref("Locations");

  @override
  void initState() {
    super.initState();
    readData();
  }

  // -------------  Read Data
  Future<void> readData() async {
    try {
      // Fetch current location
      LocationData currentLocation = await _location.getLocation();
      print('kdvn edinvekvnevneivne');
      print(currentLocation);

      // Fetch data from the database
      ref.onValue.listen((event) {
        DataSnapshot snapshot = event.snapshot;

        if (snapshot.value != null) {
          // Accessing data using key-value pairs
          print(snapshot
              .value.runtimeType); // type comes as _Map<Object?, Object?>
          print(snapshot.value);
          // Map<String, dynamic>? data = snapshot.value as Map<String, dynamic>?;
          Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
          print(data.runtimeType);
          print('fetched data is = ');
          print(data);
          if (data == null) {
            print('No data TRANSFERED ');
          }

          if (data != null) {
            print('data : ');
            print(data);
            setState(() {
              _markers.clear();

              // Add marker for the current location
              _markers.add(
                Marker(
                    markerId: const MarkerId('current_location'),
                    position: LatLng(
                      currentLocation.latitude ?? 0.0,
                      currentLocation.longitude ?? 0.0,
                    ),
                    infoWindow: const InfoWindow(title: 'Your Location'),
                    icon: BitmapDescriptor.defaultMarker),
              );

              // Add markers for locations from the database
              data.forEach((key, value) {
                String title = value['title'];

                //  Converting the String values of latitude and Longitudes to double data type
                double lati;
                double long;

                if (value['Latitude'].runtimeType == String ||
                    value['Longitude'].runtimeType == String) {
                  lati = double.parse(value['Latitude']);
                  long = double.parse(value['Longitude']);

                  print(value['title']);
                  print(lati.runtimeType);
                  print(long.runtimeType);
                } else {
                  lati = value['Latitude'];
                  long = value['Longitude'];
                  // print(value['title']);
                  // print(' already a Double ');
                }

                _markers.add(
                  Marker(
                    markerId: MarkerId(title),
                    position: LatLng(lati, long
                        // value['Latitude'] ?? 0.0,
                        // value['Longitude'] ?? 0.0,
                        ),
                    infoWindow: InfoWindow(title: title),
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Container(
                            height: 200,
                            color: Colors.amber,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(title),
                                  ElevatedButton(
                                    child: const Text('Close BottomSheet'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  const Text('b')
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              });
            });

            print(_markers.runtimeType);
          }
        } else {
          // Handle the case where snapshot.value is null
          print("Data is null");
        }
      });
    } catch (e) {
      // Handle errors for both getting current location and fetching data
      print("Error: $e");
    }
  }

  // --------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Visibility(
            visible: _markers.isNotEmpty,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 15.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              markers: _markers,
            ),
          ),
          Visibility(
            visible: _markers.isEmpty,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          // Additional widgets can be added based on your requirements
        ],
      ),
    );
  }
}
