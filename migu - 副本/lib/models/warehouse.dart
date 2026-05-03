class Warehouse {
  final String id;
  final String ownerId;
  final String ownerName;
  final String ownerPhone;
  final String name;
  final String address;
  final double capacity;
  final double price;
  final List<String> images;
  final double latitude;
  final double longitude;
  final bool available;
  final String? description;
  final DateTime createdAt;

  Warehouse({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    required this.ownerPhone,
    required this.name,
    required this.address,
    required this.capacity,
    required this.price,
    required this.images,
    required this.latitude,
    required this.longitude,
    required this.available,
    this.description,
    required this.createdAt,
  });

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      ownerName: json['ownerName'] as String,
      ownerPhone: json['ownerPhone'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      capacity: (json['capacity'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      images: List<String>.from(json['images'] as List),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      available: json['available'] as bool,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerPhone': ownerPhone,
      'name': name,
      'address': address,
      'capacity': capacity,
      'price': price,
      'images': images,
      'latitude': latitude,
      'longitude': longitude,
      'available': available,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Warehouse copyWith({
    String? id,
    String? ownerId,
    String? ownerName,
    String? ownerPhone,
    String? name,
    String? address,
    double? capacity,
    double? price,
    List<String>? images,
    double? latitude,
    double? longitude,
    bool? available,
    String? description,
    DateTime? createdAt,
  }) {
    return Warehouse(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      name: name ?? this.name,
      address: address ?? this.address,
      capacity: capacity ?? this.capacity,
      price: price ?? this.price,
      images: images ?? this.images,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      available: available ?? this.available,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
