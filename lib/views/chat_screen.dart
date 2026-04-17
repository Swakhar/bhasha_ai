import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../services/chat_tutor_service.dart';
import '../theme/app_palette.dart';
import '../widgets/message_bubble.dart';
import '../widgets/tutor_reply_shimmer.dart';

/// Premium messaging-style learning chat (user vs AI tutor).
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _scroll = ScrollController();
  final _input = TextEditingController();
  final _tutor = ChatTutorService();
  final _messages = <ChatMessage>[];
  var _awaitingTutor = false;
  var _nextId = 0;

  @override
  void dispose() {
    _scroll.dispose();
    _input.dispose();
    super.dispose();
  }

  String _newId() {
    _nextId += 1;
    return 'm$_nextId';
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty || _awaitingTutor) return;

    setState(() {
      _messages.add(
        ChatMessage(id: _newId(), text: text, sender: ChatMessageSender.user),
      );
      _input.clear();
      _awaitingTutor = true;
    });
    _scrollToBottom();

    try {
      final reply = await _tutor.replyTo(text);
      if (!mounted) return;
      setState(() {
        _messages.add(
          ChatMessage(
            id: _newId(),
            text: reply,
            sender: ChatMessageSender.tutor,
          ),
        );
        _awaitingTutor = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          ChatMessage(
            id: _newId(),
            text: 'কিছু একটা সমস্যা হয়েছে। আবার চেষ্টা করুন।',
            sender: ChatMessageSender.tutor,
          ),
        );
        _awaitingTutor = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _onMic() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('ভয়েস ইনপুট শীঘ্রই যোগ করা হবে।'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppPalette.text,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'শেখার জায়গা',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            Text(
              'AI শিক্ষক • বাংলায় চর্চা',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppPalette.mutedText,
                  ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppPalette.surface,
              AppPalette.indigo.withValues(alpha: 0.06),
              AppPalette.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: _messages.length + (_awaitingTutor ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_awaitingTutor && index == _messages.length) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 14),
                        child: TutorReplyShimmer(),
                      );
                    }
                    final m = _messages[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: MessageBubble(
                        text: m.text,
                        sender: m.sender,
                      ),
                    );
                  },
                ),
              ),
              _ChatComposer(
                controller: _input,
                enabled: !_awaitingTutor,
                onSend: _send,
                onMic: _onMic,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatComposer extends StatelessWidget {
  const _ChatComposer({
    required this.controller,
    required this.enabled,
    required this.onSend,
    required this.onMic,
  });

  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onSend;
  final VoidCallback onMic;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          12,
          8,
          12,
          8 + MediaQuery.paddingOf(context).bottom * 0.0,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppPalette.card.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: AppPalette.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'মাইক্রোফোন',
                    onPressed: enabled ? onMic : null,
                    icon: Icon(
                      Icons.mic_none_rounded,
                      color: enabled
                          ? AppPalette.indigo
                          : AppPalette.mutedText,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      enabled: enabled,
                      minLines: 1,
                      maxLines: 5,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => onSend(),
                      decoration: InputDecoration(
                        hintText: 'বাংলায় লিখুন…',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                        hintStyle: theme.textTheme.bodyLarge?.copyWith(
                          color: AppPalette.mutedText,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  IconButton.filled(
                    tooltip: 'পাঠান',
                    onPressed: enabled ? onSend : null,
                    style: IconButton.styleFrom(
                      backgroundColor: AppPalette.indigo,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          AppPalette.border.withValues(alpha: 0.6),
                    ),
                    icon: const Icon(Icons.send_rounded, size: 22),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
