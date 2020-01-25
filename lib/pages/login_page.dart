import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:geo_maps/bloc/app_bloc.dart';
import 'package:geo_maps/bloc/bloc_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isEmployee = false;
  TextEditingController utec = TextEditingController();
  TextEditingController ptec = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  validateForm() {
    if (formKey.currentState.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    AppBLoC appBLoC = BLoCProvider.of<AppBLoC>(context);

    return Scaffold(
      body: Form(
        key: formKey,
        child: Center(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .3,
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: FlareActor(
                        'assets/WorldSpin.flr',
                        animation: 'roll',
                      ),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Geo Fencing",
                  style: TextStyle(
                    fontSize: 32.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: utec,
                  validator: (val) =>
                      val == "" || val == null ? "Required *" : val,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "User ID / Aadhar",
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: ptec,
                  validator: (val) =>
                      val == "" || val == null ? "Required *" : val,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: CheckboxListTile(
                  title: Text("Government Official"),
                  value: isEmployee,
                  onChanged: (isChanged) {
                    setState(() {
                      isEmployee = isChanged;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 4.0),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (isEmployee) {
                      appBLoC.isUserEmployee = true;
                      appBLoC.empId = utec.text;
                      utec.clear();
                    } else {
                      appBLoC.isUserEmployee = false;
                      appBLoC.userAadhar = utec.text;
                      utec.clear();
                    }
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
