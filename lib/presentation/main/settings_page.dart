import 'package:flutter/material.dart';
import 'package:flutter_advance_mvvm/app/app_prefs.dart';
import 'package:flutter_advance_mvvm/app/di.dart';
import 'package:flutter_advance_mvvm/data/data_source/local_data_source.dart';
import 'package:flutter_advance_mvvm/presentation/resources/assets_manager.dart';
import 'package:flutter_advance_mvvm/presentation/resources/strings_manager.dart';
import 'package:flutter_svg/parser.dart';
import 'package:flutter_svg/svg.dart';

import '../resources/routes_manager.dart';
import '../resources/values_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  AppPreference _appPreference = instance<AppPreference>();
  LocalDataSource _localDataSource = instance<LocalDataSource>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(AppPadding.p8),
      children: [
        ListTile(
          title: Text(AppStrings.changeLanguage,style: Theme.of(context).textTheme.headline4,),
          leading: SvgPicture.asset(ImageAssets.changeLangIc),
          trailing: SvgPicture.asset(ImageAssets.settingsRightArrowIc),
          onTap: _changeLanguage,
        ),
        ListTile(
          title: Text(AppStrings.contactUs,style: Theme.of(context).textTheme.headline4),
          leading: SvgPicture.asset(ImageAssets.contactUsIc),
          trailing: SvgPicture.asset(ImageAssets.settingsRightArrowIc),
          onTap: _contactUs,
        ),
        ListTile(
          title: Text(AppStrings.inviteYourFriends,style: Theme.of(context).textTheme.headline4),
          leading: SvgPicture.asset(ImageAssets.inviteFriendIc),
          trailing: SvgPicture.asset(ImageAssets.settingsRightArrowIc),
          onTap: _inviteFriends,
        ),
        ListTile(
          title: Text(AppStrings.logout,style: Theme.of(context).textTheme.headline4),
          leading: SvgPicture.asset(ImageAssets.logoutIc),
          trailing: SvgPicture.asset(ImageAssets.settingsRightArrowIc),
          onTap: _logout,
        )
      ],
    );
  }
  void _changeLanguage(){

  }
  void _contactUs(){

  }

  void _inviteFriends(){

  }
  void _logout()
  {
  _localDataSource.clearCache();
  _appPreference.logout();
  Navigator.of(context).pushReplacementNamed(Routes.loginRoute);
  }
}
