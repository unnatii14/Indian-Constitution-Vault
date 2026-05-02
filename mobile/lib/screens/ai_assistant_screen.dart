import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ai_provider.dart';

class AiAssistantScreen extends ConsumerStatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  ConsumerState<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends ConsumerState<AiAssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(aiChatProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    // Scroll to bottom whenever messages change
    ref.listen(aiChatProvider, (previous, next) {
      if (next.messages.length != previous?.messages.length) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('AI Legal Assistant', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            onPressed: () => ref.read(aiChatProvider.notifier).clearChat(),
            icon: const Icon(Icons.delete_sweep_rounded),
            tooltip: 'Clear Chat',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chatState.messages.isEmpty
                ? _buildWelcomeState(isDark, colorScheme)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(20),
                    itemCount: chatState.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatState.messages[index];
                      return _buildChatBubble(message, isDark, colorScheme);
                    },
                  ),
          ),
          if (chatState.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          _buildInputArea(chatState.isLoading, isDark, colorScheme),
        ],
      ),
    );
  }

  Widget _buildWelcomeState(bool isDark, ColorScheme colorScheme) {
    // SingleChildScrollView so the keyboard doesn't cause an overflow when
    // the available height shrinks. Keeping it scrollable (not Center) keeps
    // the layout safe on small phones too.
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.smart_toy_rounded, size: 56, color: colorScheme.primary),
          ),
          const SizedBox(height: 20),
          Text(
            'How can I help you today?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Ask me anything about the Indian Constitution, BNS, BNSS, BSA or common Indian laws.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white38 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          _buildQuickQuery('What is Article 21?', colorScheme),
          _buildQuickQuery('What is the punishment for theft?', colorScheme),
          _buildQuickQuery('What is RTI Act?', colorScheme),
          _buildQuickQuery('How to file an FIR?', colorScheme),
        ],
      ),
    );
  }

  Widget _buildQuickQuery(String query, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () => ref.read(aiChatProvider.notifier).sendMessage(query),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.2)),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            minimumSize: const Size(0, 36),
          ),
          child: Text(query, style: const TextStyle(fontSize: 13)),
        ),
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message, bool isDark, ColorScheme colorScheme) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
          color: isUser 
            ? colorScheme.primary 
            : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isUser ? Colors.white : (isDark ? Colors.white : const Color(0xFF1E293B)),
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea(bool isLoading, bool isDark, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: !isLoading,
              decoration: InputDecoration(
                hintText: 'Ask a legal question...',
                filled: true,
                fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (val) {
                ref.read(aiChatProvider.notifier).sendMessage(val);
                _controller.clear();
              },
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: isLoading ? null : () {
                ref.read(aiChatProvider.notifier).sendMessage(_controller.text);
                _controller.clear();
              },
              icon: const Icon(Icons.send_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
