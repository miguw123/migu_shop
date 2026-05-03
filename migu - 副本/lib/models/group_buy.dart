class GroupBuy {
  final String id;
  final String productId;
  final String productTitle;
  final String productImage;
  final String organizerId;
  final String organizerName;
  final String organizerAvatar;
  final double originalPrice;
  final double groupPrice;
  final int minMembers;
  final int currentMembers;
  final DateTime startTime;
  final DateTime endTime;
  final int status;
  final DateTime createdAt;

  GroupBuy({
    required this.id,
    required this.productId,
    required this.productTitle,
    required this.productImage,
    required this.organizerId,
    required this.organizerName,
    required this.organizerAvatar,
    required this.originalPrice,
    required this.groupPrice,
    required this.minMembers,
    required this.currentMembers,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdAt,
  });

  bool get isActive => status == 0 && DateTime.now().isBefore(endTime);

  int get remainingSeconds {
    if (!isActive) return 0;
    return endTime.difference(DateTime.now()).inSeconds;
  }

  double get progress => currentMembers / minMembers;

  String get statusName {
    switch (status) {
      case 0:
        return '进行中';
      case 1:
        return '已成团';
      case 2:
        return '已结束';
      case 3:
        return '已取消';
      default:
        return '未知';
    }
  }

  factory GroupBuy.fromJson(Map<String, dynamic> json) {
    return GroupBuy(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productTitle: json['productTitle'] as String,
      productImage: json['productImage'] as String,
      organizerId: json['organizerId'] as String,
      organizerName: json['organizerName'] as String,
      organizerAvatar: json['organizerAvatar'] as String,
      originalPrice: (json['originalPrice'] as num).toDouble(),
      groupPrice: (json['groupPrice'] as num).toDouble(),
      minMembers: json['minMembers'] as int,
      currentMembers: json['currentMembers'] as int,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      status: json['status'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productTitle': productTitle,
      'productImage': productImage,
      'organizerId': organizerId,
      'organizerName': organizerName,
      'organizerAvatar': organizerAvatar,
      'originalPrice': originalPrice,
      'groupPrice': groupPrice,
      'minMembers': minMembers,
      'currentMembers': currentMembers,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  GroupBuy copyWith({
    String? id,
    String? productId,
    String? productTitle,
    String? productImage,
    String? organizerId,
    String? organizerName,
    String? organizerAvatar,
    double? originalPrice,
    double? groupPrice,
    int? minMembers,
    int? currentMembers,
    DateTime? startTime,
    DateTime? endTime,
    int? status,
    DateTime? createdAt,
  }) {
    return GroupBuy(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productTitle: productTitle ?? this.productTitle,
      productImage: productImage ?? this.productImage,
      organizerId: organizerId ?? this.organizerId,
      organizerName: organizerName ?? this.organizerName,
      organizerAvatar: organizerAvatar ?? this.organizerAvatar,
      originalPrice: originalPrice ?? this.originalPrice,
      groupPrice: groupPrice ?? this.groupPrice,
      minMembers: minMembers ?? this.minMembers,
      currentMembers: currentMembers ?? this.currentMembers,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
