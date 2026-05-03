import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;
  int _selectedStatus = -1;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  int get selectedStatus => _selectedStatus;

  List<Order> get filteredOrders {
    if (_selectedStatus == -1) {
      return _orders;
    }
    return _orders.where((o) => o.status == _selectedStatus).toList();
  }

  List<Order> get pendingOrders =>
      _orders.where((o) => o.status == 0).toList();

  List<Order> get acceptedOrders =>
      _orders.where((o) => o.status == 1).toList();

  List<Order> get completedOrders =>
      _orders.where((o) => o.status == 3).toList();

  OrderProvider() {
    _loadMockOrders();
  }

  Future<void> _loadMockOrders() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _orders = List.generate(15, (index) {
      final status = index % 5;
      return Order(
        id: const Uuid().v4(),
        buyerId: const Uuid().v4(),
        buyerName: '采购商${index + 1}',
        buyerAvatar: 'https://picsum.photos/100?random=${index + 300}',
        buyerPhone: '1380013${index.toString().padLeft(4, '0')}',
        sellerId: const Uuid().v4(),
        sellerName: '农户${index + 1}',
        productId: const Uuid().v4(),
        productTitle: '农产品${index + 1}',
        productImage: 'https://picsum.photos/200/200?random=${index + 400}',
        price: 5.0 + index * 0.5,
        quantity: 10.0 + index,
        unit: '斤',
        totalPrice: (5.0 + index * 0.5) * (10.0 + index),
        status: status,
        createdAt: DateTime.now().subtract(Duration(hours: index)),
        updatedAt: DateTime.now().subtract(Duration(hours: index - 1)),
      );
    });

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshOrders() async {
    await _loadMockOrders();
  }

  void setStatusFilter(int status) {
    _selectedStatus = status;
    notifyListeners();
  }

  Future<void> acceptOrder(String orderId) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(
        status: 1,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  Future<void> updateOrderStatus(String orderId, int status) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  Future<void> cancelOrder(String orderId) async {
    await updateOrderStatus(orderId, 4);
  }

  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (e) {
      return null;
    }
  }
}
