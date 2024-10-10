class NotificationModel {
  final String title;
  final String message;
  final DateTime date;

  NotificationModel({required this.title, required this.message, required this.date});

  String get formattedDate {
    return ' ${date.hour}:${date.minute}  ${date.day}/${date.month}/${date.year}';
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'date': date.toIso8601String(),
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'],
      message: json['message'],
      date: DateTime.parse(json['date']),
    );
  }
}