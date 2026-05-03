import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/warehouse_provider.dart';
import '../../models/warehouse.dart';
import '../../config/theme.dart';

class WarehousePage extends StatefulWidget {
  const WarehousePage({super.key});

  @override
  State<WarehousePage> createState() => _WarehousePageState();
}

class _WarehousePageState extends State<WarehousePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text('货运仓储'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: '仓储服务'),
            Tab(text: '货运需求'),
          ],
        ),
      ),
      body: Consumer<WarehouseProvider>(
        builder: (context, warehouseProvider, child) {
          if (warehouseProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildWarehouseList(warehouseProvider.warehouses),
              _buildFreightList(warehouseProvider.myWarehouses),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddWarehouseDialog(context);
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildWarehouseList(List<Warehouse> warehouses) {
    if (warehouses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warehouse,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              '暂无仓储信息',
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
        await context.read<WarehouseProvider>().refreshWarehouses();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: warehouses.length,
        itemBuilder: (context, index) {
          final warehouse = warehouses[index];
          return _WarehouseCard(warehouse: warehouse);
        },
      ),
    );
  }

  Widget _buildFreightList(List<Warehouse> myWarehouses) {
    if (myWarehouses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_shipping,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              '暂无货运需求',
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
        await context.read<WarehouseProvider>().refreshWarehouses();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: myWarehouses.length,
        itemBuilder: (context, index) {
          final warehouse = myWarehouses[index];
          return _WarehouseCard(warehouse: warehouse);
        },
      ),
    );
  }

  void _showAddWarehouseDialog(BuildContext context) {
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
                    '发布仓储/货运信息',
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
                  const Text(
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

class _WarehouseCard extends StatelessWidget {
  final Warehouse warehouse;

  const _WarehouseCard({required this.warehouse});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          _showWarehouseDetail(context, warehouse);
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
                    warehouse.images.isNotEmpty
                        ? warehouse.images.first
                        : 'https://picsum.photos/400/200',
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 150,
                        color: Colors.grey[200],
                        child: const Icon(Icons.warehouse, size: 50),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: warehouse.available
                          ? Colors.green
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      warehouse.available ? '可用' : '已满',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    warehouse.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          warehouse.address,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '容量',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          Text(
                            '${warehouse.capacity.toStringAsFixed(0)}吨',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '价格',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          Text(
                            '¥${warehouse.price.toStringAsFixed(2)}/吨·天',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '联系人: ${warehouse.ownerName}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.phone,
                        size: 16,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        warehouse.ownerPhone,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
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

  void _showWarehouseDetail(BuildContext context, Warehouse warehouse) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
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
                    '仓储详情',
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
                      warehouse.images.isNotEmpty
                          ? warehouse.images.first
                          : 'https://picsum.photos/400/200',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    warehouse.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _DetailRow(
                    icon: Icons.location_on,
                    label: '地址',
                    value: warehouse.address,
                  ),
                  _DetailRow(
                    icon: Icons.straighten,
                    label: '容量',
                    value: '${warehouse.capacity.toStringAsFixed(0)}吨',
                  ),
                  _DetailRow(
                    icon: Icons.attach_money,
                    label: '价格',
                    value: '¥${warehouse.price.toStringAsFixed(2)}/吨·天',
                  ),
                  _DetailRow(
                    icon: Icons.person,
                    label: '联系人',
                    value: warehouse.ownerName,
                  ),
                  _DetailRow(
                    icon: Icons.phone,
                    label: '联系电话',
                    value: warehouse.ownerPhone,
                    isHighlight: true,
                  ),
                  if (warehouse.description != null) ...[
                    const SizedBox(height: 16),
                    const Text(
                      '详情描述',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      warehouse.description!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: warehouse.available
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('功能开发中...'),
                              ),
                            );
                          }
                        : null,
                    icon: const Icon(Icons.phone),
                    label: const Text('立即联系'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
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

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isHighlight;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isHighlight ? AppTheme.primaryColor : Colors.grey,
          ),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
                color: isHighlight ? AppTheme.primaryColor : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
