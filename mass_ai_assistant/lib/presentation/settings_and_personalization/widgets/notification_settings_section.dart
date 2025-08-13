import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class NotificationSettingsSection extends StatefulWidget {
  final Function(String, bool) onNotificationToggled;
  final Function(TimeOfDay, TimeOfDay) onQuietHoursChanged;
  final Function(bool) onVoiceFeedbackChanged;

  const NotificationSettingsSection({
    Key? key,
    required this.onNotificationToggled,
    required this.onQuietHoursChanged,
    required this.onVoiceFeedbackChanged,
  }) : super(key: key);

  @override
  State<NotificationSettingsSection> createState() =>
      _NotificationSettingsSectionState();
}

class _NotificationSettingsSectionState
    extends State<NotificationSettingsSection> {
  bool _isExpanded = false;
  TimeOfDay _quietHoursStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietHoursEnd = const TimeOfDay(hour: 7, minute: 0);
  bool _voiceFeedback = true;

  final Map<String, Map<String, dynamic>> _notificationTypes = {
    'reminders': {
      'title': 'Reminders',
      'description': 'Task and event reminders',
      'icon': 'alarm',
      'enabled': true,
    },
    'responses': {
      'title': 'AI Responses',
      'description': 'Notifications for AI task completions',
      'icon': 'smart_toy',
      'enabled': true,
    },
    'updates': {
      'title': 'App Updates',
      'description': 'New features and improvements',
      'icon': 'system_update',
      'enabled': false,
    },
    'tips': {
      'title': 'Tips & Suggestions',
      'description': 'Helpful usage tips and suggestions',
      'icon': 'lightbulb',
      'enabled': true,
    },
  };

  Future<void> _selectTime(bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _quietHoursStart : _quietHoursEnd,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              hourMinuteTextColor: AppTheme.lightTheme.primaryColor,
              dialHandColor: AppTheme.lightTheme.primaryColor,
              dialBackgroundColor:
                  AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _quietHoursStart = picked;
        } else {
          _quietHoursEnd = picked;
        }
      });
      widget.onQuietHoursChanged(_quietHoursStart, _quietHoursEnd);
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        children: [
          ListTile(
            leading: CustomIconWidget(
              iconName: 'notifications',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            title: Text(
              'Notifications',
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
                  // Notification Types
                  Text(
                    'Notification Types',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: 1.h),
                  ..._notificationTypes.entries.map((entry) {
                    final key = entry.key;
                    final notification = entry.value;
                    final isEnabled = notification['enabled'] as bool;

                    return Container(
                      margin: EdgeInsets.only(bottom: 1.h),
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: notification['icon'],
                            color: isEnabled
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                            size: 24,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notification['title'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: isEnabled
                                            ? AppTheme.lightTheme.colorScheme
                                                .onSurface
                                            : AppTheme.lightTheme.colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.6),
                                      ),
                                ),
                                Text(
                                  notification['description'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface
                                            .withValues(alpha: 0.7),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: isEnabled,
                            onChanged: (bool value) {
                              setState(() {
                                _notificationTypes[key]!['enabled'] = value;
                              });
                              widget.onNotificationToggled(key, value);
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 2.h),

                  // Quiet Hours
                  Text(
                    'Quiet Hours',
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'No notifications during these hours',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectTime(true),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1.5.h, horizontal: 3.w),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppTheme
                                          .lightTheme.colorScheme.outline,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Start',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: AppTheme.lightTheme
                                                  .colorScheme.onSurface
                                                  .withValues(alpha: 0.7),
                                            ),
                                      ),
                                      Text(
                                        _formatTime(_quietHoursStart),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            CustomIconWidget(
                              iconName: 'arrow_forward',
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                              size: 20,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectTime(false),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1.5.h, horizontal: 3.w),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppTheme
                                          .lightTheme.colorScheme.outline,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'End',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: AppTheme.lightTheme
                                                  .colorScheme.onSurface
                                                  .withValues(alpha: 0.7),
                                            ),
                                      ),
                                      Text(
                                        _formatTime(_quietHoursEnd),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // Voice Feedback
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
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'volume_up',
                          color: _voiceFeedback
                              ? AppTheme.lightTheme.primaryColor
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                          size: 24,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Voice Feedback',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                'Play sounds for notifications and responses',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSurface
                                          .withValues(alpha: 0.7),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _voiceFeedback,
                          onChanged: (bool value) {
                            setState(() {
                              _voiceFeedback = value;
                            });
                            widget.onVoiceFeedbackChanged(value);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
