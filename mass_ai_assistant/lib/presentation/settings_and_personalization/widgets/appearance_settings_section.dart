import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class AppearanceSettingsSection extends StatefulWidget {
  final Function(ThemeMode) onThemeModeChanged;
  final Function(Color) onAccentColorChanged;
  final Function(double) onAnimationIntensityChanged;

  const AppearanceSettingsSection({
    Key? key,
    required this.onThemeModeChanged,
    required this.onAccentColorChanged,
    required this.onAnimationIntensityChanged,
  }) : super(key: key);

  @override
  State<AppearanceSettingsSection> createState() =>
      _AppearanceSettingsSectionState();
}

class _AppearanceSettingsSectionState extends State<AppearanceSettingsSection> {
  ThemeMode _selectedThemeMode = ThemeMode.system;
  Color _selectedAccentColor = const Color(0xFF00E5FF);
  double _animationIntensity = 0.8;
  bool _isExpanded = false;

  final List<Map<String, dynamic>> _themeModeOptions = [
    {
      'mode': ThemeMode.light,
      'title': 'Light',
      'icon': 'light_mode',
      'description': 'Clean and bright interface',
    },
    {
      'mode': ThemeMode.dark,
      'title': 'Dark',
      'icon': 'dark_mode',
      'description': 'Easy on the eyes, saves battery',
    },
    {
      'mode': ThemeMode.system,
      'title': 'System',
      'icon': 'settings_brightness',
      'description': 'Follows device settings',
    },
  ];

  final List<Color> _accentColors = [
    const Color(0xFF00E5FF), // Cyan
    const Color(0xFF1A237E), // Deep Indigo
    const Color(0xFF4CAF50), // Green
    const Color(0xFFFF9800), // Orange
    const Color(0xFFF44336), // Red
    const Color(0xFF9C27B0), // Purple
    const Color(0xFF2196F3), // Blue
    const Color(0xFFE91E63), // Pink
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        children: [
          ListTile(
            leading: CustomIconWidget(
              iconName: 'palette',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            title: Text(
              'Appearance',
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
                  // Theme Mode Selection
                  Text(
                    'Theme Mode',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: 1.h),
                  ..._themeModeOptions.map((option) {
                    final isSelected = _selectedThemeMode == option['mode'];
                    return Container(
                      margin: EdgeInsets.only(bottom: 1.h),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedThemeMode = option['mode'];
                          });
                          widget.onThemeModeChanged(option['mode']);
                        },
                        child: Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.lightTheme.primaryColor
                                    .withValues(alpha: 0.1)
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.lightTheme.primaryColor
                                  : AppTheme.lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.3),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: option['icon'],
                                color: isSelected
                                    ? AppTheme.lightTheme.primaryColor
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                                size: 24,
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      option['title'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            color: isSelected
                                                ? AppTheme
                                                    .lightTheme.primaryColor
                                                : AppTheme.lightTheme
                                                    .colorScheme.onSurface,
                                          ),
                                    ),
                                    Text(
                                      option['description'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppTheme.lightTheme
                                                .colorScheme.onSurface
                                                .withValues(alpha: 0.7),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                CustomIconWidget(
                                  iconName: 'check_circle',
                                  color: AppTheme.lightTheme.primaryColor,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 2.h),

                  // Accent Color Selection
                  Text(
                    'Accent Color',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 3.w,
                    runSpacing: 1.h,
                    children: _accentColors.map((color) {
                      final isSelected = _selectedAccentColor == color;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedAccentColor = color;
                          });
                          widget.onAccentColorChanged(color);
                        },
                        child: Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.onSurface
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: isSelected
                              ? Center(
                                  child: CustomIconWidget(
                                    iconName: 'check',
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 2.h),

                  // Animation Intensity
                  Text(
                    'Animation Intensity',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'motion_photos_off',
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                        size: 20,
                      ),
                      Expanded(
                        child: Slider(
                          value: _animationIntensity,
                          min: 0.1,
                          max: 1.0,
                          divisions: 9,
                          label: _animationIntensity == 0.1
                              ? 'Minimal'
                              : _animationIntensity <= 0.5
                                  ? 'Reduced'
                                  : _animationIntensity <= 0.8
                                      ? 'Normal'
                                      : 'Enhanced',
                          onChanged: (double value) {
                            setState(() {
                              _animationIntensity = value;
                            });
                            widget.onAnimationIntensityChanged(value);
                          },
                        ),
                      ),
                      CustomIconWidget(
                        iconName: 'motion_photos_on',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 20,
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Controls the intensity of UI animations and transitions',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
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
