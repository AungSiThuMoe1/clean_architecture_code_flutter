import 'package:flutter/material.dart';
import 'package:flutter_advance_mvvm/presentation/resources/color_manager.dart';
import 'package:flutter_advance_mvvm/presentation/resources/values_manager.dart';


import '../resources/strings_manager.dart';
import 'home/home_page.dart';
import 'notifications_page.dart';
import 'search_page.dart';
import 'settings_page.dart';
class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<Widget> pages = [
    HomePage(),
    SearchPage(),
    NotificationsPage(),
    SettingsPage(),
  ];

  List<String> titles = [
    AppStrings.home,
    AppStrings.search,
    AppStrings.notifications,
    AppStrings.setting
  ];

  var _title =  AppStrings.home;
  var _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title,style: Theme.of(context).textTheme.headline2,),),
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: ColorManager.lightGrey,spreadRadius: AppSize.s1,)
          ]
        ),
        child: BottomNavigationBar(
          selectedItemColor: ColorManager.primary,
          unselectedItemColor: ColorManager.grey,
          currentIndex: _currentIndex,
          onTap: onTap,
          items:const [
            BottomNavigationBarItem(icon: Icon(Icons.home),label: AppStrings.home),
            BottomNavigationBarItem(icon: Icon(Icons.search),label: AppStrings.search),
            BottomNavigationBarItem(icon: Icon(Icons.notifications),label: AppStrings.notifications),
            BottomNavigationBarItem(icon: Icon(Icons.settings),label: AppStrings.setting),
          ],
        ),
      ),
    );
  }
  onTap(int index){
    setState((){
      _currentIndex = index;
     _title = titles[index];
    });

  }
}
