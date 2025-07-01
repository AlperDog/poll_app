// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Poll _$PollFromJson(Map<String, dynamic> json) => Poll(
  id: json['id'] as String,
  title: json['title'] as String,
  question: json['question'] as String,
  options: (json['options'] as List<dynamic>)
      .map((e) => PollOption.fromJson(e as Map<String, dynamic>))
      .toList(),
  status: $enumDecode(_$PollStatusEnumMap, json['status']),
  allowMultipleChoices: json['allowMultipleChoices'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  startedAt: json['startedAt'] == null
      ? null
      : DateTime.parse(json['startedAt'] as String),
  endedAt: json['endedAt'] == null
      ? null
      : DateTime.parse(json['endedAt'] as String),
  createdBy: json['createdBy'] as String?,
  totalVotes: (json['totalVotes'] as num?)?.toInt() ?? 0,
  participantCount: (json['participantCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PollToJson(Poll instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'question': instance.question,
  'options': instance.options,
  'status': _$PollStatusEnumMap[instance.status]!,
  'allowMultipleChoices': instance.allowMultipleChoices,
  'createdAt': instance.createdAt.toIso8601String(),
  'startedAt': instance.startedAt?.toIso8601String(),
  'endedAt': instance.endedAt?.toIso8601String(),
  'createdBy': instance.createdBy,
  'totalVotes': instance.totalVotes,
  'participantCount': instance.participantCount,
};

const _$PollStatusEnumMap = {
  PollStatus.draft: 'draft',
  PollStatus.live: 'live',
  PollStatus.ended: 'ended',
  PollStatus.archived: 'archived',
};

PollOption _$PollOptionFromJson(Map<String, dynamic> json) => PollOption(
  id: json['id'] as String,
  text: json['text'] as String,
  voteCount: (json['voteCount'] as num?)?.toInt() ?? 0,
  percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$PollOptionToJson(PollOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'voteCount': instance.voteCount,
      'percentage': instance.percentage,
    };
