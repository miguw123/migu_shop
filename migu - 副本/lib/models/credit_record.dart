class CreditRecord {
  final String id;
  final String userId;
  final int changeAmount;
  final String reason;
  final String? relatedOrderId;
  final int userCreditScoreAfter;
  final DateTime createdAt;

  CreditRecord({
    required this.id,
    required this.userId,
    required this.changeAmount,
    required this.reason,
    this.relatedOrderId,
    required this.userCreditScoreAfter,
    required this.createdAt,
  });

  bool get isPositive => changeAmount > 0;

  factory CreditRecord.fromJson(Map<String, dynamic> json) {
    return CreditRecord(
      id: json['id'] as String,
      userId: json['userId'] as String,
      changeAmount: json['changeAmount'] as int,
      reason: json['reason'] as String,
      relatedOrderId: json['relatedOrderId'] as String?,
      userCreditScoreAfter: json['userCreditScoreAfter'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'changeAmount': changeAmount,
      'reason': reason,
      'relatedOrderId': relatedOrderId,
      'userCreditScoreAfter': userCreditScoreAfter,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class CreditRule {
  final String reason;
  final int changeAmount;
  final String description;

  const CreditRule({
    required this.reason,
    required this.changeAmount,
    required this.description,
  });

  static const List<CreditRule> deductionRules = [
    CreditRule(
      reason: 'valid_complaint',
      changeAmount: -5,
      description: '被用户有效投诉',
    ),
    CreditRule(
      reason: 'quality_fraud',
      changeAmount: -15,
      description: '商品质量造假',
    ),
    CreditRule(
      reason: 'violation_content',
      changeAmount: -8,
      description: '发布违规内容或虚假信息',
    ),
    CreditRule(
      reason: 'freight_no_show',
      changeAmount: -15,
      description: '货运爽约或货物损坏',
    ),
    CreditRule(
      reason: 'warehouse_violation',
      changeAmount: -12,
      description: '村仓违规操作',
    ),
    CreditRule(
      reason: 'malicious_harassment',
      changeAmount: -6,
      description: '恶意骚扰',
    ),
    CreditRule(
      reason: 'order_overdue',
      changeAmount: -7,
      description: '逾期不处理订单',
    ),
  ];

  static const List<CreditRule> additionRules = [
    CreditRule(
      reason: 'complete_3_orders',
      changeAmount: 2,
      description: '完成3笔无纠纷订单',
    ),
    CreditRule(
      reason: 'quality_video',
      changeAmount: 1,
      description: '发布优质视频获高赞（单日最多+3分）',
    ),
    CreditRule(
      reason: '30_days_compliance',
      changeAmount: 5,
      description: '连续30天无违规无投诉',
    ),
  ];
}
