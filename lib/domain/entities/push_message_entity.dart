class PushMessageEntity {
  final String? messageId;
  final String title;
  final String body;
  final DateTime sendDate;
  final Map<String, dynamic>? data;
  final String? imageUrl;

  PushMessageEntity({
    required this.messageId,
    required this.title,
    required this.body,
    required this.sendDate,
    this.data,
    this.imageUrl,
  });

  @override
  String toString() =>
      '''
      PushMessageEntity - 
      messageId: $messageId, 
      title: $title, 
      body: $body, 
      sendDate: $sendDate, 
      data: $data, 
      imageUrl: $imageUrl
      ''';
}
