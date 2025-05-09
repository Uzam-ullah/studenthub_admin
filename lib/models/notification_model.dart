class AppNotification {
  final String title;
  final String description;
  final String date;
  final String time;
  final DateTime? dateTime;

  AppNotification({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    this.dateTime,
  });
}