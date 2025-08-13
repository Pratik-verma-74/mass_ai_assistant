import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.lightTheme.colorScheme.primary,
                    AppTheme.lightTheme.colorScheme.primaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 15.w,
                    height: 15.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                    ),
                    child: Center(
                      child: Text(
                        'M',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MASS AI',
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Your AI Assistant',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary
                                .withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                children: [
                  _buildDrawerItem(
                    context,
                    icon: 'chat',
                    title: 'Chat Interface',
                    isSelected: true,
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: 'record_voice_over',
                    title: 'Voice Command Mode',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/voice-command-mode');
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: 'hub',
                    title: 'AI Skills Hub',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/ai-skills-hub');
                    },
                  ),
                  Divider(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    height: 4.h,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: 'note_add',
                    title: 'Notes',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/individual-skill-screen');
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: 'summarize',
                    title: 'Summarizer',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/individual-skill-screen');
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: 'translate',
                    title: 'Translator',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/individual-skill-screen');
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: 'task_alt',
                    title: 'Task Planner',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/individual-skill-screen');
                    },
                  ),
                  Divider(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    height: 4.h,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: 'settings',
                    title: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                          context, '/settings-and-personalization');
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Version 1.0.0',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CustomIconWidget(
          iconName: icon,
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
          size: 24,
        ),
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
