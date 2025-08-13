import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BottomActionBarWidget extends StatelessWidget {
  final String skillType;
  final VoidCallback? onSave;
  final VoidCallback? onShare;
  final VoidCallback? onExport;
  final VoidCallback? onIntegrate;

  const BottomActionBarWidget({
    Key? key,
    required this.skillType,
    this.onSave,
    this.onShare,
    this.onExport,
    this.onIntegrate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            border: Border(
                top: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline, width: 1)),
            boxShadow: [
              BoxShadow(blurRadius: 8, offset: const Offset(0, -2)),
            ]),
        child: SafeArea(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _buildActionButtons())));
  }

  List<Widget> _buildActionButtons() {
    switch (skillType) {
      case 'notes':
        return [
          _buildActionButton(icon: 'save', label: 'Save', onPressed: onSave),
          _buildActionButton(icon: 'share', label: 'Share', onPressed: onShare),
          _buildActionButton(
              icon: 'file_download', label: 'Export', onPressed: onExport),
          _buildActionButton(
              icon: 'cloud_sync', label: 'Sync', onPressed: onIntegrate),
        ];
      case 'summarizer':
        return [
          _buildActionButton(
              icon: 'content_copy', label: 'Copy', onPressed: onSave),
          _buildActionButton(icon: 'share', label: 'Share', onPressed: onShare),
          _buildActionButton(
              icon: 'picture_as_pdf', label: 'PDF', onPressed: onExport),
          _buildActionButton(
              icon: 'email', label: 'Email', onPressed: onIntegrate),
        ];
      case 'translator':
        return [
          _buildActionButton(
              icon: 'content_copy', label: 'Copy', onPressed: onSave),
          _buildActionButton(icon: 'share', label: 'Share', onPressed: onShare),
          _buildActionButton(
              icon: 'volume_up', label: 'Speak', onPressed: onExport),
          _buildActionButton(
              icon: 'message', label: 'WhatsApp', onPressed: onIntegrate),
        ];
      case 'task_planner':
        return [
          _buildActionButton(
              icon: 'event', label: 'Calendar', onPressed: onSave),
          _buildActionButton(icon: 'share', label: 'Share', onPressed: onShare),
          _buildActionButton(
              icon: 'notifications', label: 'Remind', onPressed: onExport),
          _buildActionButton(
              icon: 'sync', label: 'Sync', onPressed: onIntegrate),
        ];
      default:
        return [
          _buildActionButton(icon: 'save', label: 'Save', onPressed: onSave),
          _buildActionButton(icon: 'share', label: 'Share', onPressed: onShare),
        ];
    }
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    VoidCallback? onPressed,
  }) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
                color: onPressed != null
                    ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: onPressed != null
                        ? AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.3)
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.5))),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              CustomIconWidget(
                  iconName: icon,
                  color: onPressed != null
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.5),
                  size: 6.w),
              SizedBox(height: 0.5.h),
              Text(label,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: onPressed != null
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.5),
                      fontWeight: FontWeight.w500)),
            ])));
  }
}
