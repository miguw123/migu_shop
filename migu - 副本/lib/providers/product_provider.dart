import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _myProducts = [];
  bool _isLoading = false;
  String? _selectedCategory;

  List<Product> get products => _products;
  List<Product> get myProducts => _myProducts;
  bool get isLoading => _isLoading;
  String? get selectedCategory => _selectedCategory;

  List<Product> get filteredProducts {
    if (_selectedCategory == null || _selectedCategory == '全部') {
      return _products;
    }
    return _products.where((p) => p.category == _selectedCategory).toList();
  }

  ProductProvider() {
    _loadMockProducts();
  }

  Future<void> _loadMockProducts() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final categories = ['粮食作物', '蔬菜', '水果', '畜牧产品', '特产'];
    _products = List.generate(20, (index) {
      final category = categories[index % categories.length];
      return Product(
        id: const Uuid().v4(),
        sellerId: const Uuid().v4(),
        sellerName: '农户${index + 1}',
        sellerAvatar: 'https://picsum.photos/100?random=${index + 100}',
        title: '$category - 新鲜上市${index + 1}',
        description: '自家种植的$category，自然成熟，无农药残留，欢迎选购',
        category: category,
        price: 5.0 + (index % 10) * 2.0,
        unit: '斤',
        quantity: 100.0 + index * 10,
        images: [
          'https://picsum.photos/400/400?random=${index + 200}',
        ],
        latitude: 39.9042 + (index % 10) * 0.01,
        longitude: 116.4074 + (index % 10) * 0.01,
        address: '北京市昌平区',
        status: index % 3,
        createdAt: DateTime.now().subtract(Duration(hours: index)),
      );
    });

    _myProducts = _products.take(5).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshProducts() async {
    await _loadMockProducts();
  }

  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    _products.insert(0, product);
    _myProducts.insert(0, product);
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
    final myIndex = _myProducts.indexWhere((p) => p.id == product.id);
    if (myIndex != -1) {
      _myProducts[myIndex] = product;
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String productId) async {
    _products.removeWhere((p) => p.id == productId);
    _myProducts.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
