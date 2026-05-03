import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../models/order.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('订单管理'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: '待接单'),
            Tab(text: '已接单'),
            Tab(text: '已完成'),
          ],
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildOrderList(orderProvider.pendingOrders, '暂无待接单订单'),
              _buildOrderList(orderProvider.acceptedOrders, '暂无已接单订单'),
              _buildOrderList(orderProvider.completedOrders, '暂无已完成订单'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders, String emptyMessage) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
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
        await context.read<OrderProvider>().refreshOrders();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _OrderCard(order: order);
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          _showOrderDetail(context, order);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(order.buyerAvatar),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.buyerName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.buyerPhone,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _StatusBadge(status: order.status),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        order.productImage,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.productTitle,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${order.quantity}${order.unit} × ¥${order.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '总计: ¥${order.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    _formatTime(order.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  const Spacer(),
                  if (order.status == 0)
                    ElevatedButton(
                      onPressed: () {
                        context.read<OrderProvider>().acceptOrder(order.id);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                      ),
                      child: const Text('接单'),
                    ),
                  if (order.status == 0)
                    const SizedBox(width: 8),
                  if (order.status == 0)
                    OutlinedButton(
                      onPressed: () {
                        context.read<OrderProvider>().cancelOrder(order.id);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                      ),
                      child: const Text('取消'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else {
      return '${difference.inDays}天前';
    }
  }

  void _showOrderDetail(BuildContext context, Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
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
                    '订单详情',
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
                  _DetailSection(
                    title: '订单信息',
                    children: [
                      _DetailItem(label: '订单编号', value: order.id),
                      _DetailItem(label: '订单状态', value: order.statusName),
                      _DetailItem(
                        label: '创建时间',
                        value: order.createdAt.toString().substring(0, 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _DetailSection(
                    title: '买家信息',
                    children: [
                      _DetailItem(label: '买家名称', value: order.buyerName),
                      _DetailItem(label: '联系电话', value: order.buyerPhone),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _DetailSection(
                    title: '商品信息',
                    children: [
                      _DetailItem(label: '商品名称', value: order.productTitle),
                      _DetailItem(
                        label: '单价',
                        value: '¥${order.price.toStringAsFixed(2)}/${order.unit}',
                      ),
                      _DetailItem(
                        label: '数量',
                        value: '${order.quantity}${order.unit}',
                      ),
                      _DetailItem(
                        label: '总价',
                        value: '¥${order.totalPrice.toStringAsFixed(2)}',
                        valueStyle: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (order.status == 0)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<OrderProvider>().acceptOrder(order.id);
                              Navigator.pop(context);
                            },
                            child: const Text('接单'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              context.read<OrderProvider>().cancelOrder(order.id);
                              Navigator.pop(context);
                            },
                            child: const Text('取消订单'),
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
}

class _StatusBadge extends StatelessWidget {
  final int status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case 0:
        backgroundColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
        text = '待接单';
        break;
      case 1:
        backgroundColor = Colors.blue.withValues(alpha: 0.1);
        textColor = Colors.blue;
        text = '已接单';
        break;
      case 2:
        backgroundColor = Colors.purple.withValues(alpha: 0.1);
        textColor = Colors.purple;
        text = '进行中';
        break;
      case 3:
        backgroundColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green;
        text = '已完成';
        break;
      case 4:
        backgroundColor = Colors.grey.withValues(alpha: 0.1);
        textColor = Colors.grey;
        text = '已取消';
        break;
      default:
        backgroundColor = Colors.grey.withValues(alpha: 0.1);
        textColor = Colors.grey;
        text = '未知';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _DetailSection({
    required this.title,
    required this.children,
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
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _DetailItem({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: valueStyle ??
                  const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
