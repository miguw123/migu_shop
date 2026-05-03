import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/video_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/video.dart';
import '../../models/enums.dart';
import '../../config/theme.dart';
import '../../widgets/video_player_widget.dart';
import '../../widgets/common/loading.dart';

class VideoHomePage extends StatefulWidget {
  const VideoHomePage({super.key});

  @override
  State<VideoHomePage> createState() => _VideoHomePageState();
}

class _VideoHomePageState extends State<VideoHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentVideoIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildTopBar(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildVideoList(VideoType.question),
                _buildVideoList(VideoType.knowledge),
                _buildVideoList(VideoType.goods),
                _buildVideoList(VideoType.purchase),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 20,
        right: 10,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              '农短视频',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          _buildRoleSwitchButton(),
        ],
      ),
    );
  }

  Widget _buildRoleSwitchButton() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return PopupMenuButton<String>(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.swap_horiz, size: 20),
                const SizedBox(width: 4),
                Text(
                  userProvider.currentUser?.userTypeName ?? '切换角色',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          onSelected: (value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('切换为: $value')),
            );
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: '消费者', child: Text('消费者')),
            const PopupMenuItem(value: '货主', child: Text('货主')),
            const PopupMenuItem(value: '货运接单', child: Text('货运接单')),
            const PopupMenuItem(value: '村仓', child: Text('村仓')),
          ],
        );
      },
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorColor: AppTheme.primaryColor,
        indicatorWeight: 3,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: '求知'),
          Tab(text: '科普'),
          Tab(text: '好物'),
          Tab(text: '求购'),
        ],
      ),
    );
  }

  Widget _buildVideoList(VideoType videoType) {
    return Consumer<VideoProvider>(
      builder: (context, videoProvider, child) {
        if (videoProvider.isLoading) {
          return const LoadingWidget(message: '加载中...');
        }

        final filteredVideos = videoProvider.videos
            .where((v) => v.videoType == videoType)
            .toList();

        if (filteredVideos.isEmpty) {
          return _buildEmptyState(videoType);
        }

        return PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: filteredVideos.length,
          onPageChanged: (index) {
            setState(() {
              _currentVideoIndex = index;
            });
            videoProvider.setCurrentIndex(index);
          },
          itemBuilder: (context, index) {
            return VideoPlayerWidget(
              video: filteredVideos[index],
              isCurrentPage: index == _currentVideoIndex,
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(VideoType videoType) {
    String typeName;
    IconData icon;

    switch (videoType) {
      case VideoType.question:
        typeName = '求知';
        icon = Icons.help_outline;
        break;
      case VideoType.knowledge:
        typeName = '科普';
        icon = Icons.school_outlined;
        break;
      case VideoType.goods:
        typeName = '好物';
        icon = Icons.shopping_bag_outlined;
        break;
      case VideoType.purchase:
        typeName = '求购';
        icon = Icons.search_outlined;
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            '暂无${typeName}视频',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 16),
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              final user = userProvider.currentUser;
              final canPost = user != null && user.canPost;

              return ElevatedButton.icon(
                onPressed: canPost
                    ? () {
                        _showPublishDialog(videoType);
                      }
                    : null,
                icon: const Icon(Icons.add),
                label: Text('发布${typeName}视频'),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showPublishDialog(VideoType videoType) {
    String typeName;
    switch (videoType) {
      case VideoType.question:
        typeName = '求知';
        break;
      case VideoType.knowledge:
        typeName = '科普';
        break;
      case VideoType.goods:
        typeName = '好物';
        break;
      case VideoType.purchase:
        typeName = '求购';
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('发布${typeName}视频功能开发中...')),
    );
  }
}
