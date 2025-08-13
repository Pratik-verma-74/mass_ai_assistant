import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OnboardingPageWidget extends StatefulWidget {
  final String title;
  final String description;
  final String imagePath;
  final bool showTryButton;
  final VoidCallback? onTryPressed;
  final bool isAnimated;

  const OnboardingPageWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.showTryButton = false,
    this.onTryPressed,
    this.isAnimated = false,
  }) : super(key: key);

  @override
  State<OnboardingPageWidget> createState() => _OnboardingPageWidgetState();
}

class _OnboardingPageWidgetState extends State<OnboardingPageWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));

    if (widget.isAnimated) {
      _pulseController.repeat(reverse: true);
      _waveController.repeat();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: 80.w,
              constraints: BoxConstraints(maxHeight: 40.h),
              child: widget.isAnimated
                  ? _buildAnimatedImage()
                  : _buildStaticImage(),
            ),
          ),
          SizedBox(height: 4.h),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  widget.description,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.showTryButton) ...[
                  SizedBox(height: 3.h),
                  _buildTryButton(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedImage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Animated wave rings
        AnimatedBuilder(
          animation: _waveAnimation,
          builder: (context, child) {
            return Container(
              width: 60.w * (1 + _waveAnimation.value * 0.5),
              height: 60.w * (1 + _waveAnimation.value * 0.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.secondary.withValues(
                    alpha: 0.3 * (1 - _waveAnimation.value),
                  ),
                  width: 2,
                ),
              ),
            );
          },
        ),
        // Pulsing main image
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.lightTheme.colorScheme.secondary
                          .withValues(alpha: 0.2),
                      AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: Center(
                  child: CustomImageWidget(
                    imageUrl: widget.imagePath,
                    width: 30.w,
                    height: 30.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStaticImage() {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Center(
        child: CustomImageWidget(
          imageUrl: widget.imagePath,
          width: 35.w,
          height: 35.w,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildTryButton() {
    return Container(
      width: 40.w,
      height: 6.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.colorScheme.secondary,
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.secondary
                .withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTryPressed,
          borderRadius: BorderRadius.circular(25),
          child: Center(
            child: Text(
              'Try It',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
