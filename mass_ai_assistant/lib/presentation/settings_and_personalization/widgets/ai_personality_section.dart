import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class AiPersonalitySection extends StatefulWidget {
  final Function(String) onPersonalityChanged;

  const AiPersonalitySection({
    Key? key,
    required this.onPersonalityChanged,
  }) : super(key: key);

  @override
  State<AiPersonalitySection> createState() => _AiPersonalitySectionState();
}

class _AiPersonalitySectionState extends State<AiPersonalitySection> {
  String _selectedPersonality = 'Professional';
  bool _isExpanded = false;

  final Map<String, Map<String, dynamic>> _personalityOptions = {
    'Professional': {
      'icon': 'business_center',
      'description': 'Formal, concise, and task-focused responses',
      'sample':
          'I\'ll help you complete that task efficiently. Here are the recommended steps...',
    },
    'Casual': {
      'icon': 'chat_bubble_outline',
      'description': 'Relaxed, conversational, and approachable tone',
      'sample':
          'Hey! Sure thing, I can help you with that. Let me break it down for you...',
    },
    'Friendly': {
      'icon': 'sentiment_very_satisfied',
      'description': 'Warm, encouraging, and supportive interactions',
      'sample':
          'I\'d be happy to help you with that! Don\'t worry, we\'ll figure this out together...',
    },
  };

  void _previewPersonality(String personality) {
    final sample = _personalityOptions[personality]?['sample'] ?? '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$personality Preview'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sample Response:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  sample,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        children: [
          ListTile(
            leading: CustomIconWidget(
              iconName: 'psychology',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            title: Text(
              'AI Personality',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: CustomIconWidget(
              iconName: _isExpanded ? 'expand_less' : 'expand_more',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose how Mass should interact with you',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                  ),
                  SizedBox(height: 2.h),
                  ..._personalityOptions.entries.map((entry) {
                    final personality = entry.key;
                    final data = entry.value;
                    final isSelected = _selectedPersonality == personality;

                    return Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPersonality = personality;
                          });
                          widget.onPersonalityChanged(personality);
                        },
                        child: Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.lightTheme.primaryColor
                                    .withValues(alpha: 0.1)
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.lightTheme.primaryColor
                                  : AppTheme.lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.3),
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: data['icon'],
                                    color: isSelected
                                        ? AppTheme.lightTheme.primaryColor
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                    size: 24,
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: Text(
                                      personality,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            color: isSelected
                                                ? AppTheme
                                                    .lightTheme.primaryColor
                                                : AppTheme.lightTheme
                                                    .colorScheme.onSurface,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                  if (isSelected)
                                    CustomIconWidget(
                                      iconName: 'check_circle',
                                      color: AppTheme.lightTheme.primaryColor,
                                      size: 20,
                                    ),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                data['description'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSurface
                                          .withValues(alpha: 0.7),
                                    ),
                              ),
                              SizedBox(height: 1.h),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: () =>
                                      _previewPersonality(personality),
                                  icon: CustomIconWidget(
                                    iconName: 'play_arrow',
                                    color: AppTheme.lightTheme.primaryColor,
                                    size: 16,
                                  ),
                                  label: Text(
                                    'Preview',
                                    style: TextStyle(
                                      color: AppTheme.lightTheme.primaryColor,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
