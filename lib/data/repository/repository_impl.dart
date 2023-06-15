import 'package:flutter_advance_mvvm/data/data_source/local_data_source.dart';
import 'package:flutter_advance_mvvm/data/data_source/remote_data_source.dart';
import 'package:flutter_advance_mvvm/data/mapper/mapper.dart';
import 'package:flutter_advance_mvvm/data/network/network_info.dart';
import 'package:flutter_advance_mvvm/domain/model/model.dart';
import 'package:flutter_advance_mvvm/data/requests/request.dart';
import 'package:flutter_advance_mvvm/data/network/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_advance_mvvm/domain/repository/repository.dart';

import '../network/error_handler.dart';

class RepositoryImpl extends Repository {
  RemoteDataSource _remoteDataSource;
  LocalDataSource _localDataSource;
  NetworkInfo _networkInfo;
  RepositoryImpl(this._remoteDataSource, this._networkInfo,this._localDataSource);

  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
     // try {
        // its safe to call the API
        final response = await _remoteDataSource.login(loginRequest);
        if (response.status == ApiInternalStatus.SUCCESS) //success
        {
          //return data(success)
          //return right

          return Right(response.toDomain());
        } else {
          //return biz logic error
          // return left
          return Left(Failure(response.status ?? ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      // } catch (error) {
      //   return Left(ErrorHandler.handle(error).failure);
      // }
    } else {
      // return connection error
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(ForgotRequest forgotRequest) async{
   if(await _networkInfo.isConnected){
     try{
       final response = await _remoteDataSource.forgotPassword(forgotRequest);
       if(response.status == ApiInternalStatus.SUCCESS)
         {
           return Right(response.toDomain());
         }else
           {
             return Left(Failure(response.status ?? ApiInternalStatus.FAILURE,response.message ?? ResponseMessage.DEFAULT));
           }

     }catch(error){
       return Left(ErrorHandler.handle(error).failure);
     }
   }
   else{
     return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
   }
  }

  @override
  Future<Either<Failure, Authentication>> register(RegisterRequest registerRequest) async{
    if (await _networkInfo.isConnected) {
      try {
        // its safe to call the API
        final response = await _remoteDataSource.register(registerRequest);
        if (response.status == ApiInternalStatus.SUCCESS) //success
        {
          //return data(success)
          //return right

          return Right(response.toDomain());
        } else {
          //return biz logic error
          // return left
          return Left(Failure(response.status ?? ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return connection error
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, HomeObject>> getHome() async{
    try{
     // get from cache
     final response = await _localDataSource.getHome();
     return Right(response.toDomain());
    }catch(cacheError){
      // we hav cache error so we should call API
      if (await _networkInfo.isConnected) {
        try {
          // its safe to call the API
          final response = await _remoteDataSource.getHome();
          if (response.status == ApiInternalStatus.SUCCESS) //success
              {
            //return data(success)
            //return right
           //save cache
            _localDataSource.saveHomeToCache(response);
            return Right(response.toDomain());
          } else {
            //return biz logic error
            // return left
            return Left(Failure(response.status ?? ApiInternalStatus.FAILURE,
                response.message ?? ResponseMessage.DEFAULT));
          }
        } catch (error) {
          return Left(ErrorHandler.handle(error).failure);
        }
      } else {
        // return connection error
        return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
      }
    }
  }
}
