import 'enums.dart';

class Video {
  final String id;
  final String authorId;
  final String authorName;
  final String authorAvatar;
  final int authorCreditScore;
  final String videoUrl;
  final String coverUrl;
  final String title;
  final String description;
  final int videoTypeIndex;
  final int likes;
  final int comments;
  final int shares;
  final bool isLiked;
  final bool isFavorite;
  final String? location;
  final String? goodsLink;
  final String? purchaseParams;
  final String? audioBackground;
  final bool commentEnabled;
  final bool likeEnabled;
  final bool shareEnabled;
  final int creditScore;
  final DateTime createdAt;

  Video({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.authorCreditScore,
    required this.videoUrl,
    required this.coverUrl,
    required this.title,
    required this.description,
    required this.videoTypeIndex,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.isLiked = false,
    this.isFavorite = false,
    this.location,
    this.goodsLink,
    this.purchaseParams,
    this.audioBackground,
    this.commentEnabled = true,
    this.likeEnabled = true,
    this.shareEnabled = true,
    required this.creditScore,
    required this.createdAt,
  });

  VideoType get videoType => VideoType.values[videoTypeIndex];

  String get videoTypeName {
    switch (videoType) {
      case VideoType.goods:
        return '好物';
      case VideoType.purchase:
        return '求购';
      case VideoType.knowledge:
        return '科普';
      case VideoType.question:
        return '求知';
    }
  }

  double get interactionRate {
    if (likes + comments + shares == 0) return 0;
    return (likes + comments * 2 + shares * 3) / 1000;
  }

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      authorAvatar: json['authorAvatar'] as String,
      authorCreditScore: json['authorCreditScore'] as int? ?? 100,
      videoUrl: json['videoUrl'] as String,
      coverUrl: json['coverUrl'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      videoTypeIndex: json['videoTypeIndex'] as int,
      likes: json['likes'] as int? ?? 0,
      comments: json['comments'] as int? ?? 0,
      shares: json['shares'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
      location: json['location'] as String?,
      goodsLink: json['goodsLink'] as String?,
      purchaseParams: json['purchaseParams'] as String?,
      audioBackground: json['audioBackground'] as String?,
      commentEnabled: json['commentEnabled'] as bool? ?? true,
      likeEnabled: json['likeEnabled'] as bool? ?? true,
      shareEnabled: json['shareEnabled'] as bool? ?? true,
      creditScore: json['creditScore'] as int? ?? 100,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'authorCreditScore': authorCreditScore,
      'videoUrl': videoUrl,
      'coverUrl': coverUrl,
      'title': title,
      'description': description,
      'videoTypeIndex': videoTypeIndex,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'isLiked': isLiked,
      'isFavorite': isFavorite,
      'location': location,
      'goodsLink': goodsLink,
      'purchaseParams': purchaseParams,
      'audioBackground': audioBackground,
      'commentEnabled': commentEnabled,
      'likeEnabled': likeEnabled,
      'shareEnabled': shareEnabled,
      'creditScore': creditScore,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Video copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorAvatar,
    int? authorCreditScore,
    String? videoUrl,
    String? coverUrl,
    String? title,
    String? description,
    int? videoTypeIndex,
    int? likes,
    int? comments,
    int? shares,
    bool? isLiked,
    bool? isFavorite,
    String? location,
    String? goodsLink,
    String? purchaseParams,
    String? audioBackground,
    bool? commentEnabled,
    bool? likeEnabled,
    bool? shareEnabled,
    int? creditScore,
    DateTime? createdAt,
  }) {
    return Video(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      authorCreditScore: authorCreditScore ?? this.authorCreditScore,
      videoUrl: videoUrl ?? this.videoUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      videoTypeIndex: videoTypeIndex ?? this.videoTypeIndex,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      isLiked: isLiked ?? this.isLiked,
      isFavorite: isFavorite ?? this.isFavorite,
      location: location ?? this.location,
      goodsLink: goodsLink ?? this.goodsLink,
      purchaseParams: purchaseParams ?? this.purchaseParams,
      audioBackground: audioBackground ?? this.audioBackground,
      commentEnabled: commentEnabled ?? this.commentEnabled,
      likeEnabled: likeEnabled ?? this.likeEnabled,
      shareEnabled: shareEnabled ?? this.shareEnabled,
      creditScore: creditScore ?? this.creditScore,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
