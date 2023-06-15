import 'package:flutter_advance_mvvm/data/network/app_api.dart';
import 'package:flutter_advance_mvvm/data/requests/request.dart';
import 'package:flutter_advance_mvvm/data/responses/responses.dart';

abstract class RemoteDataSource {
  Future<AuthenticationResponse> login(LoginRequest loginRequest);
  Future<ForgotResponse> forgotPassword(ForgotRequest forgotRequest);
  Future<AuthenticationResponse> register(RegisterRequest registerRequest);
  Future<HomeResponse> getHome();
}

class RemoteDataSourceImplementer implements RemoteDataSource {
  final AppServiceClient _appServiceClient;

  RemoteDataSourceImplementer(this._appServiceClient);
  @override
  Future<AuthenticationResponse> login(LoginRequest loginRequest) {
    return _appServiceClient.login(loginRequest.email, loginRequest.password,
        loginRequest.imei, loginRequest.deviceType);
  }

  @override
  Future<ForgotResponse> forgotPassword(ForgotRequest forgotRequest) {
    return _appServiceClient.forgotPassword(forgotRequest.email);
  }

  @override
  Future<AuthenticationResponse> register(RegisterRequest registerRequest) {
    return _appServiceClient.register(
        registerRequest.countryMobileCode,
        registerRequest.userName,
        registerRequest.email,
        registerRequest.password,
        registerRequest.mobileNumber,
        "");
  }

  @override
  Future<HomeResponse> getHome() {
    return _appServiceClient.getHome();
  }
}
