import 'package:firebase/firebase.dart';
import 'package:firebase_database/firebase_database.dart';

class DBManager {
  // Singleton Pattern

  static final DBManager _singleton = new DBManager._internal();

  factory DBManager() {
    return _singleton;
  }

  DBManager._internal() {
    FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  }
}
