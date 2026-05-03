enum UserType {
  farmer,
  villageWarehouse,
  urbanUser,
  driver,
  communityPickup,
}

enum UserRole {
  consumer,
  supplier,
  promoter,
  warehouseAdmin,
  driverRole,
  communityAdmin,
}

enum VehicleType {
  truck,
  pickup,
  smallVan,
  privateCar,
  suv,
}

enum VideoType {
  goods,
  purchase,
  knowledge,
  question,
}

enum ProductCategory {
  dryGoods,
  freshFruits,
  poultryLivestock,
  specialtySide,
  mountainGoods,
}

enum ProductStatus {
  available,
  reserved,
  sold,
}

enum OrderStatus {
  pending,
  accepted,
  inTransit,
  deliveredToWarehouse,
  pickedUp,
  completed,
  cancelled,
}

enum OrderStep {
  created,
  paid,
  acceptedBySeller,
  shippedToWarehouse,
  inWarehouse,
  shippedToConsumer,
  arrivedAtCommunity,
  pickedUp,
  completed,
}

enum MessageType {
  text,
  image,
  voice,
  video,
  orderNotification,
  systemNotification,
}

enum FreightOrderStatus {
  pending,
  assigned,
  pickedUp,
  inTransit,
  arrived,
  delivered,
}

class AppConstants {
  static const String appName = '农短视频';
  static const String appVersion = '1.0.0';

  static const int videoPreloadCount = 3;
  static const int maxVideoCacheSize = 500 * 1024 * 1024;
  static const int maxImageCacheSize = 200 * 1024 * 1024;

  static const Duration videoCacheExpiration = Duration(days: 7);
  static const Duration apiTimeout = Duration(seconds: 30);

  static const int maxImagesPerPost = 9;
  static const int maxVideoLength = 60;

  static const int initialCreditScore = 100;
  static const int minCreditScoreForPost = 85;
  static const int minCreditScoreForChat = 85;
  static const int minCreditScoreForNoLimit = 95;
  static const int creditScoreForPermanentBan = 60;

  static const double platformFeeRate = 0.05;
  static const double promoterFeeRate = 0.05;
  static const double supplierRateWithPromoter = 0.90;
  static const double supplierRateWithoutPromoter = 0.95;

  static const double freightBaseRate = 3.0;
  static const double freightPerItem = 2.0;

  static const int matchingThreshold = 80;

  static const List<String> productCategories = [
    '干货特产',
    '生鲜果蔬',
    '家禽家畜',
    '特色辅菜',
    '山中找货',
  ];

  static const List<String> productUnits = [
    '斤',
    '公斤',
    '吨',
    '个',
    '箱',
    '袋',
    '亩',
    '头',
    '只',
  ];

  static const List<String> videoTabs = [
    '求知',
    '科普',
    '好物',
    '求购',
  ];
}
