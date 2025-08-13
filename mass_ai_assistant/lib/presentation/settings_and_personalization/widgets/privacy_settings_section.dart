import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class PrivacySettingsSection extends StatefulWidget {
  final Function(bool) onLocalProcessingChanged;
  final VoidCallback onDeleteData;

  const PrivacySettingsSection({
    Key? key,
    required this.onLocalProcessingChanged,
    required this.onDeleteData,
  }) : super(key: key);

  @override
  State<PrivacySettingsSection> createState() => _PrivacySettingsSectionState();
}

class _PrivacySettingsSectionState extends State<PrivacySettingsSection> {
  bool _localProcessing = true;
  bool _isExpanded = false;

  void _showDataHandlingPolicy() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Voice Data Handling'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'How we handle your voice data:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(height: 1.h),
                _buildPolicyItem(
                  'Local Processing',
                  'Voice commands are processed on your device when possible',
                  'security',
                ),
                _buildPolicyItem(
                  'Encrypted Transmission',
                  'Data sent to servers is encrypted end-to-end',
                  'lock',
                ),
                _buildPolicyItem(
                  'No Permanent Storage',
                  'Voice recordings are not stored permanently',
                  'delete_forever',
                ),
                _buildPolicyItem(
                  'Anonymous Processing',
                  'Personal identifiers are removed from voice data',
                  'visibility_off',
                ),
                SizedBox(height: 2.h),
                Text(
                  'You can delete all stored voice data at any time using the delete option below.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                ),
              ],
            ),
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

  Widget _buildPolicyItem(String title, String description, String iconName) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.primaryColor,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteData() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Voice Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This will permanently delete:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 1.h),
              _buildDeleteItem('All stored voice recordings'),
              _buildDeleteItem('Voice command history'),
              _buildDeleteItem('Personalized voice models'),
              _buildDeleteItem('Speech recognition improvements'),
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.warningLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.warningLight.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'warning',
                      color: AppTheme.warningLight,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'This action cannot be undone',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.warningLight,
                              fontWeight: FontWeight.w500,
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
                widget.onDeleteData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Voice data deleted successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorLight,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDeleteItem(String item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'circle',
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.6),
            size: 8,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              item,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
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
              iconName: 'privacy_tip',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            title: Text(
              'Privacy & Security',
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
                  // Voice Data Handling Policy
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CustomIconWidget(
                      iconName: 'info_outline',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 24,
                    ),
                    title: const Text('Voice Data Handling'),
                    subtitle:
                        const Text('Learn how we protect your voice data'),
                    trailing: CustomIconWidget(
                      iconName: 'arrow_forward_ios',
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                      size: 16,
                    ),
                    onTap: _showDataHandlingPolicy,
                  ),
                  SizedBox(height: 1.h),

                  // Local Processing Toggle
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
                          iconName: 'security',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 24,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Local Processing',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                'Process voice commands on device when possible',
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
                          value: _localProcessing,
                          onChanged: (bool value) {
                            setState(() {
                              _localProcessing = value;
                            });
                            widget.onLocalProcessingChanged(value);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // Delete Data Option
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.errorLight.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.errorLight.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'delete_forever',
                              color: AppTheme.errorLight,
                              size: 24,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Delete Voice Data',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: AppTheme.errorLight,
                                        ),
                                  ),
                                  Text(
                                    'Permanently remove all stored voice recordings and data',
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
                          ],
                        ),
                        SizedBox(height: 2.h),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _confirmDeleteData,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.errorLight,
                              side: BorderSide(color: AppTheme.errorLight),
                            ),
                            child: const Text('Delete All Voice Data'),
                          ),
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
