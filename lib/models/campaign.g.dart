// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CampaignOnContract _$CampaignOnContractFromJson(Map<String, dynamic> json) {
  return CampaignOnContract(
    owner: json['owner'] as String,
    targetFund: json['fundCall'] as int,
    currentFund: json['balance'] as int,
    timeLock: json['timeLock'] as int,
    completed: json['complete'] as bool,
  );
}

Map<String, dynamic> _$CampaignOnContractToJson(CampaignOnContract instance) =>
    <String, dynamic>{
      'owner': instance.owner,
      'fundCall': instance.targetFund,
      'balance': instance.currentFund,
      'timeLock': instance.timeLock,
      'complete': instance.completed,
    };

CampaignOnFB _$CampaignOnFBFromJson(Map<String, dynamic> json) {
  return CampaignOnFB(
    owner: json['owner'] as String,
    coverUrl: json['coverUrl'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
  );
}

Map<String, dynamic> _$CampaignOnFBToJson(CampaignOnFB instance) =>
    <String, dynamic>{
      'owner': instance.owner,
      'coverUrl': instance.coverUrl,
      'title': instance.title,
      'description': instance.description,
    };
