import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class IntegrationSettingsSection extends StatefulWidget {
  final Function(String, bool) onIntegrationToggled;

  const IntegrationSettingsSection({
    Key? key,
    required this.onIntegrationToggled,
  }) : super(key: key);

  @override
  State<IntegrationSettingsSection> createState() =>
      _IntegrationSettingsSectionState();
}

class _IntegrationSettingsSectionState
    extends State<IntegrationSettingsSection> {
  bool _isExpanded = false;

  final Map<String, Map<String, dynamic>> _integrations = {
    'google_calendar': {
      'name': 'Google Calendar',
      'icon': 'calendar_today',
      'description': 'Schedule meetings and manage events',
      'connected': true,
      'status': 'Connected as john.doe@gmail.com',
    },
    'whatsapp': {
      'name': 'WhatsApp',
      'icon': 'chat',
      'description': 'Send messages and manage contacts',
      'connected': false,
      'status': 'Not connected',
    },
    'email': {
      'name': 'Email Client',
      'icon': 'email',
      'description': 'Draft and send emails',
      'connected': true,
      'status': 'Connected to 2 accounts',
    },
    'drive': {
      'name': 'Google Drive',
      'icon': 'cloud',
      'description': 'Access and manage files',
      'connected': false,
      'status': 'Not connected',
    },
  };

  void _toggleIntegration(String integrationKey, bool currentStatus) {
    if (currentStatus) {
      // Disconnect
      _showDisconnectDialog(integrationKey);
    } else {
      // Connect
      _showConnectDialog(integrationKey);
    }
  }

  void _showConnectDialog(String integrationKey) {
    final integration = _integrations[integrationKey]!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Connect ${integration['name']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mass will be able to:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: 1.h),
              _buildPermissionItem(_getPermissions(integrationKey)),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'security',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Your data is encrypted and secure',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.lightTheme.primaryColor,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _integrations[integrationKey]!['connected'] = true;
                  _integrations[integrationKey]!['status'] =
                      _getConnectedStatus(integrationKey);
                });
                widget.onIntegrationToggled(integrationKey, true);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('${integration['name']} connected successfully'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Connect'),
            ),
          ],
        );
      },
    );
  }

  void _showDisconnectDialog(String integrationKey) {
    final integration = _integrations[integrationKey]!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Disconnect ${integration['name']}'),
          content: Text(
            'Mass will no longer be able to access your ${integration['name']} data. You can reconnect at any time.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _integrations[integrationKey]!['connected'] = false;
                  _integrations[integrationKey]!['status'] = 'Not connected';
                });
                widget.onIntegrationToggled(integrationKey, false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${integration['name']} disconnected'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorLight,
                foregroundColor: Colors.white,
              ),
              child: const Text('Disconnect'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPermissionItem(List<String> permissions) {
    return Column(
      children: permissions.map((permission) {
        return Padding(
          padding: EdgeInsets.only(bottom: 0.5.h),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'check',
                color: AppTheme.successLight,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  permission,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<String> _getPermissions(String integrationKey) {
    switch (integrationKey) {
      case 'google_calendar':
        return [
          'View and create calendar events',
          'Schedule meetings and reminders',
          'Access calendar availability',
        ];
      case 'whatsapp':
        return [
          'Send messages to contacts',
          'Read contact list',
          'Access message history',
        ];
      case 'email':
        return [
          'Draft and send emails',
          'Access email contacts',
          'Read email templates',
        ];
      case 'drive':
        return [
          'Access and organize files',
          'Create and edit documents',
          'Share files and folders',
        ];
      default:
        return [];
    }
  }

  String _getConnectedStatus(String integrationKey) {
    switch (integrationKey) {
      case 'google_calendar':
        return 'Connected as john.doe@gmail.com';
      case 'whatsapp':
        return 'Connected to +1 (555) 123-4567';
      case 'email':
        return 'Connected to 2 accounts';
      case 'drive':
        return 'Connected as john.doe@gmail.com';
      default:
        return 'Connected';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        children: [
          ListTile(
            leading: CustomIconWidget(
              iconName: 'integration_instructions',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            title: Text(
              'Integrations',
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
                    'Connect your favorite apps to enhance Mass capabilities',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                  ),
                  SizedBox(height: 2.h),
                  ..._integrations.entries.map((entry) {
                    final key = entry.key;
                    final integration = entry.value;
                    final isConnected = integration['connected'] as bool;

                    return Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: isConnected
                            ? AppTheme.successLight.withValues(alpha: 0.05)
                            : AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isConnected
                              ? AppTheme.successLight.withValues(alpha: 0.2)
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: integration['icon'],
                                color: isConnected
                                    ? AppTheme.successLight
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                                size: 24,
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      integration['name'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    Text(
                                      integration['description'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppTheme.lightTheme
                                                .colorScheme.onSurface
                                                .withValues(alpha: 0.7),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: isConnected,
                                onChanged: (bool value) {
                                  _toggleIntegration(key, isConnected);
                                },
                              ),
                            ],
                          ),
                          if (isConnected) ...[
                            SizedBox(height: 1.h),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: AppTheme.successLight
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'check_circle',
                                    color: AppTheme.successLight,
                                    size: 16,
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: Text(
                                      integration['status'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppTheme.successLight,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
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
