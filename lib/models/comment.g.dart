// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment(
    fingerprint: json['fingerprint'] as String,
    owner: json['owner'] as String,
    content: json['content'] as String,
  );
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'owner': instance.owner,
      'content': instance.content,
      'fingerprint': instance.fingerprint,
    };
