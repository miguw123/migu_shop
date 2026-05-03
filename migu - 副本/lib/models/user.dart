import 'enums.dart';

class User {
  final String id;
  final String name;
  final String phone;
  final String avatar;
  final int userTypeIndex;
  final List<int> roleIndices;
  final int creditScore;
  final bool realNameAuth;
  final double? latitude;
  final double? longitude;
  final String? cityCode;
  final DateTime createdAt;
  final Map<String, dynamic>? extraData;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.avatar,
    required this.userTypeIndex,
    required this.roleIndices,
    this.creditScore = 100,
    this.realNameAuth = false,
    this.latitude,
    this.longitude,
    this.cityCode,
    required this.createdAt,
    this.extraData,
  });

  UserType get userType => UserType.values[userTypeIndex];

  List<UserRole> get roles => roleIndices.map((i) => UserRole.values[i]).toList();

  bool get canPost => creditScore >= 85;
  bool get canChat => creditScore >= 85;
  bool get hasNoOrderLimit => creditScore >= 95;
  bool get isBanned => creditScore < 60;

  String get userTypeName {
    switch (userType) {
      case UserType.farmer:
        return '农民';
      case UserType.villageWarehouse:
        return '村仓';
      case UserType.urbanUser:
        return '城镇用户';
      case UserType.driver:
        return '司机';
      case UserType.communityPickup:
        return '社区取货点';
    }
  }

  String get creditLevel {
    if (creditScore >= 95) return '优秀';
    if (creditScore >= 85) return '良好';
    if (creditScore >= 60) return '一般';
    return '受限';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      avatar: json['avatar'] as String,
      userTypeIndex: json['userTypeIndex'] as int,
      roleIndices: List<int>.from(json['roleIndices'] ?? [0]),
      creditScore: json['creditScore'] as int? ?? 100,
      realNameAuth: json['realNameAuth'] as bool? ?? false,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      cityCode: json['cityCode'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      extraData: json['extraData'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'avatar': avatar,
      'userTypeIndex': userTypeIndex,
      'roleIndices': roleIndices,
      'creditScore': creditScore,
      'realNameAuth': realNameAuth,
      'latitude': latitude,
      'longitude': longitude,
      'cityCode': cityCode,
      'createdAt': createdAt.toIso8601String(),
      'extraData': extraData,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? phone,
    String? avatar,
    int? userTypeIndex,
    List<int>? roleIndices,
    int? creditScore,
    bool? realNameAuth,
    double? latitude,
    double? longitude,
    String? cityCode,
    DateTime? createdAt,
    Map<String, dynamic>? extraData,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      userTypeIndex: userTypeIndex ?? this.userTypeIndex,
      roleIndices: roleIndices ?? this.roleIndices,
      creditScore: creditScore ?? this.creditScore,
      realNameAuth: realNameAuth ?? this.realNameAuth,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      cityCode: cityCode ?? this.cityCode,
      createdAt: createdAt ?? this.createdAt,
      extraData: extraData ?? this.extraData,
    );
  }
}
