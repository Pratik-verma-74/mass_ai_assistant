import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class VoiceSettingsSection extends StatefulWidget {
  final Function(String) onWakeWordChanged;
  final Function(String) onVoiceChanged;
  final Function(String) onLanguageChanged;
  final Function(double) onSensitivityChanged;

  const VoiceSettingsSection({
    Key? key,
    required this.onWakeWordChanged,
    required this.onVoiceChanged,
    required this.onLanguageChanged,
    required this.onSensitivityChanged,
  }) : super(key: key);

  @override
  State<VoiceSettingsSection> createState() => _VoiceSettingsSectionState();
}

class _VoiceSettingsSectionState extends State<VoiceSettingsSection> {
  String _selectedWakeWord = 'Hey Mass';
  String _selectedVoice = 'Female';
  String _selectedLanguage = 'English';
  double _microphoneSensitivity = 0.7;
  bool _isExpanded = false;

  final List<String> _wakeWordOptions = [
    'Hey Mass',
    'Hello Mass',
    'Mass Assistant',
    'AI Mass',
  ];

  final List<String> _voiceOptions = [
    'Female',
    'Male',
  ];

  final List<String> _languageOptions = [
    'English',
    'Hindi',
    'Tamil',
    'Telugu',
    'Bengali',
    'Marathi',
  ];

  void _playVoicePreview() {
    // Voice preview functionality would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Playing preview: "$_selectedWakeWord" in $_selectedVoice voice ($_selectedLanguage)'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        children: [
          ListTile(
            leading: CustomIconWidget(
              iconName: 'mic',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            title: Text(
              'Voice Settings',
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
                  // Wake Word Selection
                  Text(
                    'Wake Word',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedWakeWord,
                        isExpanded: true,
                        items: _wakeWordOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedWakeWord = newValue;
                            });
                            widget.onWakeWordChanged(newValue);
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // Voice Selection
                  Text(
                    'Voice Type',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: _voiceOptions.map((voice) {
                      final isSelected = _selectedVoice == voice;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: voice != _voiceOptions.last ? 2.w : 0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedVoice = voice;
                              });
                              widget.onVoiceChanged(voice);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 1.5.h),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.lightTheme.primaryColor
                                        .withValues(alpha: 0.1)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.lightTheme.primaryColor
                                      : AppTheme.lightTheme.colorScheme.outline,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomIconWidget(
                                    iconName: voice == 'Female'
                                        ? 'person'
                                        : 'person_outline',
                                    color: isSelected
                                        ? AppTheme.lightTheme.primaryColor
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                    size: 20,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    voice,
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppTheme.lightTheme.primaryColor
                                          : AppTheme
                                              .lightTheme.colorScheme.onSurface,
                                      fontWeight: isSelected
                                          ? FontWeight.w500
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 2.h),

                  // Language Selection
                  Text(
                    'Language',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedLanguage,
                        isExpanded: true,
                        items: _languageOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedLanguage = newValue;
                            });
                            widget.onLanguageChanged(newValue);
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // Microphone Sensitivity
                  Text(
                    'Microphone Sensitivity',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'mic_off',
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                        size: 20,
                      ),
                      Expanded(
                        child: Slider(
                          value: _microphoneSensitivity,
                          min: 0.1,
                          max: 1.0,
                          divisions: 9,
                          label: '${(_microphoneSensitivity * 100).round()}%',
                          onChanged: (double value) {
                            setState(() {
                              _microphoneSensitivity = value;
                            });
                            widget.onSensitivityChanged(value);
                          },
                        ),
                      ),
                      CustomIconWidget(
                        iconName: 'mic',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 20,
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // Voice Preview Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _playVoicePreview,
                      icon: CustomIconWidget(
                        iconName: 'play_arrow',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 20,
                      ),
                      label: const Text('Preview Voice'),
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
