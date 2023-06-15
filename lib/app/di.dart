import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_advance_mvvm/app/app_prefs.dart';
import 'package:flutter_advance_mvvm/data/data_source/remote_data_source.dart';
import 'package:flutter_advance_mvvm/data/network/app_api.dart';
import 'package:flutter_advance_mvvm/data/network/dio_factory.dart';
import 'package:flutter_advance_mvvm/data/network/network_info.dart';
import 'package:flutter_advance_mvvm/data/repository/repository_impl.dart';
import 'package:flutter_advance_mvvm/domain/usecase/forgot_usecase.dart';
import 'package:flutter_advance_mvvm/domain/usecase/home_usecase.dart';
import 'package:flutter_advance_mvvm/domain/usecase/login_usecase.dart';
import 'package:flutter_advance_mvvm/domain/usecase/register_usecase.dart';
import 'package:flutter_advance_mvvm/presentation/forgot_password/forgot_password_viewmodel.dart';
import 'package:flutter_advance_mvvm/presentation/main/home/home_viewmodel.dart';
import 'package:flutter_advance_mvvm/presentation/register/register_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/data_source/local_data_source.dart';
import '../domain/repository/repository.dart';
import '../presentation/login/login_viewmodel.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  final sharedPrefs = await SharedPreferences.getInstance();

//shared prefs instance
  instance.registerLazySingleton(() => sharedPrefs);

// app prefs instance
  instance.registerLazySingleton<AppPreference>(
      () => AppPreference(instance<SharedPreferences>()));

//network info
  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(DataConnectionChecker()));

// dio factory
  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));

//app service client
  final dio = await instance<DioFactory>().getDio();
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

// remote data source
  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImplementer(instance()));

  // local data source
  instance.registerLazySingleton<LocalDataSource>(
          () => LocalDataSourceImplementer());

  //repository
  instance.registerLazySingleton<Repository>(
      () => RepositoryImpl(instance(), instance(),instance()));
}

initLoginModule() {
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
    instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance()));
  }
}

initForgotPasswordModule() {
  if (!GetIt.I.isRegistered<ForgotUseCase>()) {
    instance.registerFactory<ForgotUseCase>(() => ForgotUseCase(instance()));
    instance.registerFactory<ForgotPasswordViewModel>(
        () => ForgotPasswordViewModel(instance()));
  }
}

initRegisterModule() {
  if (!GetIt.I.isRegistered<RegisterUseCase>()) {
    instance
        .registerFactory<RegisterUseCase>(() => RegisterUseCase(instance()));
    instance.registerFactory<RegisterViewModel>(
        () => RegisterViewModel(instance()));
    instance.registerFactory<ImagePicker>(() => ImagePicker());
  }
}

initHomeModule() {
  if (!GetIt.I.isRegistered<HomeUseCase>()) {
    instance.registerFactory<HomeUseCase>(() => HomeUseCase(instance()));
    instance.registerFactory<HomeViewModel>(() => HomeViewModel(instance()));
  }
}
