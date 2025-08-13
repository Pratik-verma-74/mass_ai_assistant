import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ListeningStatusWidget extends StatefulWidget {
  final bool isListening;
  final String statusText;
  final VoidCallback? onCancel;

  const ListeningStatusWidget({
    Key? key,
    required this.isListening,
    required this.statusText,
    this.onCancel,
  }) : super(key: key);

  @override
  State<ListeningStatusWidget> createState() => _ListeningStatusWidgetState();
}

class _ListeningStatusWidgetState extends State<ListeningStatusWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isListening) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(ListeningStatusWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening != oldWidget.isListening) {
      widget.isListening
          ? _animationController.repeat(reverse: true)
          : _animationController.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: widget.isListening ? _fadeAnimation.value : 1.0,
                  child: Row(
                    children: [
                      if (widget.isListening) ...[
                        Container(
                          width: 3.w,
                          height: 3.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? AppTheme.secondaryDark
                                : AppTheme.secondaryLight,
                          ),
                        ),
                        SizedBox(width: 3.w),
                      ],
                      Flexible(
                        child: Text(
                          widget.statusText,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: isDark
                                    ? AppTheme.textHighEmphasisDark
                                    : AppTheme.textHighEmphasisLight,
                                fontWeight: FontWeight.w500,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (widget.onCancel != null)
            GestureDetector(
              onTap: widget.onCancel,
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isDark
                          ? AppTheme.textMediumEmphasisDark
                          : AppTheme.textMediumEmphasisLight)
                      .withValues(alpha: 0.1),
                ),
                child: CustomIconWidget(
                  iconName: 'close',
                  color: isDark
                      ? AppTheme.textMediumEmphasisDark
                      : AppTheme.textMediumEmphasisLight,
                  size: 6.w,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
