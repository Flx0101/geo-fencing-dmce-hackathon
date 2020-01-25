import 'package:flutter/material.dart';
import 'package:geo_maps/bloc/app_bloc.dart';
import 'package:geo_maps/bloc/bloc_provider.dart';
import 'package:geo_maps/models/form_712.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  TextInputType inputType = TextInputType.text;

  CustomTextField({Key key, this.controller, this.hintText, this.inputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: hintText,
        ),
      ),
    );
  }
}

class AddForm extends StatefulWidget {
  final Polygon polygon;

  const AddForm({Key key, this.polygon}) : super(key: key);
  @override
  _AddFormState createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final TextEditingController area = TextEditingController();
  final TextEditingController cropName = TextEditingController();
  final TextEditingController userName = TextEditingController();
  final TextEditingController year = TextEditingController();
  final TextEditingController season = TextEditingController();
  final TextEditingController aadhar = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppBLoC appBLoC = BLoCProvider.of<AppBLoC>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Submit Form 7/12"),
      ),
      body: Form(
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            CustomTextField(
              controller: aadhar,
              hintText: "Aadhar Number",
            ),
            CustomTextField(
              controller: cropName,
              hintText: "Crop Name",
            ),
            CustomTextField(
              controller: userName,
              hintText: "Owner Name",
            ),
            CustomTextField(
              controller: year,
              hintText: "Year",
              inputType: TextInputType.number,
            ),
            CustomTextField(
              controller: season,
              hintText: "Season",
            ),
            CustomTextField(
              controller: area,
              hintText: "Area in Sq.Mtrs",
              inputType: TextInputType.numberWithOptions(decimal: true),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text("Submit"),
                onPressed: () {
                  appBLoC.addForm(
                    Form712(
                      areaInSqMtr: double.parse(area.text),
                      empId: appBLoC.empId,
                      userAadhar: aadhar.text,
                      year: int.parse(year.text),
                      cropName: cropName.text,
                      season: season.text,
                      userName: userName.text,
                      polygon: widget.polygon,
                    ),
                  );
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
