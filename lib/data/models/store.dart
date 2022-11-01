import 'dart:convert';

import 'package:flutternotestest/data/models/store_visit.dart';

class Store {
  final int? id;
  final String? storeId;
  final String? storeCode;
  final String? storeName;
  final String? address;
  final String? dcId;
  final String? dcName;
  final String? accountId;
  final String? accountName;
  final String? subchannelId;
  final String? subchannelName;
  final String? channelId;
  final String? channelName;
  final String? areaId;
  final String? areaName;
  final String? regionId;
  final String? regionName;
  final String? latitude;
  final String? longitude;
  final StoreVisit? storeVisit;

  Store({
    this.id,
    this.storeId,
    this.storeCode,
    this.storeName,
    this.address,
    this.dcId,
    this.dcName,
    this.accountId,
    this.accountName,
    this.subchannelId,
    this.subchannelName,
    this.channelId,
    this.channelName,
    this.areaId,
    this.areaName,
    this.regionId,
    this.regionName,
    this.latitude,
    this.longitude,
    this.storeVisit,
  });

  Store copyWith({
    int? id,
    String? storeId,
    String? storeCode,
    String? storeName,
    String? address,
    String? dcId,
    String? dcName,
    String? accountId,
    String? accountName,
    String? subchannelId,
    String? subchannelName,
    String? channelId,
    String? channelName,
    String? areaId,
    String? areaName,
    String? regionId,
    String? regionName,
    String? latitude,
    String? longitude,
    StoreVisit? storeVisit,
  }) {
    return Store(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      storeCode: storeCode ?? this.storeCode,
      storeName: storeName ?? this.storeName,
      address: address ?? this.address,
      dcId: dcId ?? this.dcId,
      dcName: dcName ?? this.dcName,
      accountId: accountId ?? this.accountId,
      accountName: accountName ?? this.accountName,
      subchannelId: subchannelId ?? this.subchannelId,
      subchannelName: subchannelName ?? this.subchannelName,
      channelId: channelId ?? this.channelId,
      channelName: channelName ?? this.channelName,
      areaId: areaId ?? this.areaId,
      areaName: areaName ?? this.areaName,
      regionId: regionId ?? this.regionId,
      regionName: regionName ?? this.regionName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      storeVisit: storeVisit ?? this.storeVisit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'store_id': storeId,
      'store_code': storeCode,
      'store_name': storeName,
      'address': address,
      'dc_id': dcId,
      'dc_name': dcName,
      'account_id': accountId,
      'account_name': accountName,
      'subchannel_id': subchannelId,
      'subchannel_name': subchannelName,
      'channel_id': channelId,
      'channel_name': channelName,
      'area_id': areaId,
      'area_name': areaName,
      'region_id': regionId,
      'region_name': regionName,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      id: map['_id']?.toInt(),
      storeId: map['store_id'],
      storeCode: map['store_code'],
      storeName: map['store_name'],
      address: map['address'],
      dcId: map['dc_id'],
      dcName: map['dc_name'],
      accountId: map['account_id'],
      accountName: map['account_name'],
      subchannelId: map['subchannel_id'],
      subchannelName: map['subchannel_name'],
      channelId: map['channel_id'],
      channelName: map['channel_name'],
      areaId: map['area_id'],
      areaName: map['area_name'],
      regionId: map['region_id'],
      regionName: map['region_name'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Store.fromJson(String source) => Store.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Store(id: $id, storeId: $storeId, storeCode: $storeCode, storeName: $storeName, address: $address, dcId: $dcId, dcName: $dcName, accountId: $accountId, accountName: $accountName, subchannelId: $subchannelId, subchannelName: $subchannelName, channelId: $channelId, channelName: $channelName, areaId: $areaId, areaName: $areaName, regionId: $regionId, regionName: $regionName, latitude: $latitude, longitude: $longitude, storeVisit: $storeVisit)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Store &&
        other.id == id &&
        other.storeId == storeId &&
        other.storeCode == storeCode &&
        other.storeName == storeName &&
        other.address == address &&
        other.dcId == dcId &&
        other.dcName == dcName &&
        other.accountId == accountId &&
        other.accountName == accountName &&
        other.subchannelId == subchannelId &&
        other.subchannelName == subchannelName &&
        other.channelId == channelId &&
        other.channelName == channelName &&
        other.areaId == areaId &&
        other.areaName == areaName &&
        other.regionId == regionId &&
        other.regionName == regionName &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.storeVisit == storeVisit;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        storeId.hashCode ^
        storeCode.hashCode ^
        storeName.hashCode ^
        address.hashCode ^
        dcId.hashCode ^
        dcName.hashCode ^
        accountId.hashCode ^
        accountName.hashCode ^
        subchannelId.hashCode ^
        subchannelName.hashCode ^
        channelId.hashCode ^
        channelName.hashCode ^
        areaId.hashCode ^
        areaName.hashCode ^
        regionId.hashCode ^
        regionName.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        storeVisit.hashCode;
  }
}
