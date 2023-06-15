import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_advance_mvvm/presentation/common/state_renderer/state_render_impl.dart';
import 'package:flutter_advance_mvvm/presentation/register/register_viewmodel.dart';
import 'package:flutter_advance_mvvm/presentation/resources/color_manager.dart';
import 'package:flutter_advance_mvvm/presentation/resources/values_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../../data/mapper/mapper.dart';
import '../resources/assets_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/strings_manager.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterViewModel _viewModel = instance<RegisterViewModel>();
  ImagePicker picker = instance<ImagePicker>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _mobileNumberTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final AppPreference _appPreference = instance<AppPreference>();
  @override
  void initState() {
    _bind();
    super.initState();
  }

  _bind() {
    _viewModel.start();
    _userNameTextEditingController.addListener(() {
      _viewModel.setUserName(_userNameTextEditingController.text);
    });
    _passwordTextEditingController.addListener(() {
      _viewModel.setPassword(_passwordTextEditingController.text);
    });
    _emailTextEditingController.addListener(() {
      _viewModel.setEmail(_emailTextEditingController.text);
    });
    _mobileNumberTextEditingController.addListener(() {
      _viewModel.setMobileNumber(_mobileNumberTextEditingController.text);
    });
    _viewModel.isUserLoggedInSuccessfullyStreamController.stream.listen((isSuccessLoggedIn) {
     SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
       _appPreference.setIsUserLoggedIn();
       Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
     });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          elevation: AppSize.s0,
          iconTheme: IconThemeData(color: ColorManager.primary),
          backgroundColor: ColorManager.white,
        ),
        body: StreamBuilder<FlowState>(
          stream: _viewModel.outputState,
          builder: (context, snapshot) {
            return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                    () {
                  _viewModel.register();
                }) ??
                _getContentWidget();
          },
        ));
  }

  Widget _getContentWidget() {
    return Container(
      padding: const EdgeInsets.only(top: AppPadding.p60),
      child: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(children: [
          Image.asset(ImageAssets.splashLogo),
          const SizedBox(height: AppSize.s28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p28),
            child: StreamBuilder<String?>(
                stream: _viewModel.outputErrorUserName,
                builder: (context, snapshot) {
                  return TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _userNameTextEditingController,
                      decoration: InputDecoration(
                        hintText: AppStrings.username,
                        labelText: AppStrings.username,
                        errorText: snapshot.data,
                      ));
                }),
          ),
          Center(
            child: Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28,
                    right: AppPadding.p28,
                    top: AppPadding.p28,
                    bottom: AppPadding.p28),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: CountryCodePicker(
                        onChanged: (country) {
                          //update view model with the selected code
                          _viewModel.setCountryCode(country.dialCode ?? EMPTY);
                        },
                        padding: EdgeInsets.zero,
                        initialSelection: "+95",
                        showCountryOnly: true,
                        hideMainText: true,
                        showDropDownButton: false,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: StreamBuilder<String?>(
                          stream: _viewModel.outputErrorMobileNumber,
                          builder: (context, snapshot) {
                            return TextFormField(
                                keyboardType: TextInputType.phone,
                                controller: _mobileNumberTextEditingController,
                                decoration: InputDecoration(
                                  hintText: AppStrings.moblieNumber,
                                  labelText: AppStrings.moblieNumber,
                                  errorText: snapshot.data,
                                ));
                          }),
                    ),
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p28),
            child: StreamBuilder<String?>(
                stream: _viewModel.outputErrorEmail,
                builder: (context, snapshot) {
                  return TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailTextEditingController,
                    decoration: InputDecoration(
                        hintText: AppStrings.email,
                        labelText: AppStrings.email,
                        errorText: snapshot.data),
                  );
                }),
          ),
          const SizedBox(height: AppSize.s28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p28),
            child: StreamBuilder<String?>(
                stream: _viewModel.outputErrorPassword,
                builder: (context, snapshot) {
                  return TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordTextEditingController,
                    decoration: InputDecoration(
                        hintText: AppStrings.password,
                        labelText: AppStrings.password,
                        errorText: snapshot.data),
                  );
                }),
          ),
          const SizedBox(height: AppSize.s28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p28),
            child: Container(
              height: AppSize.s40,
              decoration: BoxDecoration(
                  border: Border.all(color: ColorManager.lightGrey)),
              child: GestureDetector(
                child: _getMediaWidget(),
                onTap: () {
                  _showPicker(context);
                },
              ),
            ),
          ),
          const SizedBox(height: AppSize.s28),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p28,
            ),
            child: StreamBuilder<bool>(
                stream: _viewModel.outputIsAllInputsValid, // todo add me later
                builder: (context, snapshot) {
                  return SizedBox(
                    width: double.infinity,
                    height: AppSize.s40,
                    child: ElevatedButton(
                        onPressed: (snapshot.data ?? false)
                            ? () {
                                _viewModel.register();
                              }
                            : null,
                        child: const Text(AppStrings.register)),
                  );
                }),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: AppPadding.p8,
              left: AppPadding.p28,
              right: AppPadding.p28,
            ),
            child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  AppStrings.haveAccount,
                  style: Theme.of(context).textTheme.subtitle2,
                )),
          )
        ]),
      )),
    );
  }

  Widget _getMediaWidget() {
    var outputIsProfilePictureValid = _viewModel.outputIsProfilePictureValid;
    return Padding(
      padding: EdgeInsets.only(left: AppPadding.p8, right: AppPadding.p8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(child: Text(AppStrings.profilePicture)),
        Flexible(
            child: StreamBuilder<File?>(
          stream: outputIsProfilePictureValid,
          builder: (context, snapshot) {
            return _imagePickedByUser(snapshot.data);
          },
        )),
        Flexible(child: SvgPicture.asset(ImageAssets.photoCameraIc))
      ]),
    );
  }

  Widget _imagePickedByUser(File? image) {
    if (image != null && image.path.isNotEmpty) {
      return Image.file(image);
    } else {
      return Container();
    }
  }

  _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: Wrap(children: [
            ListTile(
              trailing: Icon(Icons.arrow_forward),
              leading: Icon(Icons.camera),
              title: Text(AppStrings.photoGallery),
              onTap: () {
                _imageFromGallery();
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              trailing: Icon(Icons.arrow_forward),
              leading: Icon(Icons.camera_alt_rounded),
              title: Text(AppStrings.photoCamera),
              onTap: () {
                _imageFromCamera();
                Navigator.of(context).pop();
              },
            )
          ]));
        });
  }

  _imageFromGallery() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    _viewModel.setProfilePicture(File(image?.path ?? ""));
  }

  _imageFromCamera() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    _viewModel.setProfilePicture(File(image?.path ?? ""));
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
