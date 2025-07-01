import 'package:json_annotation/json_annotation.dart';

part 'poll.g.dart';

@JsonSerializable()
class Poll {
  final String id;
  final String title;
  final String question;
  final List<PollOption> options;
  final PollStatus status;
  final bool allowMultipleChoices;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final String? createdBy;
  final int totalVotes;
  final int participantCount;

  const Poll({
    required this.id,
    required this.title,
    required this.question,
    required this.options,
    required this.status,
    required this.allowMultipleChoices,
    required this.createdAt,
    this.startedAt,
    this.endedAt,
    this.createdBy,
    this.totalVotes = 0,
    this.participantCount = 0,
  });

  factory Poll.fromJson(Map<String, dynamic> json) => _$PollFromJson(json);
  Map<String, dynamic> toJson() => _$PollToJson(this);

  Poll copyWith({
    String? id,
    String? title,
    String? question,
    List<PollOption>? options,
    PollStatus? status,
    bool? allowMultipleChoices,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? endedAt,
    String? createdBy,
    int? totalVotes,
    int? participantCount,
  }) {
    return Poll(
      id: id ?? this.id,
      title: title ?? this.title,
      question: question ?? this.question,
      options: options ?? this.options,
      status: status ?? this.status,
      allowMultipleChoices: allowMultipleChoices ?? this.allowMultipleChoices,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      createdBy: createdBy ?? this.createdBy,
      totalVotes: totalVotes ?? this.totalVotes,
      participantCount: participantCount ?? this.participantCount,
    );
  }

  @override
  String toString() {
    return 'Poll(id: $id, title: $title, status: $status)';
  }
}

@JsonSerializable()
class PollOption {
  final String id;
  final String text;
  final int voteCount;
  final double percentage;

  const PollOption({
    required this.id,
    required this.text,
    this.voteCount = 0,
    this.percentage = 0.0,
  });

  factory PollOption.fromJson(Map<String, dynamic> json) => _$PollOptionFromJson(json);
  Map<String, dynamic> toJson() => _$PollOptionToJson(this);

  PollOption copyWith({
    String? id,
    String? text,
    int? voteCount,
    double? percentage,
  }) {
    return PollOption(
      id: id ?? this.id,
      text: text ?? this.text,
      voteCount: voteCount ?? this.voteCount,
      percentage: percentage ?? this.percentage,
    );
  }

  @override
  String toString() {
    return 'PollOption(id: $id, text: $text, voteCount: $voteCount)';
  }
}

enum PollStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('live')
  live,
  @JsonValue('ended')
  ended,
  @JsonValue('archived')
  archived,
}

extension PollStatusExtension on PollStatus {
  String get displayName {
    switch (this) {
      case PollStatus.draft:
        return 'Draft';
      case PollStatus.live:
        return 'Live';
      case PollStatus.ended:
        return 'Ended';
      case PollStatus.archived:
        return 'Archived';
    }
  }

  bool get isActive => this == PollStatus.live;
  bool get canVote => this == PollStatus.live;
  bool get canViewResults => this == PollStatus.live || this == PollStatus.ended;
} 