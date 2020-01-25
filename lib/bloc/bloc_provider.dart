import 'package:flutter/widgets.dart';

class BLoCProvider<T> extends InheritedWidget {
  final T bloc;
  final Widget child;

  BLoCProvider({@required this.bloc, @required this.child});

  static T of<T>(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<BLoCProvider<T>>()).bloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}
