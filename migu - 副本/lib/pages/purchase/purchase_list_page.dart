import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/product.dart';
import '../../models/enums.dart';
import '../../config/theme.dart';
import '../../widgets/product_card.dart';
import '../../widgets/common/loading.dart';

class PurchaseListPage extends StatefulWidget {
  const PurchaseListPage({super.key});

  @override
  State<PurchaseListPage> createState() => _PurchaseListPageState();
}

class _PurchaseListPageState extends State<PurchaseListPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('求购'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryNav(),
          Expanded(
            child: _buildProductList(),
          ),
        ],
      ),
      floatingActionButton: _buildPublishButton(),
    );
  }

  Widget _buildCategoryNav() {
    return Container(
      height: 50,
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _buildCategoryChip('全部', null),
          ...AppConstants.productCategories.map((category) {
            return _buildCategoryChip(category, category);
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String? category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = selected ? category : null;
          });
          context.read<ProductProvider>().setCategory(category);
        },
        selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
        checkmarkColor: AppTheme.primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.primaryColor : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.isLoading) {
          return const LoadingWidget(message: '加载中...');
        }

        final products = _selectedCategory == null
            ? productProvider.products
            : productProvider.products
                .where((p) => p.category == _selectedCategory)
                .toList();

        if (products.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          color: AppTheme.primaryColor,
          onRefresh: () async {
            await productProvider.refreshProducts();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onTap: () {
                  _showProductDetail(product);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            '暂无相关商品',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublishButton() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.currentUser;
        final canPost = user != null && user.canPost;

        return FloatingActionButton(
          onPressed: canPost
              ? () {
                  _showPublishOptions();
                }
              : () {
                  _showCreditScoreWarning();
                },
          backgroundColor: AppTheme.primaryColor,
          child: const Icon(Icons.add, color: Colors.white),
        );
      },
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('搜索'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: '搜索商品...',
            prefixIcon: Icon(Icons.search),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('搜索: ${_searchController.text}')),
              );
            },
            child: const Text('搜索'),
          ),
        ],
      ),
    );
  }

  void _showPublishOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '发布信息',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.shopping_bag, color: AppTheme.primaryColor),
              title: const Text('发布供货信息'),
              subtitle: const Text('我是供货商，我要卖货'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('供货发布功能开发中...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.search, color: AppTheme.accentColor),
              title: const Text('发布求购信息'),
              subtitle: const Text('我是采购商，我要买货'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('求购发布功能开发中...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCreditScoreWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('信用分低于85分，无法发布信息。请保持良好信用！'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showProductDetail(Product product) {
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
                    '商品详情',
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
                      product.images.isNotEmpty
                          ? product.images.first
                          : 'https://picsum.photos/400/300',
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        '¥${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      Text(
                        '/${product.unit}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('分类', product.category),
                  _buildInfoRow('库存', '${product.quantity.toStringAsFixed(0)}${product.unit}'),
                  _buildInfoRow('发货地', product.address ?? '未设置'),
                  const SizedBox(height: 20),
                  const Text(
                    '商品描述',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSellerInfo(product),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('咨询功能开发中...')),
                            );
                          },
                          icon: const Icon(Icons.message),
                          label: const Text('咨询'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('立即下单功能开发中...')),
                            );
                          },
                          icon: const Icon(Icons.shopping_cart),
                          label: const Text('立即下单'),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
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
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerInfo(Product product) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(product.sellerAvatar),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.sellerName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber[700], size: 16),
                    const SizedBox(width: 4),
                    const Text('5.0', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 12),
                    Text(
                      '已售 100+',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
