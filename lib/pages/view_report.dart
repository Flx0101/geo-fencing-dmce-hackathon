import 'package:flutter/material.dart';
import 'package:geo_maps/bloc/app_bloc.dart';
import 'package:geo_maps/bloc/bloc_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewReport extends StatefulWidget {
  @override
  _ViewReportState createState() => _ViewReportState();
}

class _ViewReportState extends State<ViewReport> {
  @override
  Widget build(BuildContext context) {
    AppBLoC appBLoC = BLoCProvider.of<AppBLoC>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("View Forms"),
      ),
      body: appBLoC.forms.isEmpty
          ? Center(
              child: Text("No Records Yet"),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int pos) {
                return !appBLoC.isUserEmployee
                    ? appBLoC.forms[pos].userAadhar == appBLoC.userAadhar
                        ? ExpansionTile(
                            title:
                                Text("User - ${appBLoC.forms[pos].userName}"),
                            subtitle:
                                Text("Season - ${appBLoC.forms[pos].season}"),
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                height: 126.0,
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target:
                                        appBLoC.forms[pos].polygon.points.first,
                                    zoom: 10.5,
                                  ),
                                  polygons:
                                      Set.of([appBLoC.forms[pos].polygon]),
                                ),
                              ),
                            ],
                          )
                        : Container()
                    : ExpansionTile(
                        title: Text("User - ${appBLoC.forms[pos].userName}"),
                        subtitle: Text("Season - ${appBLoC.forms[pos].season}"),
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: 126.0,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: appBLoC.forms[pos].polygon.points.first,
                                zoom: 10.5,
                              ),
                              polygons: Set.of([appBLoC.forms[pos].polygon]),
                            ),
                          ),
                        ],
                      );
              },
              itemCount: appBLoC.forms.length,
            ),
    );
  }
}
