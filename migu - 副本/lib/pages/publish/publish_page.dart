import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../providers/product_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/product.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';

class PublishPage extends StatefulWidget {
  const PublishPage({super.key});

  @override
  State<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();

  String _selectedCategory = '粮食作物';
  String _selectedUnit = '斤';
  final List<XFile> _selectedImages = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    if (_selectedImages.length >= AppConstants.maxImagesPerPost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('最多只能选择9张图片')),
      );
      return;
    }

    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isNotEmpty) {
      final remaining = AppConstants.maxImagesPerPost - _selectedImages.length;
      setState(() {
        _selectedImages.addAll(images.take(remaining));
      });
    }
  }

  Future<void> _takePhoto() async {
    if (_selectedImages.length >= AppConstants.maxImagesPerPost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('最多只能选择9张图片')),
      );
      return;
    }

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _selectedImages.add(image);
      });
    }
  }

  Future<void> _submitProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请至少选择一张图片')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final user = context.read<UserProvider>().currentUser;
      if (user == null) {
        throw Exception('用户未登录');
      }

      final product = Product(
        id: const Uuid().v4(),
        sellerId: user.id,
        sellerName: user.name,
        sellerAvatar: user.avatar,
        title: _titleController.text,
        description: _descriptionController.text,
        category: _selectedCategory,
        price: double.parse(_priceController.text),
        unit: _selectedUnit,
        quantity: double.parse(_quantityController.text),
        images: _selectedImages.map((e) => e.path).toList(),
        latitude: user.latitude,
        longitude: user.longitude,
        address: '北京市',
        status: 0,
        createdAt: DateTime.now(),
      );

      await context.read<ProductProvider>().addProduct(product);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('发布成功！'),
            backgroundColor: AppTheme.successColor,
          ),
        );

        _resetForm();

        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('发布失败: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _resetForm() {
    _titleController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _quantityController.clear();
    setState(() {
      _selectedCategory = '粮食作物';
      _selectedUnit = '斤';
      _selectedImages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('发布农产品'),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _submitProduct,
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('发布'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildImageSection(),
            const SizedBox(height: 20),
            _buildCategorySelector(),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _titleController,
              label: '商品标题',
              hint: '请输入商品标题',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入商品标题';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _descriptionController,
              label: '商品描述',
              hint: '请输入商品描述',
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入商品描述';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    controller: _priceController,
                    label: '价格',
                    hint: '0.00',
                    keyboardType: TextInputType.number,
                    suffixText: '元',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入价格';
                      }
                      if (double.tryParse(value) == null) {
                        return '请输入有效价格';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildUnitSelector(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _quantityController,
              label: '数量',
              hint: '请输入数量',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入数量';
                }
                if (double.tryParse(value) == null) {
                  return '请输入有效数量';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildLocationSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '商品图片',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 110,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildAddImageButton(
                icon: Icons.camera_alt,
                onTap: _takePhoto,
                label: '拍照',
              ),
              const SizedBox(width: 10),
              _buildAddImageButton(
                icon: Icons.photo_library,
                onTap: _pickImages,
                label: '相册',
              ),
              const SizedBox(width: 10),
              ..._selectedImages.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          entry.value.path.startsWith('http')
                              ? entry.value.path
                              : 'https://picsum.photos/100/100?random=${entry.key}',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedImages.removeAt(entry.key);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '已选择 ${_selectedImages.length}/${AppConstants.maxImagesPerPost} 张图片',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageButton({
    required IconData icon,
    required VoidCallback onTap,
    required String label,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: AppTheme.primaryColor),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '商品分类',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: AppConstants.productCategories.map((category) {
            final isSelected = _selectedCategory == category;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryColor : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? suffixText,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            suffixText: suffixText,
          ),
        ),
      ],
    );
  }

  Widget _buildUnitSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '单位',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedUnit,
              isExpanded: true,
              items: AppConstants.productUnits.map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedUnit = value;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.location_on,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '当前位置',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userProvider.currentUser?.latitude != null
                          ? '北京市昌平区'
                          : '正在获取位置...',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('位置功能开发中')),
                  );
                },
                child: const Text('重新定位'),
              ),
            ],
          ),
        );
      },
    );
  }
}
