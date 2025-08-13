import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './skill_tile_widget.dart';

class FavoritesSection extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteSkills;
  final Function(Map<String, dynamic>) onSkillTap;
  final Function(Map<String, dynamic>) onSkillLongPress;

  const FavoritesSection({
    Key? key,
    required this.favoriteSkills,
    required this.onSkillTap,
    required this.onSkillLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (favoriteSkills.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ]),
        child: Padding(
            padding: EdgeInsets.all(4.w),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                CustomIconWidget(iconName: 'favorite', size: 20),
                SizedBox(width: 2.w),
                Text("Favorites",
                    style: AppTheme.lightTheme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const Spacer(),
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    child: Text("${favoriteSkills.length}",
                        style: AppTheme.lightTheme.textTheme.bodySmall
                            ?.copyWith(fontWeight: FontWeight.w600))),
              ]),
              SizedBox(height: 2.h),
              GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 3.w,
                      mainAxisSpacing: 2.h,
                      childAspectRatio: 1.2),
                  itemCount: favoriteSkills.length,
                  itemBuilder: (context, index) {
                    return SkillTileWidget(
                        skill: favoriteSkills[index],
                        onTap: () => onSkillTap(favoriteSkills[index]),
                        onLongPress: () =>
                            onSkillLongPress(favoriteSkills[index]));
                  }),
            ])));
  }
}
