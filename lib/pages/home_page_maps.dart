import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geo_maps/bloc/app_bloc.dart';
import 'package:geo_maps/bloc/bloc_provider.dart';
import 'package:geo_maps/models/form_712.dart';
import 'package:geo_maps/pages/add_form.dart';
import 'package:geo_maps/pages/view_report.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OptionButton extends StatelessWidget {
  final Color color;
  final Function onPressed;
  final IconData icon;

  const OptionButton({Key key, this.color, this.onPressed, this.icon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        minRadius: 36.0,
        backgroundColor: color,
        child: IconButton(
          icon: Icon(
            icon,
            size: 32.0,
          ),
          color: Colors.white,
          onPressed: () {
            onPressed();
          },
        ),
      ),
    );
  }
}

class HomePageMaps extends StatefulWidget {
  HomePageMaps({Key key}) : super(key: key);

  @override
  _HomePageMapsState createState() => _HomePageMapsState();
}

class _HomePageMapsState extends State<HomePageMaps> {
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
  }

  double zoomVal = 5.0;

  List<LatLng> polyPoints = <LatLng>[];
  List<Polygon> polyGons = <Polygon>[];

  @override
  Widget build(BuildContext context) {
    AppBLoC appBLoC = BLoCProvider.of<AppBLoC>(context);
    return new Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              /*NavigationHelper.navigatetoBack(context);*/
            }),
        title: Text("Add Land Area"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
          IconButton(
            icon: Icon(Icons.event_note),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return ViewReport();
              }));
            },
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            _buildGoogleMap(context),
            appBLoC.isUserEmployee
                ? Positioned(
                    bottom: 32.0,
                    right: 16.0,
                    left: 16.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        OptionButton(
                          color: Colors.green,
                          onPressed: getUserLocation,
                          icon: Icons.add_location,
                        ),
                        // OptionButton(
                        //   color: Colors.red,
                        //   onPressed: deleteLast,
                        //   icon: Icons.location_off,
                        // ),
                        OptionButton(
                          color: Colors.blue,
                          onPressed: completePath,
                          icon: Icons.save,
                        )
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
      floatingActionButton: !appBLoC.isUserEmployee
          ? FloatingActionButton(
              onPressed: () {
                Iterable<Form712> forms = appBLoC.forms
                    .where((form) => form.userAadhar == appBLoC.userAadhar);
                  print(appBLoC.userAadhar);
                if (forms.isNotEmpty) {
                  setState(() {
                    forms.map((f) {
                      polyGons.add(Polygon(
                        polygonId: f.polygon.polygonId,
                        points: f.polygon.points,
                      ));
                    });
                  });
                }
              },
              child: Icon(Icons.location_on),
            )
          : null,
    );
  }

  getUserLocation() {
    setState(() {
      markers.values.forEach((value) {
        polyPoints.add(value.position);
      });
    });
    print(polyPoints);
    print("User Location");
  }

  deleteLast() {
    setState(() {
      if (polyPoints.isNotEmpty) {
        polyPoints.removeLast();
      }
    });
    print("Delete Last");
  }

  completePath() {
    print(polyPoints);
    Polygon polygon = Polygon(
        polygonId: PolygonId("${polyGons.length}"),
        points: List.from(polyPoints),
        fillColor: Colors.blue.withOpacity(0.8),
        strokeWidth: 2,
        onTap: () {});

    if (polyPoints.isNotEmpty) {
      setState(() {
        polyGons.add(polygon);
      });
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => AddForm(
                polygon: polygon,
              )));
      polyPoints.clear();
    }
  }

  Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(40.712776, -74.005974), zoom: zoomVal)));
  }

  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(40.712776, -74.005974), zoom: zoomVal)));
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition:
            CameraPosition(target: LatLng(40.712776, -74.005974), zoom: 12),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        polygons: polyGons.isNotEmpty ? Set.of(polyGons) : Set(),
        markers:
            markers.values.isNotEmpty ? Set<Marker>.of(markers.values) : Set(),
        onLongPress: (LatLng latLng) {
          final MarkerId markerId = MarkerId('4544');
          final Marker marker = Marker(
            markerId: markerId,
            position: latLng,
          );

          setState(() {
            markers.clear();
            markers[markerId] = marker;
          });
        },
      ),
    );
  }
}
