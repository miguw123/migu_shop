import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../providers/video_provider.dart';
import '../../models/video.dart';
import '../../config/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<VideoProvider>(
        builder: (context, videoProvider, child) {
          if (videoProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            );
          }

          if (videoProvider.videos.isEmpty) {
            return const Center(
              child: Text('暂无视频'),
            );
          }

          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: videoProvider.videos.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                  videoProvider.setCurrentIndex(index);
                },
                itemBuilder: (context, index) {
                  final video = videoProvider.videos[index];
                  return VideoPlayerWidget(
                    video: video,
                    isCurrentPage: index == _currentIndex,
                  );
                },
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '农短视频',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                right: 20,
                child: IconButton(
                  icon: Icon(
                    videoProvider.isMuted ? Icons.volume_off : Icons.volume_up,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    videoProvider.toggleMute();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final Video video;
  final bool isCurrentPage;

  const VideoPlayerWidget({
    super.key,
    required this.video,
    required this.isCurrentPage,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _showPlayButton = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.video.videoUrl),
    );

    try {
      await _controller!.initialize();
      _controller!.setLooping(true);

      if (widget.isCurrentPage) {
        _controller!.play();
      }

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('视频初始化失败: $e');
    }
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isCurrentPage && !oldWidget.isCurrentPage) {
      if (_controller != null && _isInitialized) {
        _controller!.play();
      }
    } else if (!widget.isCurrentPage && oldWidget.isCurrentPage) {
      if (_controller != null) {
        _controller!.pause();
      }
    }

    if (widget.video.id != oldWidget.video.id && _isInitialized) {
      _controller!.dispose();
      _isInitialized = false;
      _initializeVideo();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller == null) return;

    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        _showPlayButton = true;
      } else {
        _controller!.play();
        _showPlayButton = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_isInitialized && _controller != null)
            Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
            )
          else
            Center(
              child: Image.network(
                widget.video.coverUrl,
                fit: BoxFit.cover,
              ),
            ),

          if (_showPlayButton || !_isInitialized)
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isInitialized ? Icons.play_arrow : Icons.hourglass_empty,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),

          Positioned(
            bottom: 100,
            left: 20,
            right: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(widget.video.authorAvatar),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.video.authorName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 4,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.video.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              shadows: [
                                Shadow(
                                  blurRadius: 4,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  widget.video.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          Positioned(
            right: 15,
            bottom: 100,
            child: Column(
              children: [
                _ActionButton(
                  icon: widget.video.isLiked
                      ? Icons.favorite
                      : Icons.favorite_border,
                  label: _formatCount(widget.video.likes),
                  color: widget.video.isLiked ? Colors.red : Colors.white,
                  onTap: () {
                    context.read<VideoProvider>().likeVideo(widget.video.id);
                  },
                ),
                const SizedBox(height: 20),
                _ActionButton(
                  icon: Icons.comment,
                  label: _formatCount(widget.video.comments),
                  onTap: () {
                    _showComments(context);
                  },
                ),
                const SizedBox(height: 20),
                _ActionButton(
                  icon: widget.video.isFavorite
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  label: '收藏',
                  color: widget.video.isFavorite ? Colors.amber : Colors.white,
                  onTap: () {
                    context.read<VideoProvider>().favoriteVideo(widget.video.id);
                  },
                ),
                const SizedBox(height: 20),
                _ActionButton(
                  icon: Icons.share,
                  label: _formatCount(widget.video.shares),
                  onTap: () {
                    context.read<VideoProvider>().shareVideo(widget.video.id);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}万';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }

  void _showComments(BuildContext context) {
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
                    '评论',
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
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://picsum.photos/50?random=$index',
                    ),
                  ),
                  title: Text('用户$index'),
                  subtitle: Text('这是评论内容$index'),
                  trailing: Text(
                    '${index}h前',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                top: 10,
                bottom: MediaQuery.of(context).padding.bottom + 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: '写下你的评论...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const Icon(Icons.send, color: AppTheme.primaryColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.color = Colors.white,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 35),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              shadows: const [
                Shadow(
                  blurRadius: 4,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
