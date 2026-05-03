import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  final List<User> _users = [];
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  List<User> get users => _users;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  UserProvider() {
    _initMockUser();
  }

  void _initMockUser() {
    _currentUser = User(
      id: const Uuid().v4(),
      name: '张三',
      phone: '13800138000',
      avatar: 'https://picsum.photos/200',
      userTypeIndex: 0,
      latitude: 39.9042,
      longitude: 116.4074,
      createdAt: DateTime.now(),
    );
  }

  Future<void> login(String phone, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _currentUser = User(
      id: const Uuid().v4(),
      name: '用户',
      phone: phone,
      avatar: 'https://picsum.photos/200',
      userTypeIndex: 0,
      createdAt: DateTime.now(),
    );

    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  Future<void> updateUser(User user) async {
    _currentUser = user;
    notifyListeners();
  }

  Future<void> updateLocation(double latitude, double longitude) async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        latitude: latitude,
        longitude: longitude,
      );
      notifyListeners();
    }
  }
}
