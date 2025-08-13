import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './voice_input_widget.dart';

class InputAreaWidget extends StatefulWidget {
  final TextEditingController textController;
  final bool isListening;
  final String transcription;
  final VoidCallback onSendMessage;
  final VoidCallback onVoicePressed;
  final VoidCallback? onStopListening;
  final VoidCallback onAttachmentPressed;

  const InputAreaWidget({
    Key? key,
    required this.textController,
    required this.isListening,
    required this.transcription,
    required this.onSendMessage,
    required this.onVoicePressed,
    this.onStopListening,
    required this.onAttachmentPressed,
  }) : super(key: key);

  @override
  State<InputAreaWidget> createState() => _InputAreaWidgetState();
}

class _InputAreaWidgetState extends State<InputAreaWidget> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.textController.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasText = widget.textController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            if (widget.isListening)
              VoiceInputWidget(
                isListening: widget.isListening,
                transcription: widget.transcription,
                onVoicePressed: widget.onVoicePressed,
                onStopListening: widget.onStopListening,
              )
            else
              Row(
                children: [
                  GestureDetector(
                    onTap: widget.onAttachmentPressed,
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primaryContainer
                            .withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'attach_file',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: widget.textController,
                              decoration: InputDecoration(
                                hintText: 'Type a message...',
                                hintStyle: AppTheme
                                    .lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 4.w, vertical: 2.h),
                              ),
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                              maxLines: 4,
                              minLines: 1,
                            ),
                          ),
                          if (_hasText)
                            GestureDetector(
                              onTap: widget.onSendMessage,
                              child: Container(
                                margin: EdgeInsets.only(right: 2.w),
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: CustomIconWidget(
                                  iconName: 'send',
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  size: 18,
                                ),
                              ),
                            )
                          else
                            GestureDetector(
                              onTap: widget.onVoicePressed,
                              child: Container(
                                margin: EdgeInsets.only(right: 2.w),
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.lightTheme.colorScheme.secondary,
                                  shape: BoxShape.circle,
                                ),
                                child: CustomIconWidget(
                                  iconName: 'mic',
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSecondary,
                                  size: 18,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
