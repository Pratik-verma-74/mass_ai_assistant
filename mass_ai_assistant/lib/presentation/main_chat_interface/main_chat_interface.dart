import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:async';

import '../../core/app_export.dart';
import '../../services/groq_api_service.dart';
import './widgets/chat_message_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/input_area_widget.dart';
import './widgets/navigation_drawer_widget.dart';

class MainChatInterface extends StatefulWidget {
  const MainChatInterface({Key? key}) : super(key: key);

  @override
  State<MainChatInterface> createState() => _MainChatInterfaceState();
}

class _MainChatInterfaceState extends State<MainChatInterface>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> _messages = [];
  bool _isListening = false;
  String _currentTranscription = '';
  bool _isLoading = false;
  String _aiPersonality = 'Professional';

  final GroqApiService _groqService = GroqApiService();

  // Mock conversation data
  final List<Map<String, dynamic>> _mockMessages = [
    {
      'id': 1,
      'content':
          'Hello! I\'m MASS AI, powered by Groq. How can I help you today?',
      'isUser': false,
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'actionCards': [
        {
          'title': 'Set Reminder',
          'icon': 'alarm',
          'onTap': () {},
        },
        {
          'title': 'Send Message',
          'icon': 'message',
          'onTap': () {},
        },
        {
          'title': 'Search Web',
          'icon': 'search',
          'onTap': () {},
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadConversationHistory();
    _loadPersonality();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadConversationHistory() {
    // Simulate loading conversation history
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _messages = List.from(_mockMessages);
        });
      }
    });
  }

  Future<void> _loadPersonality() async {
    // Load personality from shared preferences or use default
    // For now, using default
    _aiPersonality = 'Professional';
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add({
        'id': _messages.length + 1,
        'content': text,
        'isUser': true,
        'timestamp': DateTime.now(),
      });
      _isLoading = true;
    });

    _textController.clear();
    _scrollToBottom();

    try {
      // Check if Groq API is configured
      if (!_groqService.hasApiKey) {
        setState(() {
          _messages.add({
            'id': _messages.length + 1,
            'content':
                'Please configure your Groq API key in Settings to enable AI responses.',
            'isUser': false,
            'timestamp': DateTime.now(),
            'actionCards': [
              {
                'title': 'Open Settings',
                'icon': 'settings',
                'onTap': () => _openSettings(),
              },
            ],
          });
          _isLoading = false;
        });
        _scrollToBottom();
        return;
      }

      // Generate AI response using Groq
      final response = await _groqService.generateResponse(text,
          personality: _aiPersonality);
      final actionCards =
          await _groqService.generateActionCards(text, response);

      setState(() {
        _messages.add({
          'id': _messages.length + 1,
          'content': response,
          'isUser': false,
          'timestamp': DateTime.now(),
          'actionCards': actionCards,
        });
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add({
          'id': _messages.length + 1,
          'content': 'Sorry, I encountered an error: ${e.toString()}',
          'isUser': false,
          'timestamp': DateTime.now(),
          'actionCards': [
            {
              'title': 'Try Again',
              'icon': 'refresh',
              'onTap': () {
                // Retry by setting the text and sending again
                _textController.text = text;
                _sendMessage();
              },
            },
            {
              'title': 'Check Settings',
              'icon': 'settings',
              'onTap': () => _openSettings(),
            },
          ],
        });
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _openSettings() {
    Navigator.pushNamed(context, '/settings-and-personalization');
  }

  String _generateAIResponse(String userMessage) {
    final responses = [
      'I understand you\'re asking about "$userMessage". Let me help you with that.',
      'That\'s an interesting question about "$userMessage". Here\'s what I can tell you...',
      'Based on your message about "$userMessage", I can assist you with several options.',
      'I\'ve processed your request regarding "$userMessage". Here are some suggestions...',
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }

  List<Map<String, dynamic>>? _generateActionCards(String userMessage) {
    if (userMessage.toLowerCase().contains('remind')) {
      return [
        {
          'title': 'Set Reminder',
          'icon': 'alarm',
          'onTap': () => _handleActionCard('reminder')
        },
        {
          'title': 'View Calendar',
          'icon': 'calendar_today',
          'onTap': () => _handleActionCard('calendar')
        },
      ];
    } else if (userMessage.toLowerCase().contains('message')) {
      return [
        {
          'title': 'Send Message',
          'icon': 'message',
          'onTap': () => _handleActionCard('message')
        },
        {
          'title': 'View Contacts',
          'icon': 'contacts',
          'onTap': () => _handleActionCard('contacts')
        },
      ];
    } else if (userMessage.toLowerCase().contains('search')) {
      return [
        {
          'title': 'Search Web',
          'icon': 'search',
          'onTap': () => _handleActionCard('search')
        },
        {
          'title': 'Open Browser',
          'icon': 'open_in_browser',
          'onTap': () => _handleActionCard('browser')
        },
      ];
    }
    return [
      {
        'title': 'More Options',
        'icon': 'more_horiz',
        'onTap': () => _handleActionCard('more')
      },
    ];
  }

  void _handleActionCard(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Action: $action'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _startVoiceInput() {
    setState(() {
      _isListening = true;
      _currentTranscription = '';
    });

    // Simulate voice recognition
    _simulateVoiceRecognition();
  }

  void _stopVoiceInput() {
    setState(() {
      _isListening = false;
    });

    if (_currentTranscription.isNotEmpty) {
      _textController.text = _currentTranscription;
      _sendMessage();
    }
  }

  void _simulateVoiceRecognition() {
    final phrases = [
      'Hello MASS AI',
      'Set a reminder for tomorrow',
      'Send a message to John',
      'Search for Flutter tutorials',
      'What\'s the weather like today?',
    ];

    final selectedPhrase = phrases[DateTime.now().millisecond % phrases.length];
    final words = selectedPhrase.split(' ');

    int wordIndex = 0;
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!_isListening || wordIndex >= words.length) {
        timer.cancel();
        return;
      }

      setState(() {
        _currentTranscription = words.take(wordIndex + 1).join(' ');
      });
      wordIndex++;
    });
  }

  void _handleAttachment() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Attachment',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption('Camera', 'camera_alt', () {
                  Navigator.pop(context);
                  _handleCamera();
                }),
                _buildAttachmentOption('Gallery', 'photo_library', () {
                  Navigator.pop(context);
                  _handleGallery();
                }),
                _buildAttachmentOption('Document', 'description', () {
                  Navigator.pop(context);
                  _handleDocument();
                }),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(String title, String icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer
                  .withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  void _handleCamera() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Camera functionality would open here')),
    );
  }

  void _handleGallery() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gallery functionality would open here')),
    );
  }

  void _handleDocument() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document picker would open here')),
    );
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

  void _showMessageOptions(Map<String, dynamic> message) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'copy',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Copy'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message copied to clipboard')),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Share'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Share functionality would open here')),
                );
              },
            ),
            if (message['isUser'] == true)
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'delete',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 24,
                ),
                title: Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _messages.removeWhere((msg) => msg['id'] == message['id']);
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshConversation() async {
    await Future.delayed(const Duration(seconds: 1));
    _loadConversationHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      drawer: const NavigationDrawerWidget(),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.lightTheme.colorScheme.primary,
                    AppTheme.lightTheme.colorScheme.secondary,
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  'M',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MASS AI',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _groqService.hasApiKey
                      ? 'Powered by Groq'
                      : 'Configure API Key',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: _groqService.hasApiKey
                        ? AppTheme.lightTheme.colorScheme.secondary
                        : AppTheme.warningLight,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/voice-command-mode'),
            icon: CustomIconWidget(
              iconName: 'record_voice_over',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? EmptyStateWidget(onVoiceCommand: _startVoiceInput)
                : RefreshIndicator(
                    onRefresh: _refreshConversation,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      itemCount: _messages.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _messages.length && _isLoading) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 1.h),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(3.w),
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.lightTheme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme
                                            .lightTheme.colorScheme.shadow,
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 4.w,
                                        height: 4.w,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            AppTheme
                                                .lightTheme.colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 3.w),
                                      Text(
                                        'MASS AI is thinking...',
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: AppTheme
                                              .lightTheme.colorScheme.onSurface
                                              .withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        final message = _messages[index];
                        return ChatMessageWidget(
                          message: message,
                          onLongPress: () => _showMessageOptions(message),
                        );
                      },
                    ),
                  ),
          ),
          InputAreaWidget(
            textController: _textController,
            isListening: _isListening,
            transcription: _currentTranscription,
            onSendMessage: _sendMessage,
            onVoicePressed: _startVoiceInput,
            onStopListening: _stopVoiceInput,
            onAttachmentPressed: _handleAttachment,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/ai-skills-hub'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        child: CustomIconWidget(
          iconName: 'hub',
          color: AppTheme.lightTheme.colorScheme.onSecondary,
          size: 24,
        ),
      ),
    );
  }
}
