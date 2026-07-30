class NotificationModel {
  final String id;
  final String userId;
  final String? type;
  final String? title;
  final String? body;
  final dynamic payload;
  final bool? isRead;
  final DateTime? createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    this.type,
    this.title,
    this.body,
    this.payload,
    this.isRead,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: json['type'] as String?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      payload: json['payload'],
      isRead: json['is_read'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }
}
