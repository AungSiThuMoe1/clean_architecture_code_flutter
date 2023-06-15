import 'package:dartz/dartz.dart';
import 'package:flutter_advance_mvvm/app/functions.dart';
import 'package:flutter_advance_mvvm/data/network/failure.dart';
import 'package:flutter_advance_mvvm/data/requests/request.dart';
import 'package:flutter_advance_mvvm/domain/usecase/base_usecase.dart';

import '../model/model.dart';
import '../repository/repository.dart';

class LoginUseCase implements BaseUseCase<LoginUseCaseInput, Authentication> {
  Repository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(
      LoginUseCaseInput input) async {
    DeviceInfo deviceInfo = await getDeviceDetails();
    return await _repository.login(LoginRequest(
      input.email,
      input.password,
      deviceInfo.identifier,
      deviceInfo.name,
    ));
  }
}

class LoginUseCaseInput {
  String email;
  String password;
  LoginUseCaseInput(this.email, this.password);
}
