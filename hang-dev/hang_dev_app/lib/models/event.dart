class Event {
  final String eventImageUrl;
  final int? announcementId;
  final int eventId;

  Event({
    required this.eventImageUrl,
    required this.announcementId,
    required this.eventId,
  });
  factory Event.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "event_image_url": var eventImageUrl,
        "announcement_id": var announcementId,
        "event_id": var eventId,
      } =>
        Event(
          eventImageUrl: eventImageUrl,
          announcementId: announcementId,
          eventId: eventId,
        ),
      _ => throw const FormatException('Failed to load Pixel')
    };
  }
  static List<Event> listFromJson(List<dynamic> jsonList) {
    return [
      for (var element in jsonList) Event.fromJson(element),
    ];
  }
}
