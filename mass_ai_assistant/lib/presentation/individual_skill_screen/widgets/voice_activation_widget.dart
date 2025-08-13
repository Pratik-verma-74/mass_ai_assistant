import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceActivationWidget extends StatefulWidget {
  final bool isListening;
  final VoidCallback onVoicePressed;
  final String? transcribedText;

  const VoiceActivationWidget({
    Key? key,
    required this.isListening,
    required this.onVoicePressed,
    this.transcribedText,
  }) : super(key: key);

  @override
  State<VoiceActivationWidget> createState() => _VoiceActivationWidgetState();
}

class _VoiceActivationWidgetState extends State<VoiceActivationWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(VoiceActivationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening && !oldWidget.isListening) {
      _pulseController.repeat(reverse: true);
      _waveController.repeat(reverse: true);
    } else if (!widget.isListening && oldWidget.isListening) {
      _pulseController.stop();
      _waveController.stop();
      _pulseController.reset();
      _waveController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          GestureDetector(
            onTap: widget.onVoicePressed,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: widget.isListening ? _pulseAnimation.value : 1.0,
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: widget.isListening
                            ? [
                                AppTheme.lightTheme.colorScheme.secondary,
                                AppTheme.lightTheme.colorScheme.secondary
                                    .withValues(alpha: 0.7),
                              ]
                            : [
                                AppTheme.lightTheme.primaryColor,
                                AppTheme.lightTheme.primaryColor
                                    .withValues(alpha: 0.8),
                              ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.isListening
                              ? AppTheme.lightTheme.colorScheme.secondary
                                  .withValues(alpha: 0.3)
                              : AppTheme.lightTheme.primaryColor
                                  .withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: CustomIconWidget(
                      iconName: widget.isListening ? 'mic' : 'mic_none',
                      color: Colors.white,
                      size: 8.w,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 2.h),
          if (widget.isListening) ...[
            AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.w),
                      width: 1.w,
                      height: (3 + (index % 3) * 2).h * _waveAnimation.value,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                );
              },
            ),
            SizedBox(height: 2.h),
            Text(
              'Listening...',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          if (widget.transcribedText != null &&
              widget.transcribedText!.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
              child: Text(
                widget.transcribedText!,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
