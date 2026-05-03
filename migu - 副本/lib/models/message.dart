import 'enums.dart';

class Message {
  final String id;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String receiverId;
  final MessageType messageType;
  final String title;
  final String content;
  final bool isRead;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.receiverId,
    required this.messageType,
    required this.title,
    required this.content,
    this.isRead = false,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderAvatar: json['senderAvatar'] as String,
      receiverId: json['receiverId'] as String,
      messageType: MessageType.values[json['messageType'] as int],
      title: json['title'] as String,
      content: json['content'] as String,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'receiverId': receiverId,
      'messageType': messageType.index,
      'title': title,
      'content': content,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Message copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? senderAvatar,
    String? receiverId,
    MessageType? messageType,
    String? title,
    String? content,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      receiverId: receiverId ?? this.receiverId,
      messageType: messageType ?? this.messageType,
      title: title ?? this.title,
      content: content ?? this.content,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
