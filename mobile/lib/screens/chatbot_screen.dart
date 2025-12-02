import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/api_service.dart';
import '../providers/act_providers.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? language;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.language,
  });
}

class ChatbotScreen extends ConsumerStatefulWidget {
  const ChatbotScreen({super.key});

  @override
  ConsumerState<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends ConsumerState<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _showDisclaimer = true;

  // Voice features
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  bool _isSpeaking = false;
  String _recognizedText = '';
  String _selectedLanguage = 'english'; // 'english' or 'hindi'

  @override
  void initState() {
    super.initState();
    _initializeVoiceFeatures();
    // Add welcome message
    _messages.add(
      ChatMessage(
        text:
            "Hello! I'm your Legal Rights Assistant. I can help you understand Indian laws in simple language.\n\nRemember:\n• I provide educational information only\n• Not personalized legal advice\n• Consult a lawyer for legal action\n\nHow can I help you today?",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  Future<void> _initializeVoiceFeatures() async {
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();

    // Configure TTS
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setStartHandler(() {
      setState(() {
        _isSpeaking = true;
      });
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() {
        _isSpeaking = false;
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

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

  Future<void> _startListening() async {
    // Request microphone permission
    var status = await Permission.microphone.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Microphone permission is required for voice input'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() => _isListening = false);
        }
      },
      onError: (error) {
        setState(() => _isListening = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${error.errorMsg}'),
            backgroundColor: Colors.red,
          ),
        );
      },
    );

    if (available) {
      setState(() {
        _isListening = true;
        _recognizedText = '';
      });

      _speech.listen(
        onResult: (result) {
          setState(() {
            _recognizedText = result.recognizedWords;
            _messageController.text = _recognizedText;
          });
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        cancelOnError: true,
        listenMode: stt.ListenMode.confirmation,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Speech recognition not available'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  bool _containsHindi(String text) {
    // Check if text contains Devanagari script (Hindi)
    final hindiPattern = RegExp(r'[\u0900-\u097F]');
    return hindiPattern.hasMatch(text);
  }

  Future<void> _speak(String text, {String? language}) async {
    await _flutterTts.stop();

    // Detect language if not provided
    final isHindi =
        language == 'hindi' || language == 'hi' || _containsHindi(text);

    // Set appropriate language for TTS
    if (isHindi) {
      await _flutterTts.setLanguage('hi-IN'); // Hindi
      await _flutterTts.setSpeechRate(0.4); // Slower for Hindi
    } else {
      await _flutterTts.setLanguage('en-US'); // English
      await _flutterTts.setSpeechRate(0.5);
    }

    await _flutterTts.speak(text);
  }

  Future<void> _stopSpeaking() async {
    await _flutterTts.stop();
    setState(() => _isSpeaking = false);
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add(
        ChatMessage(text: message, isUser: true, timestamp: DateTime.now()),
      );
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      // Check for prohibited questions
      if (_isProhibitedQuestion(message)) {
        setState(() {
          _messages.add(
            ChatMessage(
              text:
                  "I'm here to provide educational information about laws and legal concepts. However, I cannot:\n\n• Provide specific legal solutions or advice\n• Tell you what action to take in your case\n• Draft legal documents or FIRs\n• Store personal legal details\n\nPlease consult a qualified lawyer for personalized legal advice. I can help explain legal concepts, sections, and your rights in general terms.",
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
          _isLoading = false;
        });
        _scrollToBottom();
        return;
      }

      final apiService = ref.read(apiServiceProvider);
      final response = await apiService.chatWithAI(
        question: message,
        language: _selectedLanguage,
      );

      final formattedResponse = _formatSafeResponse(response);

      setState(() {
        _messages.add(
          ChatMessage(
            text: formattedResponse,
            isUser: false,
            timestamp: DateTime.now(),
            language: _selectedLanguage,
          ),
        );
        _isLoading = false;
      });
      _scrollToBottom();

      // Automatically speak the response in correct language
      await _speak(formattedResponse, language: _selectedLanguage);
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(
            text:
                "I'm sorry, I encountered an error. Please try again or rephrase your question.",
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  bool _isProhibitedQuestion(String message) {
    final lowerMessage = message.toLowerCase();

    // Prohibited patterns
    final prohibited = [
      'what should i do',
      'should i file',
      'help me file',
      'draft',
      'write complaint',
      'write fir',
      'my case',
      'my situation',
      'my problem',
      'take action',
      'sue',
      'politician',
      'political party',
      'government is',
      'minister',
      'pm ',
      'chief minister',
    ];

    return prohibited.any((pattern) => lowerMessage.contains(pattern));
  }

  String _formatSafeResponse(String response) {
    // Add educational disclaimer if not present
    if (!response.contains('consult') &&
        !response.contains('lawyer') &&
        response.length > 100) {
      return "$response\n\n💡 Note: This is educational information. Consult a lawyer for personalized advice.";
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Legal Assistant'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Language selector
          PopupMenuButton<String>(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.language, color: Colors.white, size: 20),
                const SizedBox(width: 4),
                Text(
                  _selectedLanguage == 'hindi' ? 'हिं' : 'EN',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            onSelected: (String value) {
              setState(() {
                _selectedLanguage = value;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    value == 'hindi'
                        ? 'भाषा हिंदी में बदल दी गई'
                        : 'Language changed to English',
                  ),
                  duration: const Duration(seconds: 2),
                  backgroundColor: Colors.green.shade600,
                ),
              );
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'english',
                child: Row(
                  children: [
                    Icon(
                      Icons.check,
                      size: 18,
                      color: _selectedLanguage == 'english'
                          ? Colors.green.shade600
                          : Colors.transparent,
                    ),
                    const SizedBox(width: 8),
                    const Text('English'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'hindi',
                child: Row(
                  children: [
                    Icon(
                      Icons.check,
                      size: 18,
                      color: _selectedLanguage == 'hindi'
                          ? Colors.green.shade600
                          : Colors.transparent,
                    ),
                    const SizedBox(width: 8),
                    const Text('हिंदी (Hindi)'),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showGuidelinesDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Ethical Guidelines Banner
          if (_showDisclaimer)
            Container(
              width: double.infinity,
              color: Colors.orange.shade100,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.shield_outlined,
                    color: Colors.orange.shade800,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Educational only • Not legal advice • Consult lawyer',
                      style: TextStyle(
                        color: Colors.orange.shade900,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.orange.shade800,
                    ),
                    onPressed: () => setState(() => _showDisclaimer = false),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoading) {
                  return _LoadingIndicator();
                }
                return _ChatBubble(message: _messages[index]);
              },
            ),
          ),

          // Input Area
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              child: Row(
                children: [
                  // Voice input button
                  CircleAvatar(
                    backgroundColor: _isListening
                        ? Colors.red.shade600
                        : Colors.green.shade600,
                    radius: 24,
                    child: IconButton(
                      icon: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: _isListening
                          ? _stopListening
                          : _startListening,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: _isListening
                            ? 'Listening...'
                            : 'Ask about laws, rights, sections...',
                        hintStyle: TextStyle(
                          color: _isListening
                              ? Colors.red.shade400
                              : Colors.grey.shade500,
                          fontSize: 15,
                          fontStyle: _isListening
                              ? FontStyle.italic
                              : FontStyle.normal,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: Colors.green.shade600,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    backgroundColor: Colors.green.shade600,
                    radius: 24,
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: _isLoading ? null : _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showGuidelinesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ethical AI Guidelines'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _GuidelineItem(
                icon: Icons.check_circle,
                color: Colors.green,
                title: 'What I CAN do:',
                items: [
                  'Explain legal concepts and sections',
                  'Simplify complex legal language',
                  'Provide general information about rights',
                  'Answer educational questions about laws',
                ],
              ),
              const SizedBox(height: 16),
              _GuidelineItem(
                icon: Icons.cancel,
                color: Colors.red,
                title: 'What I CANNOT do:',
                items: [
                  'Provide personalized legal advice',
                  'Tell you what action to take',
                  'Draft FIRs or legal documents',
                  'Store your personal legal details',
                  'Make political statements or opinions',
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange.shade800,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Always consult a qualified lawyer for personalized legal advice and action.',
                        style: TextStyle(
                          color: Colors.orange.shade900,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatefulWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  State<_ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<_ChatBubble> {
  late FlutterTts _tts;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _tts = FlutterTts();
    _configureTts();
  }

  Future<void> _configureTts() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    _tts.setStartHandler(() {
      if (mounted) {
        setState(() => _isSpeaking = true);
      }
    });

    _tts.setCompletionHandler(() {
      if (mounted) {
        setState(() => _isSpeaking = false);
      }
    });

    _tts.setErrorHandler((msg) {
      if (mounted) {
        setState(() => _isSpeaking = false);
      }
    });
  }

  bool _containsHindi(String text) {
    // Check if text contains Devanagari script (Hindi)
    final hindiPattern = RegExp(r'[\\u0900-\\u097F]');
    return hindiPattern.hasMatch(text);
  }

  Future<void> _toggleSpeech() async {
    if (_isSpeaking) {
      await _tts.stop();
      setState(() => _isSpeaking = false);
    } else {
      // Detect language from message text or use stored language
      final isHindi =
          widget.message.language == 'hindi' ||
          widget.message.language == 'hi' ||
          _containsHindi(widget.message.text);

      // Set appropriate language for TTS
      if (isHindi) {
        await _tts.setLanguage('hi-IN'); // Hindi
        await _tts.setSpeechRate(0.4); // Slower for Hindi
      } else {
        await _tts.setLanguage('en-US'); // English
        await _tts.setSpeechRate(0.5);
      }

      await _tts.speak(widget.message.text);
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: widget.message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.message.isUser) ...[
            CircleAvatar(
              backgroundColor: Colors.green.shade100,
              radius: 16,
              child: Icon(
                Icons.psychology,
                color: Colors.green.shade700,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: widget.message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: widget.message.isUser
                        ? Colors.green.shade600
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16).copyWith(
                      topLeft: widget.message.isUser
                          ? const Radius.circular(16)
                          : const Radius.circular(4),
                      topRight: widget.message.isUser
                          ? const Radius.circular(4)
                          : const Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    widget.message.text,
                    style: TextStyle(
                      color: widget.message.isUser
                          ? Colors.white
                          : Colors.black87,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
                // Speaker button for AI messages
                if (!widget.message.isUser) ...[
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: _toggleSpeech,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _isSpeaking
                            ? Colors.red.shade50
                            : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _isSpeaking
                              ? Colors.red.shade200
                              : Colors.green.shade200,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isSpeaking ? Icons.volume_off : Icons.volume_up,
                            size: 14,
                            color: _isSpeaking
                                ? Colors.red.shade700
                                : Colors.green.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _isSpeaking ? 'Stop' : 'Listen',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _isSpeaking
                                  ? Colors.red.shade700
                                  : Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (widget.message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.green.shade600,
              radius: 16,
              child: const Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ],
        ],
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green.shade100,
            radius: 16,
            child: Icon(
              Icons.psychology,
              color: Colors.green.shade700,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(
                16,
              ).copyWith(topLeft: const Radius.circular(4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.green.shade600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Thinking...',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GuidelineItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final List<String> items;

  const _GuidelineItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(left: 28, bottom: 4),
            child: Text(
              '• $item',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
          ),
        ),
      ],
    );
  }
}
