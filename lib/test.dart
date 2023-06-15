import 'package:flutter/material.dart';
import 'package:flutter_advance_mvvm/app/app.dart';
class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  void updateAppState(){
    MyApp.instance.appState = 10;
  }

  void getAppState(){
    debugPrint(MyApp.instance.appState.toString()); // 10
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
