import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SummarizerSkillWidget extends StatefulWidget {
  final Function(String, int) onSummarize;
  final String? summaryResult;
  final bool isProcessing;

  const SummarizerSkillWidget({
    Key? key,
    required this.onSummarize,
    this.summaryResult,
    this.isProcessing = false,
  }) : super(key: key);

  @override
  State<SummarizerSkillWidget> createState() => _SummarizerSkillWidgetState();
}

class _SummarizerSkillWidgetState extends State<SummarizerSkillWidget> {
  final TextEditingController _textController = TextEditingController();
  int _summaryLength = 3; // 1: Short, 2: Medium, 3: Long
  String _selectedFile = '';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'txt', 'doc', 'docx'],
      );

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first.name;
        });

        if (kIsWeb) {
          final bytes = result.files.first.bytes;
          if (bytes != null) {
            final content = String.fromCharCodes(bytes);
            _textController.text = content;
          }
        } else {
          final file = File(result.files.first.path!);
          final content = await file.readAsString();
          _textController.text = content;
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error reading file')),
      );
    }
  }

  void _pasteFromClipboard() async {
    // Simulate paste functionality
    final clipboardText = "Sample pasted text content for summarization...";
    _textController.text = clipboardText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Input Section
        Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Text to Summarize',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                height: 25.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _textController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: 'Paste your text here or upload a file...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(3.w),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickFile,
                      icon: CustomIconWidget(
                        iconName: 'upload_file',
                        color: Colors.white,
                        size: 4.w,
                      ),
                      label: Text('Upload File'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.lightTheme.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pasteFromClipboard,
                      icon: CustomIconWidget(
                        iconName: 'content_paste',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 4.w,
                      ),
                      label: Text('Paste'),
                    ),
                  ),
                ],
              ),
              if (_selectedFile.isNotEmpty) ...[
                SizedBox(height: 1.h),
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
                        iconName: 'description',
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          _selectedFile,
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        // Summary Length Settings
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
              bottom: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Summary Length',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  _buildLengthOption('Short', 1),
                  SizedBox(width: 3.w),
                  _buildLengthOption('Medium', 2),
                  SizedBox(width: 3.w),
                  _buildLengthOption('Long', 3),
                ],
              ),
            ],
          ),
        ),
        // Summarize Button
        Container(
          padding: EdgeInsets.all(4.w),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.isProcessing || _textController.text.isEmpty
                  ? null
                  : () =>
                      widget.onSummarize(_textController.text, _summaryLength),
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
                          'Processing...',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'Generate Summary',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
        // Summary Result
        if (widget.summaryResult != null) ...[
          Expanded(
            child: Container(
              margin: EdgeInsets.all(4.w),
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
                        iconName: 'summarize',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Summary',
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
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        widget.summaryResult!,
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
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

  Widget _buildLengthOption(String label, int value) {
    final isSelected = _summaryLength == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _summaryLength = value),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.outline,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: isSelected
                  ? Colors.white
                  : AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
