import 'dart:async';

import 'package:flutter_advance_mvvm/app/extensions.dart';
import 'package:flutter_advance_mvvm/domain/usecase/forgot_usecase.dart';

import '../base/baseviewmodel.dart';
import '../common/state_renderer/state_render_impl.dart';
import '../common/state_renderer/state_renderer.dart';

class ForgotPasswordViewModel extends BaseViewModel
    with ForgotPasswordViewModelInputs, ForgotPasswordViewModelOutputs {
  final StreamController _emailStreamController =
      StreamController<String>.broadcast();
  final StreamController _isAllInputsValidStreamController =
      StreamController<bool>.broadcast();

  String email = "";
  ForgotUseCase? _forgotUseCase;

  ForgotPasswordViewModel(this._forgotUseCase);

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    _emailStreamController.close();
    _isAllInputsValidStreamController.close();
  }

  @override
  forgotPassword() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.POPUP_LOADING_STATE));
    (await _forgotUseCase!.execute(ForgotUseCaseInput(email))).fold(
        (failure) => {
              inputState.add(ErrorState(
                  StateRendererType.POPUP_ERROR_STATE, failure.message))
            }, (supportMessage) {
      inputState.add(SuccessState(supportMessage));
    });
  }

  @override
  Sink get inputIsAllInputValid => _isAllInputsValidStreamController.sink;

  @override
  Sink get inputUserName => _emailStreamController.sink;

  @override
  Stream<bool> get outputIsAllInputsValid =>
      _isAllInputsValidStreamController.stream
          .map((event) => _isAllInputsValid());

  @override
  Stream<bool> get outputIsUserNameValid => _emailStreamController.stream
      .map((userName) => _isUserNameValid(userName));

  @override
  setEmail(String email) {
    inputUserName.add(email);
    this.email = email;
    _validate();
  }

  //private functions
  _validate() {
    inputIsAllInputValid.add(null);
  }

  bool _isUserNameValid(String email) {
    return email.isValidEmail();
  }

  bool _isAllInputsValid() {
    return _isUserNameValid(email);
  }
}

abstract class ForgotPasswordViewModelInputs {
  // three functions for actions
  setEmail(String email);
  forgotPassword();
  // two sinks for streams
  Sink get inputUserName;
  Sink get inputIsAllInputValid;
}

abstract class ForgotPasswordViewModelOutputs {
  Stream<bool> get outputIsUserNameValid;
  Stream<bool> get outputIsAllInputsValid;
}
