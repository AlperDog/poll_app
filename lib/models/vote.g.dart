// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vote _$VoteFromJson(Map<String, dynamic> json) => Vote(
  id: json['id'] as String,
  pollId: json['pollId'] as String,
  userId: json['userId'] as String?,
  username: json['username'] as String?,
  selectedOptionIds: (json['selectedOptionIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  sessionId: json['sessionId'] as String?,
);

Map<String, dynamic> _$VoteToJson(Vote instance) => <String, dynamic>{
  'id': instance.id,
  'pollId': instance.pollId,
  'userId': instance.userId,
  'username': instance.username,
  'selectedOptionIds': instance.selectedOptionIds,
  'createdAt': instance.createdAt.toIso8601String(),
  'sessionId': instance.sessionId,
};

VoteSubmission _$VoteSubmissionFromJson(Map<String, dynamic> json) =>
    VoteSubmission(
      pollId: json['pollId'] as String,
      selectedOptionIds: (json['selectedOptionIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      username: json['username'] as String?,
      sessionId: json['sessionId'] as String?,
    );

Map<String, dynamic> _$VoteSubmissionToJson(VoteSubmission instance) =>
    <String, dynamic>{
      'pollId': instance.pollId,
      'selectedOptionIds': instance.selectedOptionIds,
      'username': instance.username,
      'sessionId': instance.sessionId,
    };
