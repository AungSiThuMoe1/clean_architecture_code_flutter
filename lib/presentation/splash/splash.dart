import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_advance_mvvm/presentation/resources/assets_manager.dart';
import 'package:flutter_advance_mvvm/presentation/resources/routes_manager.dart';
import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../resources/color_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late Timer _timer;
  AppPreference _appPreference = instance<AppPreference>();
  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), _goNext);
  }

  _goNext() async {
    _appPreference.isUserLoggedIN().then((isUserLoggedIn) {
      if (isUserLoggedIn) {
        Navigator.pushReplacementNamed(context, Routes.mainRoute);
      } else {
        _appPreference
            .isOnBoardingScreenViewed()
            .then((isOnBoardingScreenViewed) {
          if (isOnBoardingScreenViewed) {
            Navigator.pushReplacementNamed(context, Routes.loginRoute);
          } else {
            Navigator.pushReplacementNamed(context, Routes.onBoardingRoute);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body:
          const Center(child: Image(image: AssetImage(ImageAssets.splashLogo))),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}
