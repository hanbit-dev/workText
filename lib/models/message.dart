class Message {
  final String receiver;
  final String content;

  Message({
    required this.receiver,
    required this.content,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      receiver: json['receiver'],
      content: json['content'],
    );
  }

  @override
  String toString() {
    return 'Message(receiver: $receiver, content: $content)';
  }
}
