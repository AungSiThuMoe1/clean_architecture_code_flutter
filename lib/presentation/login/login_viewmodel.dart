import 'dart:async';

import 'package:flutter_advance_mvvm/domain/usecase/login_usecase.dart';
import 'package:flutter_advance_mvvm/presentation/base/baseviewmodel.dart';
import 'package:flutter_advance_mvvm/presentation/common/state_renderer/state_renderer.dart';

import '../common/freezed_data_classes.dart';
import '../common/state_renderer/state_render_impl.dart';

class LoginViewModel extends BaseViewModel
    with LoginViewModelInputs, LoginViewModelOutputs {
  StreamController _userNameStreamController =
      StreamController<String>.broadcast();
  StreamController _passwordStreamController =
      StreamController<String>.broadcast();

  StreamController _isAllInputsValidStreamController =
      StreamController<void>.broadcast();

  StreamController isUserLoggedInSuccessfullyStreamController = StreamController<bool>();

  var loginObject = LoginObject("", "");

  LoginUseCase? _loginUseCase; // todo remove

  LoginViewModel(this._loginUseCase);
  //input
  @override
  void dispose() {
    _userNameStreamController.close();
    _passwordStreamController.close();
    _isAllInputsValidStreamController.close();
    isUserLoggedInSuccessfullyStreamController.close();
  }

  @override
  void start() {
    // view tells state renderer, please show the content of the screen
    inputState.add(ContentState());
  }

  @override
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  Sink get inputUserName => _userNameStreamController.sink;

  @override
  Sink get inputIsAllInputValid => _isAllInputsValidStreamController.sink;

  @override
  setPassword(String password) {
    inputPassword.add(password);
    loginObject = loginObject.copyWith(password: password);
    _validate();
  }

  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    loginObject = loginObject.copyWith(userName: userName);
    _validate();
  }

  @override
  login() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.POPUP_LOADING_STATE));
    (await _loginUseCase!.execute(
            LoginUseCaseInput(loginObject.userName, loginObject.password)))
        .fold(
            (failure) => {
                  inputState.add(ErrorState(
                      StateRendererType.POPUP_ERROR_STATE, failure.message))
                },
            (data){
              inputState.add(ContentState());
              isUserLoggedInSuccessfullyStreamController.add(true);
            });
  }

  @override
  Stream<bool> get outputIsPasswordValid => _passwordStreamController.stream
      .map((password) => _isPasswordValid(password));

  @override
  Stream<bool> get outputIsUserNameValid => _userNameStreamController.stream
      .map((userName) => _isUserNameValid(userName));

  @override
  Stream<bool> get outputIsAllInputsValid =>
      _isAllInputsValidStreamController.stream
          .map((event) => _isAllInputsValid());

  //private functions

  _validate() {
    inputIsAllInputValid.add(null);
  }

  bool _isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  bool _isUserNameValid(String userName) {
    return userName.isNotEmpty;
  }

  bool _isAllInputsValid() {
    return _isPasswordValid(loginObject.password) &&
        _isUserNameValid(loginObject.userName);
  }
}

abstract class LoginViewModelInputs {
  // three functions for actions
  setUserName(String userName);
  setPassword(String password);
  login();
  // two sinks for streams
  Sink get inputUserName;
  Sink get inputPassword;
  Sink get inputIsAllInputValid;
}

abstract class LoginViewModelOutputs {
  Stream<bool> get outputIsUserNameValid;
  Stream<bool> get outputIsPasswordValid;
  Stream<bool> get outputIsAllInputsValid;
}
