import 'package:dartz/dartz.dart';
import 'package:flutter_advance_mvvm/data/network/failure.dart';
import 'package:flutter_advance_mvvm/data/requests/request.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class ForgotUseCase implements BaseUseCase<ForgotUseCaseInput, String> {
  Repository _repository;

  ForgotUseCase(this._repository);
  @override
  Future<Either<Failure, String>> execute(ForgotUseCaseInput input) async {
    return await _repository.forgotPassword(ForgotRequest(input.email));
  }
}

class ForgotUseCaseInput {
  String email;
  ForgotUseCaseInput(this.email);
}
