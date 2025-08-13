import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotesSkillWidget extends StatefulWidget {
  final Function(String) onTextChanged;
  final Function(String) onSave;
  final String? initialText;

  const NotesSkillWidget({
    Key? key,
    required this.onTextChanged,
    required this.onSave,
    this.initialText,
  }) : super(key: key);

  @override
  State<NotesSkillWidget> createState() => _NotesSkillWidgetState();
}

class _NotesSkillWidgetState extends State<NotesSkillWidget> {
  late TextEditingController _textController;
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText ?? '');
    _textController.addListener(() {
      widget.onTextChanged(_textController.text);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _insertVoiceText(String text) {
    final currentText = _textController.text;
    final selection = _textController.selection;
    final newText = currentText.replaceRange(
      selection.start,
      selection.end,
      text,
    );
    _textController.text = newText;
    _textController.selection = TextSelection.collapsed(
      offset: selection.start + text.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Formatting Toolbar
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              _buildFormatButton(
                icon: 'format_bold',
                isActive: _isBold,
                onPressed: () => setState(() => _isBold = !_isBold),
              ),
              SizedBox(width: 2.w),
              _buildFormatButton(
                icon: 'format_italic',
                isActive: _isItalic,
                onPressed: () => setState(() => _isItalic = !_isItalic),
              ),
              SizedBox(width: 2.w),
              _buildFormatButton(
                icon: 'format_underlined',
                isActive: _isUnderline,
                onPressed: () => setState(() => _isUnderline = !_isUnderline),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => widget.onSave(_textController.text),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'save',
                        color: Colors.white,
                        size: 4.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Save',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Text Editor
        Expanded(
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: TextField(
              controller: _textController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                decoration: _isUnderline
                    ? TextDecoration.underline
                    : TextDecoration.none,
              ),
              decoration: InputDecoration(
                hintText: 'Start typing your notes or use voice input...',
                border: InputBorder.none,
                hintStyle: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
        // Auto-save indicator
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'cloud_done',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Auto-saved ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormatButton({
    required String icon,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isActive
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.outline,
          ),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: isActive
              ? AppTheme.lightTheme.primaryColor
              : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 5.w,
        ),
      ),
    );
  }
}
