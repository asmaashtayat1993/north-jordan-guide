class NotificationModel {
  final String id;
  final String title;
  final String description;
  final String type; // الأنواع: 'event', 'offer', 'recommendation', 'weather'
  final DateTime createdAt;
   bool isRead;
  final String? actionText;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.createdAt,
    required this.isRead,
    this.actionText,
  });

  // دالة لتحويل البيانات القادمة من فايرستور
  factory NotificationModel.fromMap(Map<String, dynamic> map, String documentId) {
    return NotificationModel(
      id: documentId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: map['type'] ?? 'alert',
      createdAt: map['createdAt'] != null 
          ? map['createdAt'].toDate() 
          : DateTime.now(),
      isRead: map['isRead'] ?? false,
      actionText: map['actionText'],
    );
  }
}