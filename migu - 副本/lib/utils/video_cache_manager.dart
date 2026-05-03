import 'dart:collection';
import 'package:flutter/foundation.dart';

class VideoCacheManager {
  static final VideoCacheManager _instance = VideoCacheManager._internal();
  factory VideoCacheManager() => _instance;

  final int maxCacheSize = 500 * 1024 * 1024;
  final int maxPreloadCount = 3;

  final LinkedHashMap<String, _CacheEntry> _cache = LinkedHashMap();
  int _currentSize = 0;

  VideoCacheManager._internal();

  void preloadVideo(String videoId, String videoUrl) {
    if (_cache.containsKey(videoId)) {
      _cache[videoId]!.lastAccessed = DateTime.now();
      _moveToEnd(videoId);
      return;
    }

    if (_cache.length >= maxPreloadCount) {
      _evictOldest();
    }

    _cache[videoId] = _CacheEntry(
      videoId: videoId,
      url: videoUrl,
      lastAccessed: DateTime.now(),
    );
  }

  String? getCachedVideoUrl(String videoId) {
    if (_cache.containsKey(videoId)) {
      _cache[videoId]!.lastAccessed = DateTime.now();
      _moveToEnd(videoId);
      return _cache[videoId]!.url;
    }
    return null;
  }

  void clearCache() {
    _cache.clear();
    _currentSize = 0;
  }

  void _moveToEnd(String videoId) {
    final entry = _cache.remove(videoId);
    if (entry != null) {
      _cache[videoId] = entry;
    }
  }

  void _evictOldest() {
    if (_cache.isEmpty) return;

    final oldestKey = _cache.keys.first;
    final entry = _cache.remove(oldestKey);
    if (entry != null) {
      _currentSize -= entry.size;
    }
  }

  void onVideoPlayed(String videoId, int sizeInBytes) {
    if (_cache.containsKey(videoId)) {
      _currentSize += sizeInBytes;
      _cache[videoId]!.size = sizeInBytes;

      while (_currentSize > maxCacheSize && _cache.length > 1) {
        _evictOldest();
      }
    }
  }
}

class _CacheEntry {
  final String videoId;
  final String url;
  DateTime lastAccessed;
  int size;

  _CacheEntry({
    required this.videoId,
    required this.url,
    required this.lastAccessed,
    this.size = 0,
  });
}
