import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/warehouse.dart';

class WarehouseProvider with ChangeNotifier {
  List<Warehouse> _warehouses = [];
  List<Warehouse> _myWarehouses = [];
  bool _isLoading = false;

  List<Warehouse> get warehouses => _warehouses;
  List<Warehouse> get myWarehouses => _myWarehouses;
  bool get isLoading => _isLoading;

  WarehouseProvider() {
    _loadMockWarehouses();
  }

  Future<void> _loadMockWarehouses() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _warehouses = List.generate(10, (index) {
      return Warehouse(
        id: const Uuid().v4(),
        ownerId: const Uuid().v4(),
        ownerName: '仓储服务商${index + 1}',
        ownerPhone: '1380013${index.toString().padLeft(4, '0')}',
        name: '农产品仓储中心${index + 1}',
        address: '北京市大兴区青云店镇${index + 1}号',
        capacity: 1000.0 + index * 500,
        price: 0.5 + index * 0.1,
        images: [
          'https://picsum.photos/400/300?random=${index + 500}',
        ],
        latitude: 39.7345 + index * 0.01,
        longitude: 116.3289 + index * 0.01,
        available: index % 2 == 0,
        description: '专业农产品仓储服务，冷藏保鲜，交通便利',
        createdAt: DateTime.now().subtract(Duration(hours: index)),
      );
    });

    _myWarehouses = _warehouses.take(2).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshWarehouses() async {
    await _loadMockWarehouses();
  }

  Future<void> addWarehouse(Warehouse warehouse) async {
    _warehouses.insert(0, warehouse);
    _myWarehouses.insert(0, warehouse);
    notifyListeners();
  }

  Future<void> updateWarehouse(Warehouse warehouse) async {
    final index = _warehouses.indexWhere((w) => w.id == warehouse.id);
    if (index != -1) {
      _warehouses[index] = warehouse;
    }
    final myIndex = _myWarehouses.indexWhere((w) => w.id == warehouse.id);
    if (myIndex != -1) {
      _myWarehouses[myIndex] = warehouse;
    }
    notifyListeners();
  }

  Future<void> deleteWarehouse(String warehouseId) async {
    _warehouses.removeWhere((w) => w.id == warehouseId);
    _myWarehouses.removeWhere((w) => w.id == warehouseId);
    notifyListeners();
  }

  Warehouse? getWarehouseById(String id) {
    try {
      return _warehouses.firstWhere((w) => w.id == id);
    } catch (e) {
      return null;
    }
  }
}
