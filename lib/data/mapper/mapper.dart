import 'package:flutter_advance_mvvm/app/extensions.dart';
import 'package:flutter_advance_mvvm/data/responses/responses.dart';

import '../../domain/model/model.dart';

const EMPTY = "";
const ZERO = 0;

extension CustomerResponsesMapper on CustomerResponse? {
  Customer toDomain() {
    return Customer(this?.id?.orEmpty() ?? EMPTY, this?.name?.orEmpty() ?? EMPTY,
        this?.numOfNotification?.orZero() ?? ZERO);
  }
}

extension ContactsResponsesMapper on ContactsResponse? {
  Contacts toDomain() {
    return Contacts(this?.email?.orEmpty() ?? EMPTY, this?.phone?.orEmpty() ?? EMPTY,
        this?.link?.orEmpty() ?? EMPTY);
  }
}

extension AuthenticationMapper on AuthenticationResponse? {
  Authentication toDomain() {
    return Authentication(this?.customer?.toDomain(), this?.contacts?.toDomain());
  }
}

extension ForgotMapper on ForgotResponse?{
  String toDomain(){
    return this?.support?.orEmpty()??EMPTY;
  }
}


extension ServiceResponseMapper on ServiceResponse?{
  Service toDomain(){
    return Service(this?.id.orZero() ?? ZERO, this?.title.orEmpty() ?? EMPTY, this?.image.orEmpty() ?? EMPTY);
  }
}

extension StoreResponseMapper on StoreResponse?{
  Store toDomain(){
    return Store(this?.id.orZero() ?? ZERO, this?.title.orEmpty() ?? EMPTY, this?.image.orEmpty() ?? EMPTY);
  }
}

extension BannerResponseMapper on BannerResponse?{
  BannerAd toDomain(){
    return BannerAd(this?.id.orZero() ?? ZERO, this?.title.orEmpty() ?? EMPTY, this?.image.orEmpty() ?? EMPTY,this?.link.orEmpty() ?? EMPTY);
  }
}



extension HomeResponseMapper on HomeResponse?{
  HomeObject toDomain(){
    List<Service> mappedServices = (this?.data?.services?.map((service) => service.toDomain()) ?? Iterable.empty()).cast<Service>().toList();
    List<Store> mappedStores = (this?.data?.stores?.map((store) => store.toDomain()) ?? Iterable.empty()).cast<Store>().toList();
    List<BannerAd> mappedBanners = (this?.data?.banners?.map((banner) => banner.toDomain()) ?? Iterable.empty()).cast<BannerAd>().toList();
    var data = HomeData(mappedServices,mappedStores,mappedBanners);
    return HomeObject(data);
  }

}
