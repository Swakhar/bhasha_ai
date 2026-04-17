enum ChatMessageSender { user, tutor }

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
  });

  final String id;
  final String text;
  final ChatMessageSender sender;
}
