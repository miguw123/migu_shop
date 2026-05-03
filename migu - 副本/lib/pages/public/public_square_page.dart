import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../config/theme.dart';

class PublicSquarePage extends StatefulWidget {
  const PublicSquarePage({super.key});

  @override
  State<PublicSquarePage> createState() => _PublicSquarePageState();
}

class _PublicSquarePageState extends State<PublicSquarePage>
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
        title: const Text('公域广场'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryColor,
          isScrollable: true,
          tabs: const [
            Tab(text: '供需广场'),
            Tab(text: '农业资讯'),
            Tab(text: '活动专区'),
            Tab(text: '信用公示'),
            Tab(text: '村仓地图'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSupplyDemandSquare(),
          _buildAgriculturalNews(),
          _buildActivityZone(),
          _buildCreditPublicity(),
          _buildWarehouseMap(),
        ],
      ),
    );
  }

  Widget _buildSupplyDemandSquare() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('供货信息', Icons.shopping_bag),
        _buildSupplyCard(
          '新鲜有机苹果',
          '农户张大哥',
          '¥5.00/斤',
          '1000斤',
          '北京市昌平区',
        ),
        _buildSupplyCard(
          '农家土鸡蛋',
          '养殖户李阿姨',
          '¥12.00/斤',
          '500斤',
          '河北省保定市',
        ),
        const SizedBox(height: 20),
        _buildSectionHeader('求购信息', Icons.search),
        _buildDemandCard(
          '大量收购优质小麦',
          '采购商王总',
          '¥2.50/斤',
          '100吨',
          '山东省济南市',
        ),
        _buildDemandCard(
          '求购新鲜蔬菜',
          '超市采购刘经理',
          '¥面议',
          '不限量',
          '天津市',
        ),
        const SizedBox(height: 20),
        _buildSectionHeader('仓储服务', Icons.warehouse),
        _buildWarehouseServiceCard(
          '青云店村仓',
          '北京市大兴区青云店镇',
          '剩余容量: 500吨',
          '¥0.5/吨·天',
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('查看更多...')),
              );
            },
            child: const Text('查看更多'),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplyCard(
    String title,
    String seller,
    String price,
    String quantity,
    String location,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.image, color: Colors.grey),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    seller,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '库存: $quantity',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
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

  Widget _buildDemandCard(
    String title,
    String buyer,
    String price,
    String quantity,
    String location,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.search, color: AppTheme.accentColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    buyer,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '需求: $quantity',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
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

  Widget _buildWarehouseServiceCard(
    String name,
    String address,
    String capacity,
    String price,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.warehouse, color: AppTheme.primaryColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              address,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
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
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoTag(Icons.straighten, capacity),
                _buildInfoTag(Icons.attach_money, price),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgriculturalNews() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildNewsCard(
          '农业农村部发布2024年农产品质量安全工作要点',
          '2024-01-15',
          '农业政策',
        ),
        _buildNewsCard(
          '全国蔬菜价格走势分析（2024年第一周）',
          '2024-01-14',
          '市场行情',
        ),
        _buildNewsCard(
          '春季果树管理技术要点',
          '2024-01-13',
          '种植技术',
        ),
        _buildNewsCard(
          '农村电商发展新趋势',
          '2024-01-12',
          '行业动态',
        ),
      ],
    );
  }

  Widget _buildNewsCard(String title, String date, String category) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Row(
          children: [
            Text(date, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                category,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('新闻详情开发中...')),
          );
        },
      ),
    );
  }

  Widget _buildActivityZone() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildActivityCard(
          '年货节 - 农产品促销活动',
          '2024-01-01 至 2024-01-31',
          '全场农产品8折优惠',
          Icons.card_giftcard,
          AppTheme.accentColor,
        ),
        _buildActivityCard(
          '助农计划 - 优质农产品推广',
          '长期有效',
          '为优质农户提供免费推广资源',
          Icons.volunteer_activism,
          AppTheme.primaryColor,
        ),
        _buildActivityCard(
          '货运司机招募',
          '长期有效',
          '加入平台，享受多重补贴',
          Icons.local_shipping,
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildActivityCard(
    String title,
    String time,
    String description,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditPublicity() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader2('优秀信用用户', Icons.verified, Colors.green),
        _buildCreditUserCard('张三', 98, '农民', true),
        _buildCreditUserCard('李四', 96, '供货商', true),
        _buildCreditUserCard('王五', 95, '司机', true),
        const SizedBox(height: 20),
        _buildSectionHeader2('信用受限用户', Icons.warning, Colors.orange),
        _buildCreditUserCard('赵六', 82, '采购商', false),
        _buildCreditUserCard('钱七', 78, '农民', false),
      ],
    );
  }

  Widget _buildSectionHeader2(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditUserCard(String name, int score, String role, bool isGood) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isGood ? Colors.green[100] : Colors.orange[100],
          child: Text(
            name[0],
            style: TextStyle(
              color: isGood ? Colors.green[700] : Colors.orange[700],
            ),
          ),
        ),
        title: Text(name),
        subtitle: Text(role),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isGood ? Icons.verified : Icons.warning,
              color: isGood ? Colors.green : Colors.orange,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              '$score分',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isGood ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarehouseMap() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 20),
          const Text(
            '村仓地图',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '全国村仓集约点分布可视化',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('地图功能开发中...')),
              );
            },
            icon: const Icon(Icons.location_on),
            label: const Text('查看我的位置'),
          ),
        ],
      ),
    );
  }
}
