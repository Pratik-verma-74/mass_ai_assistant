import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SkillTileWidget extends StatefulWidget {
  final Map<String, dynamic> skill;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const SkillTileWidget({
    Key? key,
    required this.skill,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  State<SkillTileWidget> createState() => _SkillTileWidgetState();
}

class _SkillTileWidgetState extends State<SkillTileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
              scale: _scaleAnimation.value,
              child: GestureDetector(
                  onTap: widget.onTap,
                  onLongPress: widget.onLongPress,
                  onTapDown: _onTapDown,
                  onTapUp: _onTapUp,
                  onTapCancel: _onTapCancel,
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppTheme.dividerLight, width: 1),
                          boxShadow: [
                            BoxShadow(
                                color: AppTheme.shadowLight,
                                blurRadius: 4,
                                offset: const Offset(0, 2)),
                          ]),
                      child: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: 10.w,
                                    height: 5.h,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Center(
                                        child: CustomIconWidget(
                                            iconName:
                                                widget.skill["icon"] as String,
                                            size: 20))),
                                SizedBox(height: 1.h),
                                Text(widget.skill["name"] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                SizedBox(height: 0.5.h),
                                Text(widget.skill["description"] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                            color: AppTheme
                                                .textMediumEmphasisLight),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                              ])))));
        });
  }
}
