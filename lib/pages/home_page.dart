import 'package:flutter/material.dart';
import 'package:geo_maps/bloc/app_bloc.dart';
import 'package:geo_maps/bloc/bloc_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  final Function onTap;

  const HomePage({Key key, this.onTap}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int counter = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBLoC appBLoC = BLoCProvider.of<AppBLoC>(context);
    List<Marker> markers = [];

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              appBLoC.isUserEmployee = false;
              appBLoC.points.clear();
              appBLoC.count = 0;
              Navigator.of(context).pushReplacementNamed('/splash');
            },
          ),
        ],
      ),
      body: Builder(
        builder: (BuildContext context) => Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned.fill(
              child: GoogleMap(
                mapType: MapType.satellite,
                markers: Set.from(markers),
                onTap: (LatLng latLng) {},
                initialCameraPosition: appBLoC.kGooglePlex,
                polygons: appBLoC.points,
                onMapCreated: (GoogleMapController controller) {
                  if (!appBLoC.mapController.isCompleted) {
                    appBLoC.mapController.complete(controller);
                  }
                },
              ),
            ),
            !appBLoC.isUserEmployee
                ? Positioned(
                    bottom: 68.0,
                    child: Container(
                      width: 566.0,
                      height: 68.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int pos) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.network(
                                      "https://www.excelcropcare.com/images/homepage/overviewbg-res.jpg",
                                      fit: BoxFit.cover,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Crop $pos"),
                                    ),
                                  ],
                                )),
                          );
                        },
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
      floatingActionButton: appBLoC.isUserEmployee == true
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/camera');
              },
              child: Icon(Icons.video_call),
            )
          : FloatingActionButton(
              onPressed: () async {
                final GoogleMapController controller =
                    await appBLoC.mapController.future;
                controller.animateCamera(
                    CameraUpdate.newCameraPosition(appBLoC.kGooglePlex));
              },
              child: Icon(Icons.location_on),
            ),
    );
  }
}
