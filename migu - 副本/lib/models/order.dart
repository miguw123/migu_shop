import 'enums.dart';

class Order {
  final String id;
  final String orderCode;
  final String buyerId;
  final String buyerName;
  final String buyerAvatar;
  final String buyerPhone;
  final String buyerAddress;
  final String sellerId;
  final String sellerName;
  final String sellerPhone;
  final String productId;
  final String productTitle;
  final String productImage;
  final int productCategoryIndex;
  final String? warehouseId;
  final String? warehouseName;
  final String? driverId;
  final String? driverName;
  final String? driverPhone;
  final String? communityPickupId;
  final String? communityPickupName;
  final int statusIndex;
  final int currentStepIndex;
  final double productPrice;
  final double freightPrice;
  final double totalPrice;
  final double quantity;
  final String unit;
  final String? promoterId;
  final double? promoterCommission;
  final DateTime? paidAt;
  final DateTime? shippedAt;
  final DateTime? deliveredToWarehouseAt;
  final DateTime? shippedToConsumerAt;
  final DateTime? arrivedAtCommunityAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.orderCode,
    required this.buyerId,
    required this.buyerName,
    required this.buyerAvatar,
    required this.buyerPhone,
    required this.buyerAddress,
    required this.sellerId,
    required this.sellerName,
    required this.sellerPhone,
    required this.productId,
    required this.productTitle,
    required this.productImage,
    required this.productCategoryIndex,
    this.warehouseId,
    this.warehouseName,
    this.driverId,
    this.driverName,
    this.driverPhone,
    this.communityPickupId,
    this.communityPickupName,
    required this.statusIndex,
    required this.currentStepIndex,
    required this.productPrice,
    required this.freightPrice,
    required this.totalPrice,
    required this.quantity,
    required this.unit,
    this.promoterId,
    this.promoterCommission,
    this.paidAt,
    this.shippedAt,
    this.deliveredToWarehouseAt,
    this.shippedToConsumerAt,
    this.arrivedAtCommunityAt,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  OrderStatus get status => OrderStatus.values[statusIndex];
  OrderStep get currentStep => OrderStep.values[currentStepIndex];

  String get statusName {
    switch (status) {
      case OrderStatus.pending:
        return '待付款';
      case OrderStatus.accepted:
        return '待发货';
      case OrderStatus.inTransit:
        return '运输中';
      case OrderStatus.deliveredToWarehouse:
        return '已到村仓';
      case OrderStatus.pickedUp:
        return '已取货';
      case OrderStatus.completed:
        return '已完成';
      case OrderStatus.cancelled:
        return '已取消';
    }
  }

  String get stepName {
    switch (currentStep) {
      case OrderStep.created:
        return '订单创建';
      case OrderStep.paid:
        return '已付款';
      case OrderStep.acceptedBySeller:
        return '商家已接单';
      case OrderStep.shippedToWarehouse:
        return '发往村仓';
      case OrderStep.inWarehouse:
        return '村仓中转';
      case OrderStep.shippedToConsumer:
        return '发往消费者';
      case OrderStep.arrivedAtCommunity:
        return '到达社区';
      case OrderStep.pickedUp:
        return '已取货';
      case OrderStep.completed:
        return '已完成';
    }
  }

  double calculateFreight(double distance, int itemCount) {
    return distance * 3 / 100 + itemCount * 2 + productPrice * 0.05;
  }

  double calculateReturnAmount(double distance, double actualFreight, int itemCount) {
    double returnAmount = distance * 3 / 100 - actualFreight / itemCount;
    return returnAmount > 0 ? returnAmount : 0;
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      orderCode: json['orderCode'] as String,
      buyerId: json['buyerId'] as String,
      buyerName: json['buyerName'] as String,
      buyerAvatar: json['buyerAvatar'] as String,
      buyerPhone: json['buyerPhone'] as String,
      buyerAddress: json['buyerAddress'] as String,
      sellerId: json['sellerId'] as String,
      sellerName: json['sellerName'] as String,
      sellerPhone: json['sellerPhone'] as String,
      productId: json['productId'] as String,
      productTitle: json['productTitle'] as String,
      productImage: json['productImage'] as String,
      productCategoryIndex: json['productCategoryIndex'] as int,
      warehouseId: json['warehouseId'] as String?,
      warehouseName: json['warehouseName'] as String?,
      driverId: json['driverId'] as String?,
      driverName: json['driverName'] as String?,
      driverPhone: json['driverPhone'] as String?,
      communityPickupId: json['communityPickupId'] as String?,
      communityPickupName: json['communityPickupName'] as String?,
      statusIndex: json['statusIndex'] as int,
      currentStepIndex: json['currentStepIndex'] as int,
      productPrice: (json['productPrice'] as num).toDouble(),
      freightPrice: (json['freightPrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      promoterId: json['promoterId'] as String?,
      promoterCommission: (json['promoterCommission'] as num?)?.toDouble(),
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt'] as String) : null,
      shippedAt: json['shippedAt'] != null ? DateTime.parse(json['shippedAt'] as String) : null,
      deliveredToWarehouseAt: json['deliveredToWarehouseAt'] != null ? DateTime.parse(json['deliveredToWarehouseAt'] as String) : null,
      shippedToConsumerAt: json['shippedToConsumerAt'] != null ? DateTime.parse(json['shippedToConsumerAt'] as String) : null,
      arrivedAtCommunityAt: json['arrivedAtCommunityAt'] != null ? DateTime.parse(json['arrivedAtCommunityAt'] as String) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderCode': orderCode,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'buyerAvatar': buyerAvatar,
      'buyerPhone': buyerPhone,
      'buyerAddress': buyerAddress,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerPhone': sellerPhone,
      'productId': productId,
      'productTitle': productTitle,
      'productImage': productImage,
      'productCategoryIndex': productCategoryIndex,
      'warehouseId': warehouseId,
      'warehouseName': warehouseName,
      'driverId': driverId,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'communityPickupId': communityPickupId,
      'communityPickupName': communityPickupName,
      'statusIndex': statusIndex,
      'currentStepIndex': currentStepIndex,
      'productPrice': productPrice,
      'freightPrice': freightPrice,
      'totalPrice': totalPrice,
      'quantity': quantity,
      'unit': unit,
      'promoterId': promoterId,
      'promoterCommission': promoterCommission,
      'paidAt': paidAt?.toIso8601String(),
      'shippedAt': shippedAt?.toIso8601String(),
      'deliveredToWarehouseAt': deliveredToWarehouseAt?.toIso8601String(),
      'shippedToConsumerAt': shippedToConsumerAt?.toIso8601String(),
      'arrivedAtCommunityAt': arrivedAtCommunityAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Order copyWith({
    String? id,
    String? orderCode,
    String? buyerId,
    String? buyerName,
    String? buyerAvatar,
    String? buyerPhone,
    String? buyerAddress,
    String? sellerId,
    String? sellerName,
    String? sellerPhone,
    String? productId,
    String? productTitle,
    String? productImage,
    int? productCategoryIndex,
    String? warehouseId,
    String? warehouseName,
    String? driverId,
    String? driverName,
    String? driverPhone,
    String? communityPickupId,
    String? communityPickupName,
    int? statusIndex,
    int? currentStepIndex,
    double? productPrice,
    double? freightPrice,
    double? totalPrice,
    double? quantity,
    String? unit,
    String? promoterId,
    double? promoterCommission,
    DateTime? paidAt,
    DateTime? shippedAt,
    DateTime? deliveredToWarehouseAt,
    DateTime? shippedToConsumerAt,
    DateTime? arrivedAtCommunityAt,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Order(
      id: id ?? this.id,
      orderCode: orderCode ?? this.orderCode,
      buyerId: buyerId ?? this.buyerId,
      buyerName: buyerName ?? this.buyerName,
      buyerAvatar: buyerAvatar ?? this.buyerAvatar,
      buyerPhone: buyerPhone ?? this.buyerPhone,
      buyerAddress: buyerAddress ?? this.buyerAddress,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      sellerPhone: sellerPhone ?? this.sellerPhone,
      productId: productId ?? this.productId,
      productTitle: productTitle ?? this.productTitle,
      productImage: productImage ?? this.productImage,
      productCategoryIndex: productCategoryIndex ?? this.productCategoryIndex,
      warehouseId: warehouseId ?? this.warehouseId,
      warehouseName: warehouseName ?? this.warehouseName,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      communityPickupId: communityPickupId ?? this.communityPickupId,
      communityPickupName: communityPickupName ?? this.communityPickupName,
      statusIndex: statusIndex ?? this.statusIndex,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      productPrice: productPrice ?? this.productPrice,
      freightPrice: freightPrice ?? this.freightPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      promoterId: promoterId ?? this.promoterId,
      promoterCommission: promoterCommission ?? this.promoterCommission,
      paidAt: paidAt ?? this.paidAt,
      shippedAt: shippedAt ?? this.shippedAt,
      deliveredToWarehouseAt: deliveredToWarehouseAt ?? this.deliveredToWarehouseAt,
      shippedToConsumerAt: shippedToConsumerAt ?? this.shippedToConsumerAt,
      arrivedAtCommunityAt: arrivedAtCommunityAt ?? this.arrivedAtCommunityAt,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
