import 'package:flutter/material.dart';
import 'package:flutter_advance_mvvm/presentation/common/state_renderer/state_render_impl.dart';
import 'package:flutter_advance_mvvm/presentation/forgot_password/forgot_password_viewmodel.dart';
import 'package:flutter_advance_mvvm/presentation/resources/color_manager.dart';
import 'package:flutter_advance_mvvm/presentation/resources/strings_manager.dart';

import '../../app/di.dart';
import '../resources/assets_manager.dart';
import '../resources/values_manager.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  ForgotPasswordViewModel _forgotPasswordViewModel = instance<ForgotPasswordViewModel>();
  TextEditingController _emailController = TextEditingController();
  _bind() {
    _forgotPasswordViewModel.start();
    _emailController.addListener(() {
      _forgotPasswordViewModel.setEmail(_emailController.text);
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
    _forgotPasswordViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorManager.white,
        body: StreamBuilder<FlowState>(
          stream: _forgotPasswordViewModel.outputState,
          builder: (context, snapshot) {
            return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                    () {
                  _forgotPasswordViewModel.forgotPassword();
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
                stream: _forgotPasswordViewModel.outputIsUserNameValid,
                builder: (context, snapshot) {
                  return TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: InputDecoration(
                        hintText: AppStrings.email,
                        labelText: AppStrings.email,
                        errorText: (snapshot.data ?? true)
                            ? null
                            : AppStrings.emailError),
                  );
                }),
          ),
          const SizedBox(height: AppSize.s28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p28),
            child: StreamBuilder<bool>(
                stream: _forgotPasswordViewModel.outputIsAllInputsValid,
                builder: (context, snapshot) {
                  return SizedBox(
                    width: double.infinity,
                    height: AppSize.s40,
                    child: ElevatedButton(
                        onPressed: (snapshot.data ?? false)
                            ? () {
                                _forgotPasswordViewModel.forgotPassword();
                              }
                            : null,
                        child: const Text(AppStrings.ResetPassword)),
                  );
                }),
          )
        ]),
      )),
    );
  }
}
