import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TranscriptionDisplayWidget extends StatefulWidget {
  final String transcriptionText;
  final bool isTranscribing;
  final double confidence;

  const TranscriptionDisplayWidget({
    Key? key,
    required this.transcriptionText,
    required this.isTranscribing,
    this.confidence = 1.0,
  }) : super(key: key);

  @override
  State<TranscriptionDisplayWidget> createState() =>
      _TranscriptionDisplayWidgetState();
}

class _TranscriptionDisplayWidgetState extends State<TranscriptionDisplayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _cursorController;
  late Animation<double> _cursorAnimation;

  @override
  void initState() {
    super.initState();
    _cursorController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _cursorAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cursorController,
      curve: Curves.easeInOut,
    ));

    if (widget.isTranscribing) {
      _cursorController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(TranscriptionDisplayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isTranscribing != oldWidget.isTranscribing) {
      widget.isTranscribing
          ? _cursorController.repeat(reverse: true)
          : _cursorController.stop();
    }
  }

  @override
  void dispose() {
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: 15.h,
        maxHeight: 25.h,
      ),
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: (isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight)
            .withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (isDark ? AppTheme.dividerDark : AppTheme.dividerLight)
              .withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Confidence indicator
          if (widget.confidence < 1.0 && widget.transcriptionText.isNotEmpty)
            Container(
              margin: EdgeInsets.only(bottom: 2.h),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: widget.confidence > 0.7
                        ? 'signal_cellular_4_bar'
                        : 'signal_cellular_2_bar',
                    color: widget.confidence > 0.7
                        ? (isDark
                            ? AppTheme.successDark
                            : AppTheme.successLight)
                        : (isDark
                            ? AppTheme.warningDark
                            : AppTheme.warningLight),
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Confidence: ${(widget.confidence * 100).toInt()}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppTheme.textMediumEmphasisDark
                              : AppTheme.textMediumEmphasisLight,
                        ),
                  ),
                ],
              ),
            ),

          // Transcription text
          Expanded(
            child: SingleChildScrollView(
              child: widget.transcriptionText.isEmpty
                  ? _buildPlaceholderText(context, isDark)
                  : _buildTranscriptionText(context, isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderText(BuildContext context, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'hearing',
            color:
                isDark ? AppTheme.textDisabledDark : AppTheme.textDisabledLight,
            size: 8.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'Speak now...',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDark
                      ? AppTheme.textDisabledDark
                      : AppTheme.textDisabledLight,
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTranscriptionText(BuildContext context, bool isDark) {
    return AnimatedBuilder(
      animation: _cursorAnimation,
      builder: (context, child) {
        return RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDark
                      ? AppTheme.textHighEmphasisDark
                      : AppTheme.textHighEmphasisLight,
                  fontSize: 16.sp,
                  height: 1.4,
                ),
            children: [
              TextSpan(text: widget.transcriptionText),
              if (widget.isTranscribing)
                TextSpan(
                  text: '|',
                  style: TextStyle(
                    color: (isDark
                            ? AppTheme.secondaryDark
                            : AppTheme.secondaryLight)
                        .withValues(alpha: _cursorAnimation.value),
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
