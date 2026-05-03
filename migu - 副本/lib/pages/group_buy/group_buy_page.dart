import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/group_buy_provider.dart';
import '../../models/group_buy.dart';
import '../../config/theme.dart';

class GroupBuyPage extends StatefulWidget {
  const GroupBuyPage({super.key});

  @override
  State<GroupBuyPage> createState() => _GroupBuyPageState();
}

class _GroupBuyPageState extends State<GroupBuyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('同城团购'),
      ),
      body: Consumer<GroupBuyProvider>(
        builder: (context, groupBuyProvider, child) {
          if (groupBuyProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          final activeGroupBuys = groupBuyProvider.activeGroupBuys;

          if (activeGroupBuys.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_sale,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '暂无进行中的团购',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppTheme.primaryColor,
            onRefresh: () async {
              await groupBuyProvider.refreshGroupBuys();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: activeGroupBuys.length,
              itemBuilder: (context, index) {
                final groupBuy = activeGroupBuys[index];
                return _GroupBuyCard(groupBuy: groupBuy);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateGroupBuyDialog(context);
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showCreateGroupBuyDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  const Text(
                    '发起团购',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  Text(
                    '功能开发中...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupBuyCard extends StatelessWidget {
  final GroupBuy groupBuy;

  const _GroupBuyCard({required this.groupBuy});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          _showGroupBuyDetail(context, groupBuy);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    groupBuy.productImage,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 180,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, size: 50),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '省¥${(groupBuy.originalPrice - groupBuy.groupPrice).toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: _CountdownWidget(remainingSeconds: groupBuy.remainingSeconds),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    groupBuy.productTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(groupBuy.organizerAvatar),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          groupBuy.organizerName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '¥${groupBuy.groupPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '¥${groupBuy.originalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _ProgressWidget(
                    currentMembers: groupBuy.currentMembers,
                    minMembers: groupBuy.minMembers,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: groupBuy.isActive
                              ? () {
                                  context.read<GroupBuyProvider>().joinGroupBuy(groupBuy.id);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            groupBuy.currentMembers >= groupBuy.minMembers
                                ? '已满员'
                                : '立即参团',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGroupBuyDetail(BuildContext context, GroupBuy groupBuy) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  const Text(
                    '团购详情',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      groupBuy.productImage,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    groupBuy.productTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '¥${groupBuy.groupPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '¥${groupBuy.originalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[500],
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '省¥${(groupBuy.originalPrice - groupBuy.groupPrice).toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _DetailSection(
                    title: '团购进度',
                    child: Column(
                      children: [
                        _ProgressWidget(
                          currentMembers: groupBuy.currentMembers,
                          minMembers: groupBuy.minMembers,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '已有 ${groupBuy.currentMembers} 人参与',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '还差 ${groupBuy.minMembers - groupBuy.currentMembers} 人成团',
                              style: TextStyle(
                                fontSize: 14,
                                color: groupBuy.currentMembers >= groupBuy.minMembers
                                    ? Colors.green
                                    : Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _DetailSection(
                    title: '活动时间',
                    child: Row(
                      children: [
                        Icon(
                          Icons.timer,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '剩余 ${_formatDuration(groupBuy.remainingSeconds)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _DetailSection(
                    title: '组织者',
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(groupBuy.organizerAvatar),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          groupBuy.organizerName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: groupBuy.isActive
                        ? () {
                            context.read<GroupBuyProvider>().joinGroupBuy(groupBuy.id);
                            Navigator.pop(context);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      groupBuy.currentMembers >= groupBuy.minMembers
                          ? '人数已满'
                          : '我要参团',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    if (seconds <= 0) return '已结束';

    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours}小时${minutes}分${secs}秒';
    } else if (minutes > 0) {
      return '${minutes}分${secs}秒';
    } else {
      return '${secs}秒';
    }
  }
}

class _CountdownWidget extends StatelessWidget {
  final int remainingSeconds;

  const _CountdownWidget({required this.remainingSeconds});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.timer,
            color: Colors.white,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            _formatCountdown(remainingSeconds),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCountdown(int seconds) {
    if (seconds <= 0) return '已结束';

    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;

    if (hours > 0) {
      return '${hours}h${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}

class _ProgressWidget extends StatelessWidget {
  final int currentMembers;
  final int minMembers;

  const _ProgressWidget({
    required this.currentMembers,
    required this.minMembers,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentMembers / minMembers).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              currentMembers >= minMembers ? Colors.green : AppTheme.primaryColor,
            ),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _DetailSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: child,
        ),
      ],
    );
  }
}
