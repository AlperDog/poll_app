import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable()
class ApiResponse {
  final bool success;
  final Map<String, dynamic>? data;
  final String? message;
  final String? error;
  final int? statusCode;

  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
    this.statusCode,
  });

  factory ApiResponse.success(Map<String, dynamic> data, {String? message}) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
    );
  }

  factory ApiResponse.error(String error, {int? statusCode}) {
    return ApiResponse(
      success: false,
      error: error,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);

  @override
  String toString() {
    return 'ApiResponse(success: $success, data: $data, error: $error)';
  }
}

@JsonSerializable()
class PaginatedResponse {
  final List<Map<String, dynamic>> data;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  const PaginatedResponse({
    required this.data,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory PaginatedResponse.fromJson(Map<String, dynamic> json) =>
      _$PaginatedResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedResponseToJson(this);

  @override
  String toString() {
    return 'PaginatedResponse(page: $page, total: $total, dataLength: ${data.length})';
  }
}

@JsonSerializable()
class WebSocketMessage {
  final String type;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  const WebSocketMessage({
    required this.type,
    required this.data,
    required this.timestamp,
  });

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) =>
      _$WebSocketMessageFromJson(json);
  Map<String, dynamic> toJson() => _$WebSocketMessageToJson(this);

  @override
  String toString() {
    return 'WebSocketMessage(type: $type, data: $data)';
  }
}

enum WebSocketMessageType {
  @JsonValue('vote_update')
  voteUpdate,
  @JsonValue('poll_status_change')
  pollStatusChange,
  @JsonValue('participant_joined')
  participantJoined,
  @JsonValue('participant_left')
  participantLeft,
  @JsonValue('error')
  error,
} 