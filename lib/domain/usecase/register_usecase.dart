import 'package:dartz/dartz.dart';
import 'package:flutter_advance_mvvm/data/requests/request.dart';

import '../../data/network/failure.dart';
import '../model/model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class RegisterUseCase
    implements BaseUseCase<RegisterUseCaseInput, Authentication> {
  Repository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(
      RegisterUseCaseInput input) async {
    return await _repository.register(RegisterRequest(
        input.countryMobileCode,
        input.userName,
        input.email,
        input.password,
        input.mobileNumber,
        input.profilePicture));
  }
}

class RegisterUseCaseInput {
  String countryMobileCode;
  String userName;
  String email;
  String password;
  String mobileNumber;
  String profilePicture;
  RegisterUseCaseInput(this.countryMobileCode, this.userName, this.email,
      this.password, this.mobileNumber, this.profilePicture);
}
