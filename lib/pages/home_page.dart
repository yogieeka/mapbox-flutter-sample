import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:test_drive/constants/app_constants.dart';
import 'package:test_drive/model/map.dart';
import 'package:test_drive/model/map_marker_model.dart';
import 'package:http/http.dart' as http;

Future<PurpleMap> fetchMapData() async {
  final response = await http.get(Uri.parse(
      'https://geoserver.mapid.io/layers_new/get_layer?api_key=689c2279e0834a3ba82743432605e746&layer_id=628f1d7c84b953e79a7cd896&project_id=611eafa6be8a2635e15c4afc'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return PurpleMap.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

extension ColorExtension on String {
  toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final pageController = PageController();
  int selectedIndex = 0;
  var currentLocation = AppConstants.myLocation;

  late final MapController mapController;
  final PopupController _popupLayerController = PopupController();

  late Future<PurpleMap> futureMap;

  @override
  void initState() {
    super.initState();
    futureMap = fetchMapData();
    mapController = MapController();
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 6), radix: 16) + 0xFF000000);
  }

  Color getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');

    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }

    return Color(int.parse(hexColor, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 32, 32),
        title: const Text('Flutter MapBox'),
      ),
      body: Stack(
        children: [
          FutureBuilder<PurpleMap>(
            future: futureMap,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                      minZoom: 5,
                      maxZoom: 18,
                      initialCenter: const LatLng(-6.902498, 107.618775),
                      onTap: (_, __) {
                        _popupLayerController.hideAllPopups();
                      }),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiczNhZGJjIiwiYSI6ImNsb2ZtYXVpYTBiczMyam55bzdmdmd3Z3QifQ.i68Rzbrg2RAJRItp_4_JrQ",
                    ),
                    MarkerLayer(
                      markers: [
                        for (int i = 0;
                            i < snapshot.data!.geojson.features.length;
                            i++)
                          Marker(
                            width: 140.0,
                            height: 140.0,
                            point: LatLng(
                                snapshot.data!.geojson.features[i].geometry
                                    .coordinates[1],
                                snapshot.data!.geojson.features[i].geometry
                                    .coordinates[0]),
                            child: InkWell(
                              onTap: () {
                                pageController.animateToPage(
                                  i,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                                selectedIndex = i;
                                currentLocation = LatLng(
                                    snapshot
                                        .data!
                                        .geojson
                                        .features[selectedIndex]
                                        .geometry
                                        .coordinates[1],
                                    snapshot
                                        .data!
                                        .geojson
                                        .features[selectedIndex]
                                        .geometry
                                        .coordinates[0]);
                                _animatedMapMove(currentLocation, 11.5);
                                setState(() {});
                              },
                              // onTap: () =>
                              //     _popupLayerController.hideAllPopups(),

                              child: Icon(
                                size: 40,
                                Icons.place,
                                color: snapshot.data!.geojson.features[i]
                                            .properties.Status ==
                                        'Merah'
                                    ? Colors.red
                                    : snapshot.data!.geojson.features[i]
                                                .properties.Status ==
                                            'Hijau'
                                        ? Colors.green
                                        : Colors.yellow,
                              ),
                            ),
                          ),
                      ],
                    ),

                    // PopupMarkerLayer(
                    //   options: PopupMarkerLayerOptions(
                    //     markers: <Marker>[
                    //       for (int i = 0;
                    //           i < snapshot.data!.geojson.features.length;
                    //           i++)
                    //         Marker(
                    //           alignment: Alignment.topCenter,
                    //           point: LatLng(
                    //               snapshot.data!.geojson.features[i].geometry
                    //                   .coordinates[1],
                    //               snapshot.data!.geojson.features[i].geometry
                    //                   .coordinates[0]),
                    //           child: const Icon(
                    //               size: 40, Icons.place, color: Colors.red),
                    //         ),
                    //     ],
                    //     popupController: _popupLayerController,
                    //     popupDisplayOptions: PopupDisplayOptions(
                    //       builder: (_, Marker marker) {
                    //         return const Card(
                    //             color: Colors.white,
                    //             child: Padding(
                    //               padding: EdgeInsets.all(10),
                    //               child: Column(
                    //                 mainAxisSize: MainAxisSize.min,
                    //                 children: <Widget>[
                    //                   Text('Nama',
                    //                       style: TextStyle(
                    //                           fontSize: 12,
                    //                           color: Colors.lightBlue,
                    //                           fontWeight: FontWeight.bold)),
                    //                   Text('The Enchanted Nightingale',
                    //                       style: TextStyle(
                    //                           color: Colors.black,
                    //                           fontWeight: FontWeight.bold)),
                    //                   SizedBox(
                    //                     height: 10,
                    //                   ),
                    //                   Text('Status',
                    //                       style: TextStyle(
                    //                           fontSize: 12,
                    //                           color: Colors.lightBlue,
                    //                           fontWeight: FontWeight.bold)),
                    //                   Text('The Enchanted Nightingale',
                    //                       style: TextStyle(
                    //                           color: Colors.black,
                    //                           fontWeight: FontWeight.bold)),
                    //                   SizedBox(
                    //                     height: 10,
                    //                   ),
                    //                   Text('Status',
                    //                       style: TextStyle(
                    //                           fontSize: 12,
                    //                           color: Colors.lightBlue,
                    //                           fontWeight: FontWeight.bold)),
                    //                   Text('The Enchanted Nightingale',
                    //                       style: TextStyle(
                    //                           color: Colors.black,
                    //                           fontWeight: FontWeight.bold))
                    //                 ],
                    //               ),
                    //             ));
                    //       },
                    //     ),
                    //   ),
                    // ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 2,
            height: 140,
            child: FutureBuilder<PurpleMap>(
              future: futureMap,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return PageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: pageController,
                      onPageChanged: (value) {
                        selectedIndex = value;
                        currentLocation = currentLocation = LatLng(
                            snapshot.data!.geojson.features[value].geometry
                                .coordinates[1],
                            snapshot.data!.geojson.features[value].geometry
                                .coordinates[0]);

                        _animatedMapMove(currentLocation, 12.5);
                        setState(() {});
                      },
                      // itemCount: mapMarkers.length,
                      itemCount: snapshot.data!.geojson.features.length,
                      itemBuilder: (_, index) {
                        final item = snapshot.data!.geojson.features[index];
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: Colors.white,
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // const SizedBox(height: 10),
                                      Text(
                                        'Nama : ' + item.properties.Nama,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Status : ' + item.properties.Status,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Angka : ' + item.properties.Angka,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          )
        ],
      ),
    );
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
}
