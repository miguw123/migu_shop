import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/message_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/message.dart';
import '../../config/theme.dart';
import '../../widgets/common/loading.dart';

class MessageListPage extends StatefulWidget {
  const MessageListPage({super.key});

  @override
  State<MessageListPage> createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('消息'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryColor,
          isScrollable: true,
          tabs: const [
            Tab(text: '聊天'),
            Tab(text: '订单'),
            Tab(text: '互动'),
            Tab(text: '信用'),
            Tab(text: '推广'),
          ],
        ),
      ),
      body: Consumer<MessageProvider>(
        builder: (context, messageProvider, child) {
          if (messageProvider.isLoading) {
            return const LoadingWidget(message: '加载中...');
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildChatList(messageProvider.chatMessages),
              _buildOrderMessageList(messageProvider.orderMessages),
              _buildInteractionList(messageProvider.interactionMessages),
              _buildCreditList(messageProvider.creditMessages),
              _buildPromotionList(messageProvider.promotionMessages),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChatList(List<Message> messages) {
    if (messages.isEmpty) {
      return _buildEmptyState('暂无聊天消息', Icons.chat_bubble_outline);
    }

    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _ChatListItem(message: message);
      },
    );
  }

  Widget _buildOrderMessageList(List<Message> messages) {
    if (messages.isEmpty) {
      return _buildEmptyState('暂无订单消息', Icons.receipt_long_outlined);
    }

    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _OrderMessageItem(message: message);
      },
    );
  }

  Widget _buildInteractionList(List<Message> messages) {
    if (messages.isEmpty) {
      return _buildEmptyState('暂无互动消息', Icons.thumb_up_outlined);
    }

    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _InteractionMessageItem(message: message);
      },
    );
  }

  Widget _buildCreditList(List<Message> messages) {
    if (messages.isEmpty) {
      return _buildEmptyState('暂无信用消息', Icons.credit_score_outlined);
    }

    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _CreditMessageItem(message: message);
      },
    );
  }

  Widget _buildPromotionList(List<Message> messages) {
    if (messages.isEmpty) {
      return _buildEmptyState('暂无推广消息', Icons.campaign_outlined);
    }

    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _PromotionMessageItem(message: message);
      },
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

class _ChatListItem extends StatelessWidget {
  final Message message;

  const _ChatListItem({required this.message});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(message.senderAvatar),
        radius: 25,
      ),
      title: Text(
        message.senderName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        message.content,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.grey[600]),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(message.createdAt),
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
          if (!message.isRead)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Text(
                '1',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
        ],
      ),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('聊天功能开发中...')),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return '刚刚';
    if (diff.inHours < 1) return '${diff.inMinutes}分钟前';
    if (diff.inDays < 1) return '${diff.inHours}小时前';
    if (diff.inDays < 7) return '${diff.inDays}天前';

    return '${time.month}/${time.day}';
  }
}

class _OrderMessageItem extends StatelessWidget {
  final Message message;

  const _OrderMessageItem({required this.message});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.receipt_long, color: AppTheme.primaryColor),
      ),
      title: Text(
        message.title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        message.content,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        _formatTime(message.createdAt),
        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
      ),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('订单详情开发中...')),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inHours < 1) return '${diff.inMinutes}分钟前';
    if (diff.inDays < 1) return '${diff.inHours}小时前';

    return '${time.month}/${time.day}';
  }
}

class _InteractionMessageItem extends StatelessWidget {
  final Message message;

  const _InteractionMessageItem({required this.message});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        _getInteractionIcon(message.messageType),
        color: AppTheme.accentColor,
        size: 30,
      ),
      title: Text(
        message.senderName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        message.content,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        _formatTime(message.createdAt),
        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
      ),
    );
  }

  IconData _getInteractionIcon(MessageType type) {
    switch (type) {
      case MessageType.text:
        return Icons.thumb_up;
      case MessageType.image:
        return Icons.comment;
      case MessageType.voice:
        return Icons.share;
      default:
        return Icons.notifications;
    }
  }

  String _formatTime(DateTime time) {
    return '${time.month}/${time.day}';
  }
}

class _CreditMessageItem extends StatelessWidget {
  final Message message;

  const _CreditMessageItem({required this.message});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _getCreditColor(message.content).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.credit_score,
          color: _getCreditColor(message.content),
        ),
      ),
      title: Text(
        message.title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        message.content,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        _formatTime(message.createdAt),
        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
      ),
    );
  }

  Color _getCreditColor(String content) {
    if (content.contains('+')) {
      return Colors.green;
    } else if (content.contains('-')) {
      return Colors.red;
    }
    return Colors.orange;
  }

  String _formatTime(DateTime time) {
    return '${time.month}/${time.day}';
  }
}

class _PromotionMessageItem extends StatelessWidget {
  final Message message;

  const _PromotionMessageItem({required this.message});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.accentColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.campaign, color: AppTheme.accentColor),
      ),
      title: Text(
        message.title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        message.content,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        _formatTime(message.createdAt),
        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.month}/${time.day}';
  }
}
