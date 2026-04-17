/// Placeholder tutor replies until a real model/API is wired up.
class ChatTutorService {
  Future<String> replyTo(String userMessage) async {
    final trimmed = userMessage.trim();
    await Future<void>.delayed(const Duration(milliseconds: 1800));
    if (trimmed.isEmpty) {
      return 'আমি সাহায্য করতে পারি। একটু লিখে পাঠান।';
    }
    return 'ধন্যবাদ। আপনি লিখেছেন: «$trimmed»। '
        '(এটি ডেমো উত্তর — পরে এখানে আসল AI সংযোগ হবে।)';
  }
}
