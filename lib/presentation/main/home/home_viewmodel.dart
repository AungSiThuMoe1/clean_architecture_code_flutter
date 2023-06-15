import 'dart:async';
import 'dart:ffi';

import 'package:flutter_advance_mvvm/domain/model/model.dart';
import 'package:flutter_advance_mvvm/presentation/base/baseviewmodel.dart';
import 'package:flutter_advance_mvvm/presentation/common/state_renderer/state_render_impl.dart';
import 'package:flutter_advance_mvvm/presentation/common/state_renderer/state_renderer.dart';
import 'package:rxdart/subjects.dart';

import '../../../domain/usecase/home_usecase.dart';

class HomeViewModel extends BaseViewModel
    with HomeViewModelInputs, HomeViewModelOutputs {
  final HomeUseCase _homeUseCase;

  final StreamController _dataStreamController =
      BehaviorSubject<HomeViewObject>();
  HomeViewModel(this._homeUseCase);
  @override
  void start() {
    _getHome();
  }

  _getHome() async {
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.FULL_SCREEN_LOADING_STATE));

    (await _homeUseCase.execute("")).fold((failure) {
      inputState.add(ErrorState(
          StateRendererType.FULL_SCREEN_ERROR_STATE, failure.message));
    }, (homeObject) {
      inputState.add(ContentState());
    _dataStreamController.add(HomeViewObject(homeObject.data.stores, homeObject.data.services, homeObject.data.banners));
    });
  }

  @override
  void dispose() {
  _dataStreamController.close();
    super.dispose();
  }
  @override
  Sink get inputHomeData => _dataStreamController.sink;

  @override
  // TODO: implement outputHomeData
  Stream<HomeViewObject> get outputHomeData => _dataStreamController.stream.map((data) => data);
}

abstract class HomeViewModelInputs {
  Sink get inputHomeData;
}

abstract class HomeViewModelOutputs {
  Stream<HomeViewObject> get outputHomeData;
}


class HomeViewObject{
  List<Store> stores;
  List<Service> services;
  List<BannerAd> banners;

  HomeViewObject(this.stores,this.services,this.banners);
}
