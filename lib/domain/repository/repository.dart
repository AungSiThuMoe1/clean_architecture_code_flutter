import 'package:dartz/dartz.dart';
import 'package:flutter_advance_mvvm/domain/model/model.dart';

import '../../data/network/failure.dart';
import '../../data/requests/request.dart';

abstract class Repository {
  Future<Either<Failure, Authentication>> login(LoginRequest loginRequest);
  Future<Either<Failure,String>> forgotPassword(ForgotRequest forgotRequest);
  Future<Either<Failure, Authentication>> register(RegisterRequest registerRequest);
  Future<Either<Failure,HomeObject>> getHome();

}
