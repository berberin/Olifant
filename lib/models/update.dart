import 'package:json_annotation/json_annotation.dart';

part 'update.g.dart';

@JsonSerializable()
class Update {
  String owner;
  String title;
  String content;
  String fingerprint;

  Update({this.owner, this.title, this.content, this.fingerprint});

  factory Update.fromJson(Map<String, dynamic> json) => _$UpdateFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateToJson(this);
}
