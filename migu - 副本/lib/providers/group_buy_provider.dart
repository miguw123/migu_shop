import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/group_buy.dart';

class GroupBuyProvider with ChangeNotifier {
  List<GroupBuy> _groupBuys = [];
  List<GroupBuy> _myGroupBuys = [];
  bool _isLoading = false;

  List<GroupBuy> get groupBuys => _groupBuys;
  List<GroupBuy> get myGroupBuys => _myGroupBuys;
  bool get isLoading => _isLoading;

  List<GroupBuy> get activeGroupBuys =>
      _groupBuys.where((g) => g.isActive).toList();

  GroupBuyProvider() {
    _loadMockGroupBuys();
  }

  Future<void> _loadMockGroupBuys() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _groupBuys = List.generate(12, (index) {
      final status = index % 3;
      final endTime = DateTime.now().add(Duration(hours: 24 + index * 2));
      return GroupBuy(
        id: const Uuid().v4(),
        productId: const Uuid().v4(),
        productTitle: '新鲜水果拼盘${index + 1}',
        productImage: 'https://picsum.photos/300/300?random=${index + 600}',
        organizerId: const Uuid().v4(),
        organizerName: '团购组织者${index + 1}',
        organizerAvatar: 'https://picsum.photos/100?random=${index + 700}',
        originalPrice: 99.0 + index * 10,
        groupPrice: 59.0 + index * 5,
        minMembers: 5 + index % 5,
        currentMembers: index + 1,
        startTime: DateTime.now().subtract(Duration(hours: index)),
        endTime: endTime,
        status: status,
        createdAt: DateTime.now().subtract(Duration(hours: index)),
      );
    });

    _myGroupBuys = _groupBuys.take(3).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshGroupBuys() async {
    await _loadMockGroupBuys();
  }

  Future<void> joinGroupBuy(String groupBuyId) async {
    final index = _groupBuys.indexWhere((g) => g.id == groupBuyId);
    if (index != -1) {
      final groupBuy = _groupBuys[index];
      if (groupBuy.currentMembers < groupBuy.minMembers) {
        _groupBuys[index] = groupBuy.copyWith(
          currentMembers: groupBuy.currentMembers + 1,
        );
        if (_groupBuys[index].currentMembers >= _groupBuys[index].minMembers) {
          _groupBuys[index] = _groupBuys[index].copyWith(status: 1);
        }
        notifyListeners();
      }
    }
  }

  Future<void> createGroupBuy(GroupBuy groupBuy) async {
    _groupBuys.insert(0, groupBuy);
    _myGroupBuys.insert(0, groupBuy);
    notifyListeners();
  }

  GroupBuy? getGroupBuyById(String id) {
    try {
      return _groupBuys.firstWhere((g) => g.id == id);
    } catch (e) {
      return null;
    }
  }
}
