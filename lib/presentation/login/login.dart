import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_advance_mvvm/app/app_prefs.dart';
import 'package:flutter_advance_mvvm/presentation/common/state_renderer/state_render_impl.dart';
import 'package:flutter_advance_mvvm/presentation/login/login_viewmodel.dart';
import 'package:flutter_advance_mvvm/presentation/resources/color_manager.dart';
import 'package:flutter_advance_mvvm/presentation/resources/strings_manager.dart';
import 'package:flutter_advance_mvvm/presentation/resources/values_manager.dart';
import '../../app/di.dart';
import '../resources/assets_manager.dart';
import '../resources/routes_manager.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoginViewModel _loginViewModel = instance<LoginViewModel>();
  AppPreference _appPreference = instance<AppPreference>();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  _bind() {
    _loginViewModel.start();
    _userNameController.addListener(() {
      _loginViewModel.setUserName(_userNameController.text);
    });
    _passwordController.addListener(() {
      _loginViewModel.setPassword(_passwordController.text);
    });
    _loginViewModel.isUserLoggedInSuccessfullyStreamController.stream
        .listen((event) {
      // navigate to main screen
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _appPreference.setIsUserLoggedIn();
        Navigator.of(context).pushNamed(Routes.mainRoute);
      });
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  void dispose() {
    _loginViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorManager.white,
        body: StreamBuilder<FlowState>(
          stream: _loginViewModel.outputState,
          builder: (context, snapshot) {
            return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                    () {
                  _loginViewModel.login();
                }) ??
                _getContentWidget();
          },
        ));
  }

  Widget _getContentWidget() {
    return Container(
      padding: const EdgeInsets.only(top: AppPadding.p100),
      child: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(children: [
          Image.asset(ImageAssets.splashLogo),
          const SizedBox(height: AppSize.s28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p28),
            child: StreamBuilder<bool>(
                stream: _loginViewModel.outputIsUserNameValid,
                builder: (context, snapshot) {
                  return TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _userNameController,
                    decoration: InputDecoration(
                        hintText: AppStrings.username,
                        labelText: AppStrings.username,
                        errorText: (snapshot.data ?? true)
                            ? null
                            : AppStrings.usernameError),
                  );
                }),
          ),
          const SizedBox(height: AppSize.s28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p28),
            child: StreamBuilder<bool>(
                stream: _loginViewModel.outputIsPasswordValid,
                builder: (context, snapshot) {
                  return TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordController,
                    decoration: InputDecoration(
                        hintText: AppStrings.password,
                        labelText: AppStrings.password,
                        errorText: (snapshot.data ?? true)
                            ? null
                            : AppStrings.passwordError),
                  );
                }),
          ),
          const SizedBox(height: AppSize.s28),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p28,
            ),
            child: StreamBuilder<bool>(
                stream:
                    _loginViewModel.outputIsAllInputsValid, // todo add me later
                builder: (context, snapshot) {
                  return SizedBox(
                    width: double.infinity,
                    height: AppSize.s40,
                    child: ElevatedButton(
                        onPressed: (snapshot.data ?? false)
                            ? () {
                                _loginViewModel.login();
                              }
                            : null,
                        child: const Text(AppStrings.login)),
                  );
                }),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: AppPadding.p8,
              left: AppPadding.p28,
              right: AppPadding.p28,
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, Routes.forgotPasswordRoute);
                      },
                      child: Text(
                        AppStrings.forgetPassword,
                        style: Theme.of(context).textTheme.subtitle2,
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, Routes.registerRoute);
                      },
                      child: Text(
                        AppStrings.registerText,
                        style: Theme.of(context).textTheme.subtitle2,
                      )),
                ]),
          )
        ]),
      )),
    );
  }
}
