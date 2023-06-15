import 'package:dartz/dartz.dart';
import 'package:flutter_advance_mvvm/data/network/failure.dart';
import 'package:flutter_advance_mvvm/domain/model/model.dart';
import 'package:flutter_advance_mvvm/domain/usecase/base_usecase.dart';

import '../repository/repository.dart';

class HomeUseCase extends BaseUseCase<void,HomeObject>{

  Repository _repository;
  HomeUseCase(this._repository);
  @override
  Future<Either<Failure, HomeObject>> execute(void input) async{
   return await _repository.getHome();
  }
  
}