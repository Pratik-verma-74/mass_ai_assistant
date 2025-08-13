import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/bottom_action_bar_widget.dart';
import './widgets/notes_skill_widget.dart';
import './widgets/skill_header_widget.dart';
import './widgets/summarizer_skill_widget.dart';
import './widgets/task_planner_skill_widget.dart';
import './widgets/translator_skill_widget.dart';
import './widgets/voice_activation_widget.dart';

class IndividualSkillScreen extends StatefulWidget {
  const IndividualSkillScreen({Key? key}) : super(key: key);

  @override
  State<IndividualSkillScreen> createState() => _IndividualSkillScreenState();
}

class _IndividualSkillScreenState extends State<IndividualSkillScreen> {
  String _currentSkill = 'notes';
  bool _isListening = false;
  String? _transcribedText;
  String? _summaryResult;
  String? _translationResult;
  bool _isProcessing = false;
  List<Map<String, dynamic>> _tasks = [];

  // Mock data for skills
  final Map<String, Map<String, String>> _skillsData = {
    'notes': {
      'name': 'Smart Notes',
      'description':
          'Create and organize notes with voice-to-text and rich formatting',
    },
    'summarizer': {
      'name': 'Text Summarizer',
      'description': 'Generate concise summaries from long texts and documents',
    },
    'translator': {
      'name': 'Language Translator',
      'description':
          'Translate text between multiple languages with pronunciation',
    },
    'task_planner': {
      'name': 'Task Planner',
      'description':
          'Plan and organize tasks with smart scheduling and reminders',
    },
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments['skill'] != null) {
      _currentSkill = arguments['skill'] as String;
    }
  }

  void _toggleVoiceListening() {
    setState(() {
      _isListening = !_isListening;
      if (_isListening) {
        _transcribedText = null;
        // Simulate voice recognition
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted && _isListening) {
            setState(() {
              _transcribedText = _getSimulatedVoiceText();
              _isListening = false;
            });
          }
        });
      }
    });
  }

  String _getSimulatedVoiceText() {
    switch (_currentSkill) {
      case 'notes':
        return 'This is a voice note about the meeting today. We discussed the quarterly goals and project timelines.';
      case 'summarizer':
        return 'Please summarize this long document about artificial intelligence and machine learning applications in healthcare.';
      case 'translator':
        return 'Hello, how are you today? I hope you are doing well.';
      case 'task_planner':
        return 'Create a task to review the project proposal by tomorrow at 3 PM with high priority.';
      default:
        return 'Voice input received successfully.';
    }
  }

  void _handleNotesTextChanged(String text) {
    // Handle notes text changes
  }

  void _handleNotesSave(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note saved successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _handleSummarize(String text, int length) {
    setState(() => _isProcessing = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _summaryResult = _generateMockSummary(text, length);
        });
      }
    });
  }

  String _generateMockSummary(String text, int length) {
    const summaries = {
      1: 'This is a concise summary highlighting the key points and main ideas from the provided text.',
      2: 'This is a medium-length summary that covers the essential information, main arguments, and important details from the original text while maintaining clarity and coherence.',
      3: 'This is a comprehensive summary that thoroughly covers all major points, supporting details, contextual information, and nuanced arguments from the original text. It provides a complete overview while condensing the content effectively for better understanding and retention.',
    };
    return summaries[length] ?? summaries[2]!;
  }

  void _handleTranslate(
      String text, String sourceLanguage, String targetLanguage) {
    setState(() => _isProcessing = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _translationResult = _generateMockTranslation(text, targetLanguage);
        });
      }
    });
  }

  String _generateMockTranslation(String text, String targetLanguage) {
    final translations = {
      'Hindi': 'नमस्ते, आज आप कैसे हैं? मुझे उम्मीद है कि आप अच्छा कर रहे हैं।',
      'Spanish': 'Hola, ¿cómo estás hoy? Espero que estés bien.',
      'French':
          'Bonjour, comment allez-vous aujourd\'hui? J\'espère que vous allez bien.',
      'German': 'Hallo, wie geht es dir heute? Ich hoffe, es geht dir gut.',
      'Chinese': '你好，你今天怎么样？我希望你一切都好。',
      'Japanese': 'こんにちは、今日はいかがですか？元気でいることを願っています。',
      'Arabic': 'مرحبا، كيف حالك اليوم؟ أتمنى أن تكون بخير.',
      'Portuguese': 'Olá, como você está hoje? Espero que você esteja bem.',
      'Russian': 'Привет, как дела сегодня? Надеюсь, у тебя все хорошо.',
    };
    return translations[targetLanguage] ??
        'Translation result would appear here.';
  }

  void _handleCreateTask(Map<String, dynamic> task) {
    setState(() {
      _tasks.add(task);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${task['title']}" created successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _handleSave() {
    switch (_currentSkill) {
      case 'notes':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note saved to device')),
        );
        break;
      case 'summarizer':
        if (_summaryResult != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Summary copied to clipboard')),
          );
        }
        break;
      case 'translator':
        if (_translationResult != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Translation copied to clipboard')),
          );
        }
        break;
      case 'task_planner':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task added to Google Calendar')),
        );
        break;
    }
  }

  void _handleShare() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening share options...')),
    );
  }

  void _handleExport() {
    switch (_currentSkill) {
      case 'notes':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note exported as PDF')),
        );
        break;
      case 'summarizer':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Summary exported as PDF')),
        );
        break;
      case 'translator':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Playing pronunciation...')),
        );
        break;
      case 'task_planner':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reminder set successfully')),
        );
        break;
    }
  }

  void _handleIntegrate() {
    switch (_currentSkill) {
      case 'notes':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Syncing with cloud storage...')),
        );
        break;
      case 'summarizer':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opening email client...')),
        );
        break;
      case 'translator':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opening WhatsApp...')),
        );
        break;
      case 'task_planner':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Syncing with calendar apps...')),
        );
        break;
    }
  }

  Widget _buildSkillContent() {
    switch (_currentSkill) {
      case 'notes':
        return NotesSkillWidget(
          onTextChanged: _handleNotesTextChanged,
          onSave: _handleNotesSave,
          initialText: _transcribedText,
        );
      case 'summarizer':
        return SummarizerSkillWidget(
          onSummarize: _handleSummarize,
          summaryResult: _summaryResult,
          isProcessing: _isProcessing,
        );
      case 'translator':
        return TranslatorSkillWidget(
          onTranslate: _handleTranslate,
          translationResult: _translationResult,
          isProcessing: _isProcessing,
        );
      case 'task_planner':
        return TaskPlannerSkillWidget(
          onCreateTask: _handleCreateTask,
          tasks: _tasks,
        );
      default:
        return const Center(
          child: Text('Skill not found'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final skillData = _skillsData[_currentSkill]!;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header
          SkillHeaderWidget(
            skillName: skillData['name']!,
            skillDescription: skillData['description']!,
            onBackPressed: () => Navigator.pop(context),
          ),
          // Voice Activation
          VoiceActivationWidget(
            isListening: _isListening,
            onVoicePressed: _toggleVoiceListening,
            transcribedText: _transcribedText,
          ),
          // Skill Content
          Expanded(
            child: _buildSkillContent(),
          ),
          // Bottom Action Bar
          BottomActionBarWidget(
            skillType: _currentSkill,
            onSave: _handleSave,
            onShare: _handleShare,
            onExport: _handleExport,
            onIntegrate: _handleIntegrate,
          ),
        ],
      ),
    );
  }
}
