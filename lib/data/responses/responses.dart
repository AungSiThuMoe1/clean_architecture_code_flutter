import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'responses.g.dart';

@JsonSerializable()
class BaseResponse {
  int? status;
  String? message;
}

@JsonSerializable()
class CustomerResponse {
  String? id;
  String? name;
  int? numOfNotification;

  CustomerResponse(this.id, this.name, this.numOfNotification);
  // from json
  factory CustomerResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomerResponseFromJson(json);
  //to json
  Map<String, dynamic> toJson() => _$CustomerResponseToJson(this);
}

@JsonSerializable()
class ContactsResponse {
  String? email;
  String? phone;
  String? link;

  ContactsResponse(this.email, this.phone, this.link);
  // from json
  factory ContactsResponse.fromJson(Map<String, dynamic> json) =>
      _$ContactsResponseFromJson(json);
  //to json
  Map<String, dynamic> toJson() => _$ContactsResponseToJson(this);
}

@JsonSerializable()
class AuthenticationResponse extends BaseResponse {
  @JsonKey(name: "customer")
  CustomerResponse? customer;
  @JsonKey(name: "contacts")
  ContactsResponse? contacts;

  AuthenticationResponse(this.customer, this.contacts);

  // from json
  factory AuthenticationResponse.fromJson(String json) =>
      _$AuthenticationResponseFromJson(jsonDecode(json));
  //to json
  Map<String, dynamic> toJson() => _$AuthenticationResponseToJson(this);
}

@JsonSerializable()
class ForgotResponse extends BaseResponse{
  @JsonKey(name: "support")
  String? support;
  ForgotResponse(this.support);
  factory ForgotResponse.fromJson(String json) => _$ForgotResponseFromJson(jsonDecode(json));

  Map<String,dynamic> toJson() => _$ForgotResponseToJson(this);
}

@JsonSerializable()
class ServiceResponse{
  @JsonKey(name:'id')
  int? id;
  @JsonKey(name:'title')
  String? title;
  @JsonKey(name:'image')
  String? image;
  ServiceResponse(this.id,this.title,this.image);

  factory ServiceResponse.fromJson(Map<String, dynamic> json) => _$ServiceResponseFromJson(json);

  Map<String,dynamic> toJson() => _$ServiceResponseToJson(this);
}

@JsonSerializable()
class StoreResponse{
  @JsonKey(name:'id')
  int? id;
  @JsonKey(name:'title')
  String? title;
  @JsonKey(name:'image')
  String? image;
  StoreResponse(this.id,this.title,this.image);

  factory StoreResponse.fromJson(Map<String, dynamic> json) => _$StoreResponseFromJson(json);

  Map<String,dynamic> toJson() => _$StoreResponseToJson(this);
}

@JsonSerializable()
class BannerResponse{
  @JsonKey(name:'id')
  int? id;
  @JsonKey(name:'title')
  String? title;
  @JsonKey(name:'image')
  String? image;
  @JsonKey(name:'link')
  String? link;
  BannerResponse(this.id,this.title,this.image,this.link);

  factory BannerResponse.fromJson(Map<String, dynamic> json) => _$BannerResponseFromJson(json);

  Map<String,dynamic> toJson() => _$BannerResponseToJson(this);
}

@JsonSerializable()
class HomeDataResponse{
  @JsonKey(name: 'services')
  List<ServiceResponse>? services;
  @JsonKey(name:'stores')
  List<StoreResponse>? stores;
  @JsonKey(name:'banners')
  List<BannerResponse>? banners;
  HomeDataResponse(this.services,this.stores,this.banners);

  factory HomeDataResponse.fromJson(Map<String, dynamic> json)=> _$HomeDataResponseFromJson(json);

  Map<String,dynamic> toJson() => _$HomeDataResponseToJson(this);
}
@JsonSerializable()
class HomeResponse extends BaseResponse{
  @JsonKey(name:'data')
  HomeDataResponse? data;

  HomeResponse(this.data);

  factory HomeResponse.fromJson(Map<String, dynamic> json)=> _$HomeResponseFromJson(json);

  Map<String,dynamic> toJson() => _$HomeResponseToJson(this);

}