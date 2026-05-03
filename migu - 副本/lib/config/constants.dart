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

  static const List<String> productCategories = [
    '粮食作物',
    '蔬菜',
    '水果',
    '畜牧产品',
    '水产',
    '特产',
    '苗木花卉',
    '农资工具',
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
}

class AppRoutes {
  static const String home = '/';
  static const String videoDetail = '/video/:id';
  static const String publish = '/publish';
  static const String productForm = '/publish/product';
  static const String orders = '/orders';
  static const String orderDetail = '/orders/:id';
  static const String warehouse = '/warehouse';
  static const String warehouseDetail = '/warehouse/:id';
  static const String groupBuy = '/group-buy';
  static const String groupBuyDetail = '/group-buy/:id';
  static const String profile = '/profile';
}
