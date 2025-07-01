import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String username;
  final String? email;
  final UserRole role;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isGuest;

  const User({
    required this.id,
    required this.username,
    this.email,
    this.role = UserRole.user,
    required this.createdAt,
    this.lastLoginAt,
    this.isGuest = false,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? username,
    String? email,
    UserRole? role,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isGuest,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isGuest: isGuest ?? this.isGuest,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, role: $role)';
  }
}

enum UserRole {
  @JsonValue('guest')
  guest,
  @JsonValue('user')
  user,
  @JsonValue('admin')
  admin,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.guest:
        return 'Guest';
      case UserRole.user:
        return 'User';
      case UserRole.admin:
        return 'Admin';
    }
  }

  bool get isAdmin => this == UserRole.admin;
  bool get canCreatePolls => this == UserRole.admin || this == UserRole.user;
  bool get canManagePolls => this == UserRole.admin;
}

@JsonSerializable()
class AuthToken {
  final String accessToken;
  final String? refreshToken;
  final DateTime expiresAt;
  final String tokenType;

  const AuthToken({
    required this.accessToken,
    this.refreshToken,
    required this.expiresAt,
    this.tokenType = 'Bearer',
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) => _$AuthTokenFromJson(json);
  Map<String, dynamic> toJson() => _$AuthTokenToJson(this);

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  AuthToken copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    String? tokenType,
  }) {
    return AuthToken(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      tokenType: tokenType ?? this.tokenType,
    );
  }

  @override
  String toString() {
    return 'AuthToken(expiresAt: $expiresAt, isExpired: $isExpired)';
  }
} 