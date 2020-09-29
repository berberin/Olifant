import 'package:json_annotation/json_annotation.dart';

part 'campaign.g.dart';

class Campaign {
  String address;
  String owner;
  String title;

  String imageUrl;
  String description;

  int currentFund;
  int targetFund;

  String unit;
  DateTime due;

  bool completed;

  Campaign(
      {this.address,
      this.owner,
      this.title,
      this.imageUrl,
      this.description,
      this.currentFund,
      this.targetFund,
      this.unit: 'ONE',
      this.due,
      this.completed});
}

class CampaignInfo {}

@JsonSerializable()
class CampaignOnContract {
  @JsonKey(name: 'owner')
  String owner;

  @JsonKey(name: 'fundCall')
  int targetFund;

  @JsonKey(name: 'balance')
  int currentFund;

  int timeLock;

  @JsonKey(name: 'complete')
  bool completed;

  CampaignOnContract(
      {this.owner,
      this.targetFund,
      this.currentFund,
      this.timeLock,
      this.completed});

  factory CampaignOnContract.fromJson(Map<String, dynamic> json) =>
      _$CampaignOnContractFromJson(json);

  Map<String, dynamic> toJson() => _$CampaignOnContractToJson(this);
}

@JsonSerializable()
class CampaignOnFB {
  String owner;
  String coverUrl;
  String title;
  String description;

  CampaignOnFB({this.owner, this.coverUrl, this.title, this.description});

  factory CampaignOnFB.fromJson(Map<String, dynamic> json) =>
      _$CampaignOnFBFromJson(json);
  Map<String, dynamic> toJson() => _$CampaignOnFBToJson(this);
}
