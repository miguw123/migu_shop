import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/product_provider.dart';
import '../../models/enums.dart';
import '../../config/theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('设置功能开发中...')),
              );
            },
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.currentUser;

          if (user == null) {
            return const Center(child: Text('请先登录'));
          }

          return ListView(
            children: [
              _buildProfileHeader(context, user),
              _buildCreditScoreSection(context, user),
              _buildRoleSwitchSection(context, user),
              _buildOrderSection(context),
              _buildRoleSpecificSection(context, user),
              _buildWalletSection(context),
              _buildSettingsSection(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user.avatar),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            user.userTypeName,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          user.realNameAuth ? Icons.verified : Icons.verified_outlined,
                          size: 16,
                          color: user.realNameAuth ? Colors.amber : Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          user.realNameAuth ? '已实名认证' : '未实名认证',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('编辑资料功能开发中...')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('信用分', '${user.creditScore}', user.creditLevel),
              _buildStatItem('订单数', '0', '累计'),
              _buildStatItem('收藏', '0', '累计'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String sub) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$label · $sub',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildCreditScoreSection(BuildContext context, user) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.credit_score, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              const Text(
                '信用分',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getCreditColor(user.creditScore).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${user.creditScore}分 - ${user.creditLevel}',
                  style: TextStyle(
                    color: _getCreditColor(user.creditScore),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: user.creditScore / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getCreditColor(user.creditScore),
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          _buildCreditTips(user.creditScore),
        ],
      ),
    );
  }

  Widget _buildCreditTips(int score) {
    if (score >= 95) {
      return Row(
        children: [
          Icon(Icons.verified, color: Colors.green[600], size: 16),
          const SizedBox(width: 4),
          const Expanded(
            child: Text(
              '信用优秀，享受全部功能权限',
              style: TextStyle(fontSize: 12, color: Colors.green),
            ),
          ),
        ],
      );
    } else if (score >= 85) {
      return Row(
        children: [
          Icon(Icons.check_circle, color: Colors.blue[600], size: 16),
          const SizedBox(width: 4),
          const Expanded(
            child: Text(
              '信用良好，正常使用所有功能',
              style: TextStyle(fontSize: 12, color: Colors.blue),
            ),
          ),
        ],
      );
    } else if (score >= 60) {
      return Row(
        children: [
          Icon(Icons.warning, color: Colors.orange[600], size: 16),
          const SizedBox(width: 4),
          const Expanded(
            child: Text(
              '信用受限，每日签到可恢复1分/次',
              style: TextStyle(fontSize: 12, color: Colors.orange),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Icon(Icons.error, color: Colors.red[600], size: 16),
          const SizedBox(width: 4),
          const Expanded(
            child: Text(
              '账号已被永久封禁',
              style: TextStyle(fontSize: 12, color: Colors.red),
            ),
          ),
        ],
      );
    }
  }

  Color _getCreditColor(int score) {
    if (score >= 95) return Colors.green;
    if (score >= 85) return Colors.blue;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  Widget _buildRoleSwitchSection(BuildContext context, user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '角色切换',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildRoleChip('消费者', Icons.person, user.userTypeIndex == 2),
              _buildRoleChip('货主', Icons.store, user.userTypeIndex == 0 || user.userTypeIndex == 1),
              _buildRoleChip('货运', Icons.local_shipping, user.userTypeIndex == 3),
              _buildRoleChip('村仓', Icons.warehouse, user.userTypeIndex == 4),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleChip(String label, IconData icon, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryColor.withValues(alpha: 0.1)
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppTheme.primaryColor : Colors.grey,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? AppTheme.primaryColor : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '我的订单',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('订单管理开发中...')),
                  );
                },
                child: const Text('查看全部'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOrderItem(Icons.payment, '待付款', 0),
              _buildOrderItem(Icons.inventory, '待发货', 0),
              _buildOrderItem(Icons.local_shipping, '待收货', 0),
              _buildOrderItem(Icons.check_circle, '已完成', 0),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(IconData icon, String label, int count) {
    return Column(
      children: [
        Stack(
          children: [
            Icon(icon, size: 30, color: Colors.grey[700]),
            if (count > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSpecificSection(BuildContext context, user) {
    List<Map<String, dynamic>> menuItems;

    switch (user.userType) {
      case UserType.farmer:
      case UserType.urbanUser:
        menuItems = [
          {'icon': Icons.shopping_bag, 'title': '商品管理', 'subtitle': '管理我的商品'},
          {'icon': Icons.video_library, 'title': '视频管理', 'subtitle': '管理我的视频'},
          {'icon': Icons.inventory, 'title': '库存管理', 'subtitle': '查看库存数据'},
          {'icon': Icons.attach_money, 'title': '收益提现', 'subtitle': '查看收益明细'},
        ];
        break;
      case UserType.villageWarehouse:
        menuItems = [
          {'icon': Icons.warehouse, 'title': '仓储管理', 'subtitle': '管理仓储信息'},
          {'icon': Icons.swap_horiz, 'title': '中转订单', 'subtitle': '处理中转订单'},
          {'icon': Icons.bar_chart, 'title': '出入库统计', 'subtitle': '查看统计数据'},
        ];
        break;
      case UserType.driver:
        menuItems = [
          {'icon': Icons.local_shipping, 'title': '接单管理', 'subtitle': '管理运输订单'},
          {'icon': Icons.route, 'title': '路线规划', 'subtitle': '查看运输路线'},
          {'icon': Icons.account_balance_wallet, 'title': '运费提现', 'subtitle': '查看运费明细'},
          {'icon': Icons.directions_car, 'title': '车辆信息', 'subtitle': '管理车辆'},
        ];
        break;
      case UserType.communityPickup:
        menuItems = [
          {'icon': Icons.receipt, 'title': '订单管理', 'subtitle': '管理取货订单'},
          {'icon': Icons.qr_code_scanner, 'title': '取货核验', 'subtitle': '扫描核验'},
          {'icon': Icons.inventory_2, 'title': '暂存管理', 'subtitle': '查看暂存货物'},
        ];
        break;
      default:
        menuItems = [];
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ...menuItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Column(
              children: [
                ListTile(
                  leading: Icon(item['icon'], color: AppTheme.primaryColor),
                  title: Text(item['title']),
                  subtitle: Text(item['subtitle'], style: const TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${item['title']}功能开发中...')),
                    );
                  },
                ),
                if (index < menuItems.length - 1)
                  const Divider(height: 1, indent: 56),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWalletSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, Color(0xFF4CAF50)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '我的钱包',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '¥ 0.00',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '推广佣金: ¥0.00',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.primaryColor,
                ),
                child: const Text('充值'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                ),
                child: const Text('提现'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('帮助中心'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('关于我们'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('退出登录', style: TextStyle(color: Colors.red)),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('退出登录'),
                  content: const Text('确定要退出登录吗？'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('取消'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<UserProvider>().logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('确定'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
