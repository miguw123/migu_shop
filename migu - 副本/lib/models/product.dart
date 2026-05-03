class Product {
  final String id;
  final String sellerId;
  final String sellerName;
  final String sellerAvatar;
  final String title;
  final String description;
  final String category;
  final double price;
  final String unit;
  final double quantity;
  final List<String> images;
  final double? latitude;
  final double? longitude;
  final String? address;
  final int status;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.sellerId,
    required this.sellerName,
    required this.sellerAvatar,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.unit,
    required this.quantity,
    required this.images,
    this.latitude,
    this.longitude,
    this.address,
    required this.status,
    required this.createdAt,
  });

  String get statusName {
    switch (status) {
      case 0:
        return '待售';
      case 1:
        return '已预订';
      case 2:
        return '已售出';
      default:
        return '未知';
    }
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      sellerId: json['sellerId'] as String,
      sellerName: json['sellerName'] as String,
      sellerAvatar: json['sellerAvatar'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      unit: json['unit'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      images: List<String>.from(json['images'] as List),
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      address: json['address'] as String?,
      status: json['status'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerAvatar': sellerAvatar,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'unit': unit,
      'quantity': quantity,
      'images': images,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Product copyWith({
    String? id,
    String? sellerId,
    String? sellerName,
    String? sellerAvatar,
    String? title,
    String? description,
    String? category,
    double? price,
    String? unit,
    double? quantity,
    List<String>? images,
    double? latitude,
    double? longitude,
    String? address,
    int? status,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      sellerAvatar: sellerAvatar ?? this.sellerAvatar,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      images: images ?? this.images,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
