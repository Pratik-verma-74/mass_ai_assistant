import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SkillOptionsModal extends StatelessWidget {
  final Map<String, dynamic> skill;
  final Function(String) onOptionSelected;

  const SkillOptionsModal({
    Key? key,
    required this.skill,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                  color: AppTheme.dividerLight,
                  borderRadius: BorderRadius.circular(2))),
          SizedBox(height: 3.h),
          Row(children: [
            Container(
                width: 12.w,
                height: 6.h,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: Center(
                    child: CustomIconWidget(
                        iconName: skill["icon"] as String, size: 24))),
            SizedBox(width: 3.w),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(skill["name"] as String,
                      style: AppTheme.lightTheme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(height: 0.5.h),
                  Text(skill["description"] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall
                          ?.copyWith(color: AppTheme.textMediumEmphasisLight),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ])),
          ]),
          SizedBox(height: 3.h),
          _buildOptionTile(
              icon: 'favorite_border',
              title: "Add to Favorites",
              onTap: () => onOptionSelected('favorite')),
          _buildOptionTile(
              icon: 'shortcut',
              title: "Create Shortcut",
              onTap: () => onOptionSelected('shortcut')),
          _buildOptionTile(
              icon: 'share',
              title: "Share",
              onTap: () => onOptionSelected('share')),
          _buildOptionTile(
              icon: 'info_outline',
              title: "View Details",
              onTap: () => onOptionSelected('details')),
          SizedBox(height: 2.h),
          SizedBox(
              width: double.infinity,
              child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: Text("Cancel",
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.textMediumEmphasisLight)))),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ]));
  }

  Widget _buildOptionTile({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
            child: Row(children: [
              CustomIconWidget(
                  iconName: icon,
                  color: AppTheme.textHighEmphasisLight,
                  size: 20),
              SizedBox(width: 4.w),
              Text(title,
                  style: AppTheme.lightTheme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500)),
              const Spacer(),
              CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.textMediumEmphasisLight,
                  size: 16),
            ])));
  }
}
