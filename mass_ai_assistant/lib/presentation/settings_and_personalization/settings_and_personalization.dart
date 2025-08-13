import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ai_personality_section.dart';
import './widgets/api_settings_section.dart';
import './widgets/appearance_settings_section.dart';
import './widgets/integration_settings_section.dart';
import './widgets/notification_settings_section.dart';
import './widgets/privacy_settings_section.dart';
import './widgets/reset_options_section.dart';
import './widgets/voice_settings_section.dart';

class SettingsAndPersonalization extends StatefulWidget {
  const SettingsAndPersonalization({Key? key}) : super(key: key);

  @override
  State<SettingsAndPersonalization> createState() =>
      _SettingsAndPersonalizationState();
}

class _SettingsAndPersonalizationState extends State<SettingsAndPersonalization>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Settings state variables
  String _currentWakeWord = 'Hey Mass';
  String _currentVoice = 'Female';
  String _currentLanguage = 'English';
  double _microphoneSensitivity = 0.7;
  String _aiPersonality = 'Professional';
  ThemeMode _themeMode = ThemeMode.system;
  Color _accentColor = const Color(0xFF00E5FF);
  double _animationIntensity = 0.8;
  bool _localProcessing = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleWakeWordChanged(String wakeWord) {
    setState(() {
      _currentWakeWord = wakeWord;
    });
    // Save to preferences
    _showSettingsSaved('Wake word updated to "$wakeWord"');
  }

  void _handleVoiceChanged(String voice) {
    setState(() {
      _currentVoice = voice;
    });
    _showSettingsSaved('Voice changed to $voice');
  }

  void _handleLanguageChanged(String language) {
    setState(() {
      _currentLanguage = language;
    });
    _showSettingsSaved('Language changed to $language');
  }

  void _handleSensitivityChanged(double sensitivity) {
    setState(() {
      _microphoneSensitivity = sensitivity;
    });
  }

  void _handlePersonalityChanged(String personality) {
    setState(() {
      _aiPersonality = personality;
    });
    _showSettingsSaved('AI personality set to $personality');
  }

  void _handleThemeModeChanged(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
    _showSettingsSaved('Theme mode updated');
  }

  void _handleAccentColorChanged(Color color) {
    setState(() {
      _accentColor = color;
    });
    _showSettingsSaved('Accent color updated');
  }

  void _handleAnimationIntensityChanged(double intensity) {
    setState(() {
      _animationIntensity = intensity;
    });
  }

  void _handleLocalProcessingChanged(bool enabled) {
    setState(() {
      _localProcessing = enabled;
    });
    _showSettingsSaved(
        enabled ? 'Local processing enabled' : 'Local processing disabled');
  }

  void _handleDeleteData() {
    // Handle voice data deletion
    _showSettingsSaved('Voice data deleted successfully');
  }

  void _handleIntegrationToggled(String integration, bool connected) {
    _showSettingsSaved(connected
        ? 'Connected to $integration'
        : 'Disconnected from $integration');
  }

  void _handleNotificationToggled(String type, bool enabled) {
    _showSettingsSaved(
        '${type.toUpperCase()} notifications ${enabled ? 'enabled' : 'disabled'}');
  }

  void _handleQuietHoursChanged(TimeOfDay start, TimeOfDay end) {
    _showSettingsSaved('Quiet hours updated');
  }

  void _handleVoiceFeedbackChanged(bool enabled) {
    _showSettingsSaved('Voice feedback ${enabled ? 'enabled' : 'disabled'}');
  }

  void _handleResetSettings() {
    setState(() {
      _currentWakeWord = 'Hey Mass';
      _currentVoice = 'Female';
      _currentLanguage = 'English';
      _microphoneSensitivity = 0.7;
      _aiPersonality = 'Professional';
      _themeMode = ThemeMode.system;
      _accentColor = const Color(0xFF00E5FF);
      _animationIntensity = 0.8;
      _localProcessing = true;
    });
  }

  void _handleExportSettings() {
    // Handle settings export
    _showSettingsSaved('Settings exported successfully');
  }

  void _handleImportSettings() {
    // Handle settings import
    _showSettingsSaved('Settings imported successfully');
  }

  void _showSettingsSaved(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppTheme.successLight,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 1.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.primaryColor,
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    'Settings & Personalization',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'settings',
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              'Customize Mass to match your preferences and workflow',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Configuration',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Wake Word',
                  _currentWakeWord,
                  'mic',
                  AppTheme.lightTheme.primaryColor,
                ),
              ),
              Container(
                width: 1,
                height: 6.h,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
              Expanded(
                child: _buildStatItem(
                  'Voice',
                  _currentVoice,
                  'record_voice_over',
                  AppTheme.secondaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Language',
                  _currentLanguage,
                  'language',
                  AppTheme.successLight,
                ),
              ),
              Container(
                width: 1,
                height: 6.h,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
              Expanded(
                child: _buildStatItem(
                  'Personality',
                  _aiPersonality,
                  'psychology',
                  AppTheme.warningLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, String iconName, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: 1.h),
                          _buildQuickStats(),
                          SizedBox(height: 1.h),

                          // Voice Settings Section
                          VoiceSettingsSection(
                            onWakeWordChanged: _handleWakeWordChanged,
                            onVoiceChanged: _handleVoiceChanged,
                            onLanguageChanged: _handleLanguageChanged,
                            onSensitivityChanged: _handleSensitivityChanged,
                          ),

                          // AI Personality Section
                          AiPersonalitySection(
                            onPersonalityChanged: _handlePersonalityChanged,
                          ),

                          // API Settings Section
                          const ApiSettingsSection(),

                          // Appearance Settings Section
                          AppearanceSettingsSection(
                            onThemeModeChanged: _handleThemeModeChanged,
                            onAccentColorChanged: _handleAccentColorChanged,
                            onAnimationIntensityChanged:
                                _handleAnimationIntensityChanged,
                          ),

                          // Privacy Settings Section
                          PrivacySettingsSection(
                            onLocalProcessingChanged:
                                _handleLocalProcessingChanged,
                            onDeleteData: _handleDeleteData,
                          ),

                          // Integration Settings Section
                          IntegrationSettingsSection(
                            onIntegrationToggled: _handleIntegrationToggled,
                          ),

                          // Notification Settings Section
                          NotificationSettingsSection(
                            onNotificationToggled: _handleNotificationToggled,
                            onQuietHoursChanged: _handleQuietHoursChanged,
                            onVoiceFeedbackChanged: _handleVoiceFeedbackChanged,
                          ),

                          // Reset Options Section
                          ResetOptionsSection(
                            onResetSettings: _handleResetSettings,
                            onExportSettings: _handleExportSettings,
                            onImportSettings: _handleImportSettings,
                          ),

                          SizedBox(height: 4.h),

                          // Footer
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.primaryColor
                                  .withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppTheme.lightTheme.primaryColor
                                    .withValues(alpha: 0.1),
                              ),
                            ),
                            child: Column(
                              children: [
                                CustomIconWidget(
                                  iconName: 'smart_toy',
                                  color: AppTheme.lightTheme.primaryColor,
                                  size: 32,
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  'MASS AI Assistant',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: AppTheme.lightTheme.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                Text(
                                  'Version 1.0.0 • Built with ❤️ for productivity',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface
                                            .withValues(alpha: 0.7),
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 2.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
