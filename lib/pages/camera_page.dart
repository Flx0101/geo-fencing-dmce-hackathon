import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geo_maps/bloc/app_bloc.dart';
import 'package:geo_maps/bloc/bloc_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool isTracking = false;

  CameraController cameraController;
  List<CameraDescription> cameras = [];

  Future initCamera() async {
    cameras = await availableCameras();
    cameraController =
        CameraController(cameras.first, ResolutionPreset.ultraHigh);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Completer<GoogleMapController> mapController = Completer();

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  toggleTracking() {
    setState(() {
      isTracking = !isTracking;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppBLoC appBLoC = BLoCProvider.of<AppBLoC>(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          cameraController != null
              ? cameraController.value.isInitialized
                  ? Positioned.fill(child: CameraPreview(cameraController))
                  : Container()
              : Center(
                  child: CircularProgressIndicator(),
                ),
          Positioned(
            bottom: 24.0,
            child: TrackButton(
              isTracking: isTracking,
              onTrackingStart: () {
                toggleTracking();
              },
              onTrackingStop: () {
                toggleTracking();
                // appBLoC.addPoints(count: appBLoC.count);
                appBLoC.count++;
                Navigator.of(context).pop();
              },
            ),
          ),
          isTracking
              ? Center(
                  child: Icon(
                    Icons.navigation,
                    size: 48.0,
                    color: Colors.blue,
                  ),
                )
              : Container(),
          isTracking
              ? Positioned(
                  bottom: 86,
                  right: 12,
                  child: Opacity(
                    opacity: 0.8,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: appBLoC.kGooglePlex,
                        onMapCreated: (GoogleMapController controller) {
                          mapController.complete(controller);
                        },
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class TrackButton extends StatelessWidget {
  final bool isTracking;
  final Function onTrackingStart;
  final Function onTrackingStop;

  const TrackButton(
      {Key key, this.onTrackingStart, this.isTracking, this.onTrackingStop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      onPressed: isTracking ? onTrackingStart : onTrackingStop,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32.0),
      ),
      color: isTracking ? Colors.redAccent : Colors.blue,
      icon: Icon(
        Icons.navigation,
        color: Colors.white,
        size: 32.0,
      ),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          "Track",
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
