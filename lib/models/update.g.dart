// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Update _$UpdateFromJson(Map<String, dynamic> json) {
  return Update(
    owner: json['owner'] as String,
    title: json['title'] as String,
    content: json['content'] as String,
    fingerprint: json['fingerprint'] as String,
  );
}

Map<String, dynamic> _$UpdateToJson(Update instance) => <String, dynamic>{
      'owner': instance.owner,
      'title': instance.title,
      'content': instance.content,
      'fingerprint': instance.fingerprint,
    };
