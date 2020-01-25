import 'dart:async';
import 'package:geo_maps/bloc/base_bloc.dart';
import 'package:geo_maps/models/form_712.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

class AppBLoC implements BaseBLoC {
  Set<Polygon> points = Set();
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();
  bool isUserEmployee = false;
  int count = 0;
  String empId = "";
  String userAadhar = "";

  List<LatLng> polyPoints = <LatLng>[];
  List<Polygon> polyGons = <Polygon>[];
  List<Form712> forms = <Form712>[];

  void addForm(Form712 form) {
    forms.add(form);
  }

  Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  final CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(19.27152, 72.96801000000005),
    zoom: 16.4746,
  );

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
