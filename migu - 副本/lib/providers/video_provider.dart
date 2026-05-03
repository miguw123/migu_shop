import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/video.dart';

class VideoProvider with ChangeNotifier {
  List<Video> _videos = [];
  int _currentIndex = 0;
  bool _isLoading = false;
  bool _isMuted = false;

  List<Video> get videos => _videos;
  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;
  bool get isMuted => _isMuted;

  Video? get currentVideo =>
      _videos.isNotEmpty && _currentIndex < _videos.length
          ? _videos[_currentIndex]
          : null;

  VideoProvider() {
    _loadMockVideos();
  }

  Future<void> _loadMockVideos() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _videos = List.generate(10, (index) {
      return Video(
        id: const Uuid().v4(),
        authorId: const Uuid().v4(),
        authorName: '农户${index + 1}',
        authorAvatar: 'https://picsum.photos/100?random=$index',
        videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        coverUrl: 'https://picsum.photos/400/600?random=$index',
        title: '农村生活记录${index + 1}',
        description: '分享我们农村的日常生活，种植收获的喜悦',
        likes: 1000 + index * 100,
        comments: 100 + index * 10,
        shares: 50 + index * 5,
        createdAt: DateTime.now().subtract(Duration(hours: index)),
      );
    });

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshVideos() async {
    await _loadMockVideos();
  }

  void setCurrentIndex(int index) {
    if (index >= 0 && index < _videos.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    notifyListeners();
  }

  Future<void> likeVideo(String videoId) async {
    final index = _videos.indexWhere((v) => v.id == videoId);
    if (index != -1) {
      final video = _videos[index];
      _videos[index] = video.copyWith(
        isLiked: !video.isLiked,
        likes: video.isLiked ? video.likes - 1 : video.likes + 1,
      );
      notifyListeners();
    }
  }

  Future<void> favoriteVideo(String videoId) async {
    final index = _videos.indexWhere((v) => v.id == videoId);
    if (index != -1) {
      final video = _videos[index];
      _videos[index] = video.copyWith(isFavorite: !video.isFavorite);
      notifyListeners();
    }
  }

  Future<void> shareVideo(String videoId) async {
    final index = _videos.indexWhere((v) => v.id == videoId);
    if (index != -1) {
      final video = _videos[index];
      _videos[index] = video.copyWith(shares: video.shares + 1);
      notifyListeners();
    }
  }

  Video? getVideoById(String id) {
    try {
      return _videos.firstWhere((v) => v.id == id);
    } catch (e) {
      return null;
    }
  }
}
