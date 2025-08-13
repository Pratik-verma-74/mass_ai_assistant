import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceWaveformWidget extends StatefulWidget {
  final bool isListening;
  final double amplitude;

  const VoiceWaveformWidget({
    Key? key,
    required this.isListening,
    this.amplitude = 0.5,
  }) : super(key: key);

  @override
  State<VoiceWaveformWidget> createState() => _VoiceWaveformWidgetState();
}

class _VoiceWaveformWidgetState extends State<VoiceWaveformWidget>
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
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.linear,
    ));

    if (widget.isListening) {
      _startAnimations();
    }
  }

  @override
  void didUpdateWidget(VoiceWaveformWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening != oldWidget.isListening) {
      widget.isListening ? _startAnimations() : _stopAnimations();
    }
  }

  void _startAnimations() {
    _pulseController.repeat();
    _waveController.repeat();
  }

  void _stopAnimations() {
    _pulseController.stop();
    _waveController.stop();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 60.w,
      height: 60.w,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseAnimation, _waveAnimation]),
        builder: (context, child) {
          return CustomPaint(
            painter: WaveformPainter(
              pulseValue: _pulseAnimation.value,
              waveValue: _waveAnimation.value,
              amplitude: widget.amplitude,
              isListening: widget.isListening,
              isDark: isDark,
            ),
            child: Center(
              child: Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isListening
                      ? (isDark
                          ? AppTheme.secondaryDark
                          : AppTheme.secondaryLight)
                      : (isDark ? AppTheme.primaryDark : AppTheme.primaryLight),
                  boxShadow: widget.isListening
                      ? [
                          BoxShadow(
                            color: (isDark
                                    ? AppTheme.secondaryDark
                                    : AppTheme.secondaryLight)
                                .withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ]
                      : [],
                ),
                child: CustomIconWidget(
                  iconName: 'mic',
                  color:
                      isDark ? AppTheme.onPrimaryDark : AppTheme.onPrimaryLight,
                  size: 8.w,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final double pulseValue;
  final double waveValue;
  final double amplitude;
  final bool isListening;
  final bool isDark;

  WaveformPainter({
    required this.pulseValue,
    required this.waveValue,
    required this.amplitude,
    required this.isListening,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isListening) return;

    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width * 0.15;

    // Draw concentric circles
    for (int i = 0; i < 3; i++) {
      final radius = baseRadius + (i * 30) + (pulseValue * 20);
      final opacity = (1.0 - pulseValue) * (1.0 - i * 0.3);

      final paint = Paint()
        ..color = (isDark ? AppTheme.secondaryDark : AppTheme.secondaryLight)
            .withValues(alpha: opacity * 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(center, radius, paint);
    }

    // Draw waveform
    final waveformPaint = Paint()
      ..color = (isDark ? AppTheme.secondaryDark : AppTheme.secondaryLight)
          .withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final waveRadius = baseRadius + 40;

    for (double angle = 0; angle < 2 * math.pi; angle += 0.1) {
      final waveAmplitude = amplitude * 20 * math.sin(angle * 4 + waveValue);
      final radius = waveRadius + waveAmplitude;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (angle == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, waveformPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
