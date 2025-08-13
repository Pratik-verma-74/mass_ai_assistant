import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/navigation_button_widget.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';
import './widgets/permission_dialog_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  bool _isLoading = false;
  bool _microphonePermissionGranted = false;
  bool _notificationPermissionGranted = false;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Voice Activated AI Assistant",
      "description":
          "Simply say 'Hey Mass' to activate your intelligent assistant. Experience hands-free interaction with advanced AI technology.",
      "image":
          "https://images.unsplash.com/photo-1589254065878-42c9da997008?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "showTryButton": true,
      "isAnimated": true,
    },
    {
      "title": "Smart Chat Interface",
      "description":
          "Engage in natural conversations with AI. Get instant responses, smart action cards, and contextual assistance for all your needs.",
      "image":
          "https://images.pexels.com/photos/8386440/pexels-photo-8386440.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "showTryButton": false,
      "isAnimated": false,
    },
    {
      "title": "AI Skills Hub",
      "description":
          "Access powerful productivity tools, learning assistance, and business utilities. Your complete AI-powered workspace in one app.",
      "image":
          "https://cdn.pixabay.com/photo/2020/04/08/08/37/artificial-intelligence-5016578_1280.jpg",
      "showTryButton": false,
      "isAnimated": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      HapticFeedback.lightImpact();
    } else {
      _handleGetStarted();
    }
  }

  void _skipOnboarding() {
    HapticFeedback.lightImpact();
    Navigator.pushReplacementNamed(context, '/main-chat-interface');
  }

  void _handleTryVoiceActivation() {
    _showPermissionDialog(
      title: "Microphone Access",
      description:
          "MASS needs microphone access to listen for voice commands and provide voice-activated assistance.",
      iconName: "mic",
      onAllow: () {
        Navigator.of(context).pop();
        setState(() {
          _microphonePermissionGranted = true;
        });
        _simulateVoiceTest();
      },
      onDeny: () {
        Navigator.of(context).pop();
      },
    );
  }

  void _simulateVoiceTest() {
    // Simulate voice recognition test
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.1),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: "mic",
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    size: 10.w,
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                "Listening...",
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                "Say 'Hey Mass' to test",
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
              ),
              SizedBox(height: 3.h),
              SizedBox(
                width: 6.w,
                height: 6.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Simulate successful voice recognition after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop();
      _showVoiceTestSuccess();
    });
  }

  void _showVoiceTestSuccess() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.1),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: "check_circle",
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 8.w,
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                "Voice Test Successful!",
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                "Your voice activation is working perfectly. You can now use 'Hey Mass' to activate the assistant.",
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3.h),
              NavigationButtonWidget(
                text: "Continue",
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleGetStarted() {
    setState(() {
      _isLoading = true;
    });

    // Request notification permission
    _showPermissionDialog(
      title: "Enable Notifications",
      description:
          "Get timely reminders, alerts, and updates from your AI assistant to stay productive and informed.",
      iconName: "notifications",
      onAllow: () {
        Navigator.of(context).pop();
        setState(() {
          _notificationPermissionGranted = true;
          _isLoading = false;
        });
        _navigateToMainInterface();
      },
      onDeny: () {
        Navigator.of(context).pop();
        setState(() {
          _isLoading = false;
        });
        _navigateToMainInterface();
      },
    );
  }

  void _navigateToMainInterface() {
    Navigator.pushReplacementNamed(context, '/main-chat-interface');
  }

  void _showPermissionDialog({
    required String title,
    required String description,
    required String iconName,
    required VoidCallback onAllow,
    required VoidCallback onDeny,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PermissionDialogWidget(
        title: title,
        description: description,
        iconName: iconName,
        onAllow: onAllow,
        onDeny: onDeny,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.05),
                    AppTheme.lightTheme.scaffoldBackgroundColor,
                  ],
                ),
              ),
            ),
            // Skip button
            Positioned(
              top: 2.h,
              right: 4.w,
              child: TextButton(
                onPressed: _skipOnboarding,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                ),
                child: Text(
                  'Skip',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            // Main content
            Column(
              children: [
                SizedBox(height: 8.h),
                // PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                      HapticFeedback.selectionClick();
                    },
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      final data = _onboardingData[index];
                      return OnboardingPageWidget(
                        title: data["title"],
                        description: data["description"],
                        imagePath: data["image"],
                        showTryButton: data["showTryButton"],
                        isAnimated: data["isAnimated"],
                        onTryPressed: _handleTryVoiceActivation,
                      );
                    },
                  ),
                ),
                // Bottom navigation area
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                  child: Column(
                    children: [
                      // Page indicators
                      PageIndicatorWidget(
                        currentPage: _currentPage,
                        totalPages: _onboardingData.length,
                      ),
                      SizedBox(height: 4.h),
                      // Navigation button
                      NavigationButtonWidget(
                        text: _currentPage == _onboardingData.length - 1
                            ? 'Get Started'
                            : 'Next',
                        onPressed: _nextPage,
                        isLoading: _isLoading,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
