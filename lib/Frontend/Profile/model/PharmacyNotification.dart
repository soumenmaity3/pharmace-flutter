
class PharmacyNotification {
  final String id;
  final String title;
  final String message;
  final NotificationCategory category;
  final NotificationPriority priority;
  final DateTime timestamp;
  bool isRead;
  final String? actionLabel;
  final Map<String, String>? details;

  PharmacyNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.category,
    required this.priority,
    required this.timestamp,
    this.isRead = false,
    this.actionLabel,
    this.details,
  });
}

enum NotificationCategory {
  all,
  unread,
  inventory,
  expiry,
  sales,
  staff,
  system,
}

enum NotificationPriority {
  critical,
  warning,
  info,
  success,
}