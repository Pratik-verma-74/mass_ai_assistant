import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroqApiService {
  static const String _baseUrl = 'https://api.groq.com/openai/v1';
  static const String _apiKeyKey = 'groq_api_key';

  final Dio _dio = Dio();
  String? _apiKey;

  GroqApiService() {
    _initializeDio();
    _loadApiKey();
  }

  void _initializeDio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_apiKey != null) {
            options.headers['Authorization'] = 'Bearer $_apiKey';
          }
          options.headers['Content-Type'] = 'application/json';
          handler.next(options);
        },
        onError: (error, handler) {
          print('Groq API Error: ${error.message}');
          handler.next(error);
        },
      ),
    );
  }

  Future<void> _loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    _apiKey = prefs.getString(_apiKeyKey);
  }

  Future<void> setApiKey(String apiKey) async {
    _apiKey = apiKey.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyKey, _apiKey!);
    print('Groq API key saved successfully');
  }

  Future<String?> getApiKey() async {
    if (_apiKey == null) {
      await _loadApiKey();
    }
    return _apiKey;
  }

  Future<void> clearApiKey() async {
    _apiKey = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_apiKeyKey);
  }

  bool get hasApiKey => _apiKey != null && _apiKey!.isNotEmpty;

  Future<String> generateResponse(String message,
      {String personality = 'Professional'}) async {
    if (!hasApiKey) {
      throw Exception(
          'Groq API key not configured. Please add your API key in settings.');
    }

    try {
      final systemPrompt = _getSystemPrompt(personality);

      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'llama3-8b-8192', // Using Groq's fastest Llama model
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': message},
          ],
          'max_tokens': 1000,
          'temperature': 0.7,
          'stream': false,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['choices'] != null && data['choices'].isNotEmpty) {
          return data['choices'][0]['message']['content'] ??
              'Sorry, I couldn\'t generate a response.';
        }
      }

      return 'Sorry, I received an unexpected response format.';
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception(
            'Invalid Groq API key. Please check your API key in settings.');
      } else if (e.response?.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again later.');
      } else if (e.response?.statusCode == 503) {
        throw Exception(
            'Groq service temporarily unavailable. Please try again later.');
      }

      throw Exception('Failed to generate response: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  String _getSystemPrompt(String personality) {
    switch (personality) {
      case 'Professional':
        return '''You are MASS AI, a professional AI assistant. Provide formal, concise, and task-focused responses. 
                Be direct and efficient in your communication while remaining helpful and courteous.''';

      case 'Casual':
        return '''You are MASS AI, a casual and conversational AI assistant. Use a relaxed, approachable tone. 
                Feel free to use everyday language and be conversational while still being helpful.''';

      case 'Friendly':
        return '''You are MASS AI, a warm and encouraging AI assistant. Be supportive, empathetic, and positive 
                in your responses. Show enthusiasm for helping and make the user feel comfortable.''';

      default:
        return '''You are MASS AI, a helpful AI assistant. Provide clear, accurate, and useful responses to user queries.''';
    }
  }

  Future<List<Map<String, dynamic>>> generateActionCards(
      String userMessage, String aiResponse) async {
    // Generate contextual action cards based on the conversation
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('remind') || lowerMessage.contains('schedule')) {
      return [
        {
          'title': 'Set Reminder',
          'icon': 'alarm',
          'onTap': () {},
        },
        {
          'title': 'View Calendar',
          'icon': 'calendar_today',
          'onTap': () {},
        },
      ];
    } else if (lowerMessage.contains('message') ||
        lowerMessage.contains('text') ||
        lowerMessage.contains('send')) {
      return [
        {
          'title': 'Send Message',
          'icon': 'message',
          'onTap': () {},
        },
        {
          'title': 'View Contacts',
          'icon': 'contacts',
          'onTap': () {},
        },
      ];
    } else if (lowerMessage.contains('search') ||
        lowerMessage.contains('find') ||
        lowerMessage.contains('look')) {
      return [
        {
          'title': 'Search Web',
          'icon': 'search',
          'onTap': () {},
        },
        {
          'title': 'Open Browser',
          'icon': 'open_in_browser',
          'onTap': () {},
        },
      ];
    } else if (lowerMessage.contains('write') ||
        lowerMessage.contains('draft') ||
        lowerMessage.contains('email')) {
      return [
        {
          'title': 'Draft Email',
          'icon': 'email',
          'onTap': () {},
        },
        {
          'title': 'Save Draft',
          'icon': 'save',
          'onTap': () {},
        },
      ];
    }

    return [
      {
        'title': 'More Options',
        'icon': 'more_horiz',
        'onTap': () {},
      },
    ];
  }
}
