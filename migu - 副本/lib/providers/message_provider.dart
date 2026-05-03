import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/message.dart';

class MessageProvider with ChangeNotifier {
  List<Message> _chatMessages = [];
  List<Message> _orderMessages = [];
  List<Message> _interactionMessages = [];
  List<Message> _creditMessages = [];
  List<Message> _promotionMessages = [];
  bool _isLoading = false;

  List<Message> get chatMessages => _chatMessages;
  List<Message> get orderMessages => _orderMessages;
  List<Message> get interactionMessages => _interactionMessages;
  List<Message> get creditMessages => _creditMessages;
  List<Message> get promotionMessages => _promotionMessages;
  bool get isLoading => _isLoading;

  MessageProvider() {
    _loadMockMessages();
  }

  Future<void> _loadMockMessages() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _chatMessages = List.generate(5, (index) {
      return Message(
        id: const Uuid().v4(),
        senderId: const Uuid().v4(),
        senderName: '用户${index + 1}',
        senderAvatar: 'https://picsum.photos/100?random=${index + 100}',
        receiverId: const Uuid().v4(),
        messageType: MessageType.text,
        title: '',
        content: '您好，我想咨询一下农产品的问题...',
        isRead: index < 2,
        createdAt: DateTime.now().subtract(Duration(hours: index * 2)),
      );
    });

    _orderMessages = List.generate(3, (index) {
      return Message(
        id: const Uuid().v4(),
        senderId: const Uuid().v4(),
        senderName: '系统通知',
        senderAvatar: 'https://picsum.photos/100?random=200',
        receiverId: const Uuid().v4(),
        messageType: MessageType.orderNotification,
        title: _getOrderTitle(index),
        content: _getOrderContent(index),
        isRead: index < 1,
        createdAt: DateTime.now().subtract(Duration(hours: index * 3)),
      );
    });

    _interactionMessages = List.generate(4, (index) {
      return Message(
        id: const Uuid().v4(),
        senderId: const Uuid().v4(),
        senderName: '用户${index + 10}',
        senderAvatar: 'https://picsum.photos/100?random=${index + 300}',
        receiverId: const Uuid().v4(),
        messageType: MessageType.text,
        title: '',
        content: _getInteractionContent(index),
        isRead: index < 3,
        createdAt: DateTime.now().subtract(Duration(hours: index * 5)),
      );
    });

    _creditMessages = List.generate(2, (index) {
      final isPositive = index == 0;
      return Message(
        id: const Uuid().v4(),
        senderId: const Uuid().v4(),
        senderName: '信用中心',
        senderAvatar: 'https://picsum.photos/100?random=400',
        receiverId: const Uuid().v4(),
        messageType: MessageType.systemNotification,
        title: isPositive ? '信用分提升' : '信用分扣除',
        content: isPositive
            ? '恭喜！您的信用分 +2，当前信用分：100'
            : '警告！您的信用分 -5，当前信用分：95',
        isRead: false,
        createdAt: DateTime.now().subtract(Duration(days: index)),
      );
    });

    _promotionMessages = List.generate(2, (index) {
      return Message(
        id: const Uuid().v4(),
        senderId: const Uuid().v4(),
        senderName: '推广中心',
        senderAvatar: 'https://picsum.photos/100?random=500',
        receiverId: const Uuid().v4(),
        messageType: MessageType.systemNotification,
        title: '推广佣金到账',
        content: '您推广的商品已成交，获得佣金 ¥${10 + index * 5}.00',
        isRead: index < 1,
        createdAt: DateTime.now().subtract(Duration(days: index)),
      );
    });

    _isLoading = false;
    notifyListeners();
  }

  String _getOrderTitle(int index) {
    switch (index) {
      case 0:
        return '订单已付款';
      case 1:
        return '订单已发货';
      case 2:
        return '订单已完成';
      default:
        return '订单状态更新';
    }
  }

  String _getOrderContent(int index) {
    switch (index) {
      case 0:
        return '您的订单 #NDD20240115001 已付款，等待商家发货';
      case 1:
        return '您的订单 #NDD20240115001 已发货，预计3天后送达';
      case 2:
        return '您的订单 #NDD20240115001 已完成，感谢您的购买！';
      default:
        return '订单状态已更新';
    }
  }

  String _getInteractionContent(int index) {
    switch (index) {
      case 0:
        return '赞了您的视频';
      case 1:
        return '评论了您的视频：写得很好！';
      case 2:
        return '转发了您的视频';
      case 3:
        return '@了您';
      default:
        return '互动了您的内容';
    }
  }

  Future<void> refreshMessages() async {
    await _loadMockMessages();
  }

  Future<void> markAsRead(String messageId) async {
    _updateMessageReadStatus(_chatMessages, messageId, true);
    _updateMessageReadStatus(_orderMessages, messageId, true);
    _updateMessageReadStatus(_interactionMessages, messageId, true);
    _updateMessageReadStatus(_creditMessages, messageId, true);
    _updateMessageReadStatus(_promotionMessages, messageId, true);
    notifyListeners();
  }

  void _updateMessageReadStatus(List<Message> messages, String messageId, bool isRead) {
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      messages[index] = messages[index].copyWith(isRead: isRead);
    }
  }

  int get totalUnreadCount {
    return _chatMessages.where((m) => !m.isRead).length +
        _orderMessages.where((m) => !m.isRead).length +
        _interactionMessages.where((m) => !m.isRead).length +
        _creditMessages.where((m) => !m.isRead).length +
        _promotionMessages.where((m) => !m.isRead).length;
  }
}
