import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  final String accessToken;

  @HiveField(1)
  final String tokenType;

  @HiveField(2)
  final String refreshToken;

  @HiveField(3)
  final String firstName;

  @HiveField(4)
  final String lastName;

  @HiveField(5)
  final String email;

  @HiveField(6)
  final String role;

  @HiveField(7)
  final bool isVerified;

  @HiveField(8)
  final String subscriptionType;

  @HiveField(9)
  final bool updatePassword;

  @HiveField(10)
  final bool changePassword;

  @HiveField(11)
  final DateTime dateCreated;

  @HiveField(12)
  final DateTime dateUpdated;

  @HiveField(13)
  final String profilePictureUrl;

  User({
    required this.accessToken,
    required this.tokenType,
    required this.refreshToken,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.isVerified,
    required this.subscriptionType,
    required this.updatePassword,
    required this.changePassword,
    required this.dateCreated,
    required this.dateUpdated,
    required this.profilePictureUrl,
  });

  // Factory constructor for creating a new User object from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      refreshToken: json['refresh_token'],
      firstName: json['data']['first_name'] ?? '',
      lastName: json['data']['last_name'] ?? '',
      email: json['data']['email'],
      role: json['data']['role'],
      isVerified: json['data']['is_verified'],
      subscriptionType: json['data']['subscription_type'],
      updatePassword: json['update_password'],
      changePassword: json['data']['change_password'],
      dateCreated: DateTime.parse(json['data']['date_created']),
      dateUpdated: DateTime.parse(json['data']['date_updated']),
      profilePictureUrl: json['data']['profile_picture_url'] ?? '',
    );
  }

  // Method to convert User object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'refresh_token': refreshToken,
      'update_password': updatePassword,
      'data': {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'role': role,
        'is_verified': isVerified,
        'subscription_type': subscriptionType,
        'change_password': changePassword,
        'date_created': dateCreated.toIso8601String(),
        'date_updated': dateUpdated.toIso8601String(),
        'profile_picture_url': profilePictureUrl,
      },
    };
  }

  // Method to create a copy of the User object with modified fields
  User copyWith({
    String? accessToken,
    String? tokenType,
    String? refreshToken,
    String? firstName,
    String? lastName,
    String? email,
    String? role,
    bool? isVerified,
    String? subscriptionType,
    bool? updatePassword,
    bool? changePassword,
    DateTime? dateCreated,
    DateTime? dateUpdated,
    String? profilePictureUrl,
  }) {
    return User(
      accessToken: accessToken ?? this.accessToken,
      tokenType: tokenType ?? this.tokenType,
      refreshToken: refreshToken ?? this.refreshToken,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      updatePassword: updatePassword ?? this.updatePassword,
      changePassword: changePassword ?? this.changePassword,
      dateCreated: dateCreated ?? this.dateCreated,
      dateUpdated: dateUpdated ?? this.dateUpdated,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    );
  }
}
