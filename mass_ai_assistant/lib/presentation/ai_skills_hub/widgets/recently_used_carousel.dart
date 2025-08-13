import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentlyUsedCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> recentSkills;
  final Function(Map<String, dynamic>) onSkillTap;

  const RecentlyUsedCarousel({
    Key? key,
    required this.recentSkills,
    required this.onSkillTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recentSkills.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
        margin: EdgeInsets.symmetric(vertical: 2.h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(children: [
                CustomIconWidget(
                    iconName: 'history',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 20),
                SizedBox(width: 2.w),
                Text("Recently Used",
                    style: AppTheme.lightTheme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
              ])),
          SizedBox(height: 1.5.h),
          SizedBox(
              height: 12.h,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: recentSkills.length,
                  itemBuilder: (context, index) {
                    final skill = recentSkills[index];
                    return Container(
                        width: 20.w,
                        margin: EdgeInsets.only(right: 3.w),
                        child: GestureDetector(
                            onTap: () => onSkillTap(skill),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: AppTheme.lightTheme.primaryColor
                                            .withValues(alpha: 0.2),
                                        width: 1),
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppTheme.shadowLight,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2)),
                                    ]),
                                child: Padding(
                                    padding: EdgeInsets.all(2.w),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                              width: 8.w,
                                              height: 4.h,
                                              decoration: BoxDecoration(
                                                  color: AppTheme
                                                      .lightTheme.primaryColor
                                                      .withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              child: Center(
                                                  child: CustomIconWidget(
                                                      iconName: skill["icon"]
                                                          as String,
                                                      color: AppTheme.lightTheme
                                                          .primaryColor,
                                                      size: 16))),
                                          SizedBox(height: 1.h),
                                          Text(skill["name"] as String,
                                              style: AppTheme.lightTheme
                                                  .textTheme.bodySmall
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w500),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis),
                                        ])))));
                  })),
        ]));
  }
}
