import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TranslatorSkillWidget extends StatefulWidget {
  final Function(String, String, String) onTranslate;
  final String? translationResult;
  final bool isProcessing;

  const TranslatorSkillWidget({
    Key? key,
    required this.onTranslate,
    this.translationResult,
    this.isProcessing = false,
  }) : super(key: key);

  @override
  State<TranslatorSkillWidget> createState() => _TranslatorSkillWidgetState();
}

class _TranslatorSkillWidgetState extends State<TranslatorSkillWidget> {
  final TextEditingController _textController = TextEditingController();
  String _sourceLanguage = 'English';
  String _targetLanguage = 'Hindi';

  final List<String> _languages = [
    'English',
    'Hindi',
    'Spanish',
    'French',
    'German',
    'Chinese',
    'Japanese',
    'Arabic',
    'Portuguese',
    'Russian',
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _swapLanguages() {
    setState(() {
      final temp = _sourceLanguage;
      _sourceLanguage = _targetLanguage;
      _targetLanguage = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Language Selection
        Container(
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              Expanded(
                child: _buildLanguageSelector(
                  label: 'From',
                  selectedLanguage: _sourceLanguage,
                  onChanged: (value) =>
                      setState(() => _sourceLanguage = value!),
                ),
              ),
              SizedBox(width: 4.w),
              GestureDetector(
                onTap: _swapLanguages,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'swap_horiz',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 6.w,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildLanguageSelector(
                  label: 'To',
                  selectedLanguage: _targetLanguage,
                  onChanged: (value) =>
                      setState(() => _targetLanguage = value!),
                ),
              ),
            ],
          ),
        ),
        // Input Text Area
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Text to Translate',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Container(
                height: 20.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          hintText: 'Enter text to translate...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(3.w),
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Voice input functionality
                            },
                            child: CustomIconWidget(
                              iconName: 'mic',
                              color: AppTheme.lightTheme.primaryColor,
                              size: 5.w,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${_textController.text.length}/500',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),
        // Translate Button
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.isProcessing || _textController.text.isEmpty
                  ? null
                  : () => widget.onTranslate(
                        _textController.text,
                        _sourceLanguage,
                        _targetLanguage,
                      ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                backgroundColor: AppTheme.lightTheme.primaryColor,
              ),
              child: widget.isProcessing
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 5.w,
                          height: 5.w,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'Translating...',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'Translate',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
        SizedBox(height: 3.h),
        // Translation Result
        if (widget.translationResult != null) ...[
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'translate',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Translation',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          // Copy to clipboard functionality
                        },
                        child: CustomIconWidget(
                          iconName: 'content_copy',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 5.w,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      GestureDetector(
                        onTap: () {
                          // Text-to-speech functionality
                        },
                        child: CustomIconWidget(
                          iconName: 'volume_up',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 5.w,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        widget.translationResult!,
                        style: AppTheme.lightTheme.textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.tertiary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'record_voice_over',
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          size: 4.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Pronunciation: [${_targetLanguage.toLowerCase()}]',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLanguageSelector({
    required String label,
    required String selectedLanguage,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 0.5.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedLanguage,
              isExpanded: true,
              onChanged: onChanged,
              items: _languages.map((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(
                    language,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
