import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SuggestedCommandsWidget extends StatelessWidget {
  final Function(String) onCommandTap;
  final bool isEnabled;

  const SuggestedCommandsWidget({
    Key? key,
    required this.onCommandTap,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, dynamic>> commands = [
      {
        'title': 'Set Reminder',
        'subtitle': 'Schedule a task',
        'icon': 'alarm',
        'command': 'set reminder',
      },
      {
        'title': 'Send Message',
        'subtitle': 'Quick messaging',
        'icon': 'message',
        'command': 'send message',
      },
      {
        'title': 'Search Web',
        'subtitle': 'Find information',
        'icon': 'search',
        'command': 'search web',
      },
      {
        'title': 'Take Notes',
        'subtitle': 'Voice to text',
        'icon': 'note_add',
        'command': 'take notes',
      },
      {
        'title': 'Translate',
        'subtitle': 'Language help',
        'icon': 'translate',
        'command': 'translate',
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Text(
              'Try saying:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isDark
                        ? AppTheme.textMediumEmphasisDark
                        : AppTheme.textMediumEmphasisLight,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 12.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              itemCount: commands.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final command = commands[index];
                return _buildCommandCard(context, command, isDark);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommandCard(
      BuildContext context, Map<String, dynamic> command, bool isDark) {
    return GestureDetector(
      onTap:
          isEnabled ? () => onCommandTap(command['command'] as String) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 35.w,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isEnabled
              ? (isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight)
              : (isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight)
                  .withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: (isDark ? AppTheme.dividerDark : AppTheme.dividerLight)
                .withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: (isDark ? AppTheme.shadowDark : AppTheme.shadowLight)
                        .withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: isEnabled
                    ? (isDark ? AppTheme.primaryDark : AppTheme.primaryLight)
                        .withValues(alpha: 0.1)
                    : (isDark
                            ? AppTheme.textDisabledDark
                            : AppTheme.textDisabledLight)
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: command['icon'] as String,
                color: isEnabled
                    ? (isDark ? AppTheme.primaryDark : AppTheme.primaryLight)
                    : (isDark
                        ? AppTheme.textDisabledDark
                        : AppTheme.textDisabledLight),
                size: 5.w,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              command['title'] as String,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isEnabled
                        ? (isDark
                            ? AppTheme.textHighEmphasisDark
                            : AppTheme.textHighEmphasisLight)
                        : (isDark
                            ? AppTheme.textDisabledDark
                            : AppTheme.textDisabledLight),
                    fontWeight: FontWeight.w600,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 0.5.h),
            Text(
              command['subtitle'] as String,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isEnabled
                        ? (isDark
                            ? AppTheme.textMediumEmphasisDark
                            : AppTheme.textMediumEmphasisLight)
                        : (isDark
                            ? AppTheme.textDisabledDark
                            : AppTheme.textDisabledLight),
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
