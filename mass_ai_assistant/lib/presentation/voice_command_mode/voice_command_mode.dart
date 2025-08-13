import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/listening_status_widget.dart';
import './widgets/suggested_commands_widget.dart';
import './widgets/transcription_display_widget.dart';
import './widgets/voice_waveform_widget.dart';

class VoiceCommandMode extends StatefulWidget {
  const VoiceCommandMode({Key? key}) : super(key: key);

  @override
  State<VoiceCommandMode> createState() => _VoiceCommandModeState();
}

class _VoiceCommandModeState extends State<VoiceCommandMode>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // Voice processing state
  bool _isListening = false;
  bool _isProcessing = false;
  String _transcriptionText = '';
  String _statusText = 'Listening...';
  double _voiceAmplitude = 0.0;
  double _confidence = 1.0;

  // Timers
  Timer? _silenceTimer;
  Timer? _amplitudeTimer;
  Timer? _processingTimer;

  // Mock voice recognition data
  final List<String> _mockTranscriptions = [
    'Set a reminder for tomorrow at 9 AM',
    'Send a message to John about the meeting',
    'Search for the best restaurants nearby',
    'Take notes about the project discussion',
    'Translate hello to Spanish',
    'What\'s the weather like today',
    'Schedule a call with the team',
    'Create a new task for grocery shopping',
  ];

  int _currentTranscriptionIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startListening();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _fadeController.forward();
    _scaleController.forward();
  }

  void _startListening() {
    setState(() {
      _isListening = true;
      _statusText = 'Listening...';
      _transcriptionText = '';
    });

    // Provide haptic feedback
    HapticFeedback.lightImpact();

    // Start amplitude simulation
    _startAmplitudeSimulation();

    // Start silence timer (8 seconds)
    _silenceTimer?.cancel();
    _silenceTimer = Timer(const Duration(seconds: 8), () {
      if (_transcriptionText.isEmpty) {
        _handleTimeout();
      } else {
        _processCommand();
      }
    });

    // Simulate voice recognition after 2-4 seconds
    Timer(Duration(seconds: 2 + math.Random().nextInt(3)), () {
      if (_isListening && mounted) {
        _simulateVoiceRecognition();
      }
    });
  }

  void _startAmplitudeSimulation() {
    _amplitudeTimer?.cancel();
    _amplitudeTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_isListening && mounted) {
        setState(() {
          _voiceAmplitude = 0.3 + (math.Random().nextDouble() * 0.7);
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _simulateVoiceRecognition() {
    if (!_isListening) return;

    final transcription = _mockTranscriptions[_currentTranscriptionIndex];
    _currentTranscriptionIndex =
        (_currentTranscriptionIndex + 1) % _mockTranscriptions.length;

    // Simulate gradual transcription
    String currentText = '';
    int charIndex = 0;

    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!_isListening || !mounted) {
        timer.cancel();
        return;
      }

      if (charIndex < transcription.length) {
        currentText += transcription[charIndex];
        setState(() {
          _transcriptionText = currentText;
          _confidence = 0.7 + (math.Random().nextDouble() * 0.3);
        });
        charIndex++;
      } else {
        timer.cancel();
        // Wait a moment then process
        Timer(const Duration(seconds: 1), () {
          if (_isListening && mounted) {
            _processCommand();
          }
        });
      }
    });
  }

  void _processCommand() {
    setState(() {
      _isListening = false;
      _isProcessing = true;
      _statusText = 'Processing...';
      _voiceAmplitude = 0.0;
    });

    _amplitudeTimer?.cancel();
    _silenceTimer?.cancel();

    // Show processing animation
    _processingTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        _showCommandConfirmation();
      }
    });
  }

  void _showCommandConfirmation() {
    HapticFeedback.mediumImpact();

    setState(() {
      _isProcessing = false;
      _statusText = 'Command recognized!';
    });

    // Show confirmation for 1 second then exit
    Timer(const Duration(seconds: 1), () {
      if (mounted) {
        _exitVoiceMode();
      }
    });
  }

  void _handleTimeout() {
    setState(() {
      _isListening = false;
      _statusText = 'No voice detected';
      _voiceAmplitude = 0.0;
    });

    _amplitudeTimer?.cancel();

    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        _exitVoiceMode();
      }
    });
  }

  void _handleSuggestedCommand(String command) {
    HapticFeedback.selectionClick();

    setState(() {
      _transcriptionText = command;
      _confidence = 1.0;
    });

    Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        _processCommand();
      }
    });
  }

  void _exitVoiceMode() {
    _silenceTimer?.cancel();
    _amplitudeTimer?.cancel();
    _processingTimer?.cancel();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    _fadeController.reverse().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _silenceTimer?.cancel();
    _amplitudeTimer?.cancel();
    _processingTimer?.cancel();
    _fadeController.dispose();
    _scaleController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: (isDark ? Colors.black : Colors.black87)
                    .withValues(alpha: 0.9),
              ),
              child: SafeArea(
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Column(
                        children: [
                          // Status and cancel button
                          ListeningStatusWidget(
                            isListening: _isListening,
                            statusText: _statusText,
                            onCancel: _exitVoiceMode,
                          ),

                          SizedBox(height: 4.h),

                          // Voice waveform visualization
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: VoiceWaveformWidget(
                                isListening: _isListening,
                                amplitude: _voiceAmplitude,
                              ),
                            ),
                          ),

                          SizedBox(height: 4.h),

                          // Transcription display
                          TranscriptionDisplayWidget(
                            transcriptionText: _transcriptionText,
                            isTranscribing:
                                _isListening && _transcriptionText.isNotEmpty,
                            confidence: _confidence,
                          ),

                          SizedBox(height: 4.h),

                          // Suggested commands
                          if (!_isProcessing)
                            Expanded(
                              flex: 1,
                              child: SuggestedCommandsWidget(
                                onCommandTap: _handleSuggestedCommand,
                                isEnabled:
                                    !_isListening || _transcriptionText.isEmpty,
                              ),
                            ),

                          // Processing indicator
                          if (_isProcessing)
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 8.w,
                                      height: 8.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          isDark
                                              ? AppTheme.secondaryDark
                                              : AppTheme.secondaryLight,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      'Processing your command...',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: isDark
                                                ? AppTheme
                                                    .textMediumEmphasisDark
                                                : AppTheme
                                                    .textMediumEmphasisLight,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          SizedBox(height: 2.h),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
