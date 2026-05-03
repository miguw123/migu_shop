import 'dart:math';
import '../models/enums.dart';
import '../models/video.dart';
import '../models/product.dart';

class AlgorithmHelper {
  static double calculateVideoRecommendationScore(Video video, Map<String, dynamic> userBehavior) {
    double contentQualityScore = _calculateContentQuality(video);
    double interactionScore = _calculateInteractionScore(video);
    double creditScore = video.authorCreditScore / 100.0;
    double timeScore = _calculateTimeScore(video);

    double finalScore = contentQualityScore * 0.30 +
        interactionScore * 0.40 +
        creditScore * 0.20 +
        timeScore * 0.10;

    if (video.authorCreditScore >= 95) {
      finalScore *= 1.2;
    }

    return finalScore;
  }

  static double _calculateContentQuality(Video video) {
    double baseScore = 0.5;

    if (video.description.length > 50) {
      baseScore += 0.1;
    }

    if (video.location != null) {
      baseScore += 0.1;
    }

    if (video.goodsLink != null || video.purchaseParams != null) {
      baseScore += 0.1;
    }

    if (video.audioBackground != null) {
      baseScore += 0.1;
    }

    return baseScore.clamp(0.0, 1.0);
  }

  static double _calculateInteractionScore(Video video) {
    if (video.likes + video.comments + video.shares == 0) return 0.0;

    double likeScore = min(video.likes / 1000, 1.0) * 0.4;
    double commentScore = min(video.comments / 500, 1.0) * 0.4;
    double shareScore = min(video.shares / 200, 1.0) * 0.2;

    return (likeScore + commentScore + shareScore).clamp(0.0, 1.0);
  }

  static double _calculateTimeScore(Video video) {
    Duration age = DateTime.now().difference(video.createdAt);

    if (age.inHours < 1) return 1.0;
    if (age.inHours < 6) return 0.9;
    if (age.inHours < 24) return 0.7;
    if (age.inDays < 3) return 0.5;
    if (age.inDays < 7) return 0.3;

    return 0.1;
  }

  static int calculateMatchingScore(Product product, Map<String, dynamic> searchParams) {
    double totalScore = 0.0;
    int matchCount = 0;

    if (searchParams.containsKey('category')) {
      if (product.category == searchParams['category']) {
        totalScore += 25;
      }
      matchCount += 25;
    }

    if (searchParams.containsKey('minPrice') && searchParams.containsKey('maxPrice')) {
      double price = product.price;
      double minPrice = searchParams['minPrice'];
      double maxPrice = searchParams['maxPrice'];

      if (price >= minPrice && price <= maxPrice) {
        totalScore += 20;
      }
      matchCount += 20;
    }

    if (searchParams.containsKey('location')) {
      if (product.location != null && product.location.toString() == searchParams['location'].toString()) {
        totalScore += 15;
      }
      matchCount += 15;
    }

    if (searchParams.containsKey('quantity')) {
      if (product.quantity >= searchParams['quantity']) {
        totalScore += 15;
      }
      matchCount += 15;
    }

    if (searchParams.containsKey('keyword')) {
      String keyword = searchParams['keyword'].toString().toLowerCase();
      if (product.title.toLowerCase().contains(keyword) ||
          product.description.toLowerCase().contains(keyword)) {
        totalScore += 25;
      }
      matchCount += 25;
    }

    return totalScore;
  }

  static bool isMatchingThresholdReached(int score) {
    return score >= 80;
  }

  static double calculateSearchRankingScore({
    required double keywordMatchScore,
    required int creditScore,
    required int transactionCount,
    required double好评率,
    required Duration publishTime,
  }) {
    double keywordScore = keywordMatchScore * 0.40;
    double creditScoreValue = (creditScore / 100.0) * 0.30;
    double transactionScore = (min(transactionCount, 100) / 100.0) * 好评率 * 0.20;
    double timeScore = _calculateTimeScoreForSearch(publishTime) * 0.10;

    return keywordScore + creditScoreValue + transactionScore + timeScore;
  }

  static double _calculateTimeScoreForSearch(Duration publishTime) {
    if (publishTime.inHours < 1) return 1.0;
    if (publishTime.inHours < 6) return 0.9;
    if (publishTime.inHours < 24) return 0.7;
    if (publishTime.inDays < 3) return 0.5;
    if (publishTime.inDays < 7) return 0.3;

    return 0.1;
  }

  static bool canUserChat(int userCreditScore) {
    return userCreditScore >= 85;
  }

  static bool canUserPost(int userCreditScore) {
    return userCreditScore >= 85;
  }

  static bool isUserBanned(int userCreditScore) {
    return userCreditScore < 60;
  }

  static bool hasNoOrderLimit(int userCreditScore) {
    return userCreditScore >= 95;
  }

  static double calculateSupplierRate({bool hasPromoter = false}) {
    if (hasPromoter) {
      return 0.90;
    }
    return 0.95;
  }

  static double calculatePlatformFee(double productPrice) {
    return productPrice * 0.05;
  }

  static double calculatePromoterCommission(double productPrice) {
    return productPrice * 0.05;
  }

  static double calculateFreight({
    required double distance,
    required int itemCount,
    required double productPrice,
  }) {
    return distance * 3 / 100 + itemCount * 2 + productPrice * 0.05;
  }

  static double calculateReturnAmount({
    required double distance,
    required double actualFreight,
    required int itemCount,
  }) {
    double returnAmount = distance * 3 / 100 - actualFreight / itemCount;
    return returnAmount > 0 ? returnAmount : 0;
  }

  static String determineUserCityCode(double latitude, double longitude) {
    int latZone = (latitude / 10).floor();
    int lonZone = (longitude / 10).floor();

    return '${latZone}_${lonZone}';
  }

  static bool isSameCity(String cityCode1, String cityCode2) {
    return cityCode1 == cityCode2;
  }

  static bool canInitiateCrossCityChat({
    required String initiatorCityCode,
    required String targetCityCode,
    required String initiatorUserType,
  }) {
    if (isSameCity(initiatorCityCode, targetCityCode)) {
      return true;
    }

    if (initiatorUserType == 'consumer') {
      return true;
    }

    return false;
  }
}
