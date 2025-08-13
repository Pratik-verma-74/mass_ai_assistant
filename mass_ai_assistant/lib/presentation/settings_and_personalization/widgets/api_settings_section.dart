import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../services/groq_api_service.dart';

class ApiSettingsSection extends StatefulWidget {
  const ApiSettingsSection({Key? key}) : super(key: key);

  @override
  State<ApiSettingsSection> createState() => _ApiSettingsSectionState();
}

class _ApiSettingsSectionState extends State<ApiSettingsSection> {
  bool _isExpanded = false;
  bool _isObscured = true;
  bool _isLoading = false;
  bool _isConnected = false;

  final TextEditingController _apiKeyController = TextEditingController();
  final GroqApiService _groqService = GroqApiService();

  @override
  void initState() {
    super.initState();
    _loadCurrentApiKey();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentApiKey() async {
    final apiKey = await _groqService.getApiKey();
    if (apiKey != null) {
      setState(() {
        _apiKeyController.text = apiKey;
        _isConnected = true;
      });
    }
  }

  Future<void> _testConnection() async {
    if (_apiKeyController.text.trim().isEmpty) {
      _showMessage('Please enter your Groq API key first', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _groqService.setApiKey(_apiKeyController.text);
      // Test with a simple message
      await _groqService.generateResponse('Hello');

      setState(() {
        _isConnected = true;
        _isLoading = false;
      });

      _showMessage('Successfully connected to Groq API!');
    } catch (e) {
      setState(() {
        _isConnected = false;
        _isLoading = false;
      });

      String errorMessage = 'Connection failed';
      if (e.toString().contains('Invalid')) {
        errorMessage = 'Invalid API key. Please check your key.';
      } else if (e.toString().contains('Rate limit')) {
        errorMessage = 'Rate limit exceeded. Please try again later.';
      }

      _showMessage(errorMessage, isError: true);
    }
  }

  Future<void> _saveApiKey() async {
    if (_apiKeyController.text.trim().isEmpty) {
      _showMessage('Please enter your Groq API key', isError: true);
      return;
    }

    try {
      await _groqService.setApiKey(_apiKeyController.text);
      _showMessage('API key saved successfully!');
    } catch (e) {
      _showMessage('Failed to save API key', isError: true);
    }
  }

  Future<void> _clearApiKey() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear API Key'),
        content: const Text(
            'Are you sure you want to remove your Groq API key? This will disable AI functionality.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _groqService.clearApiKey();
              setState(() {
                _apiKeyController.clear();
                _isConnected = false;
              });
              Navigator.pop(context);
              _showMessage('API key cleared');
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: AppTheme.errorLight),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: isError ? 'error' : 'check_circle',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? AppTheme.errorLight : AppTheme.successLight,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'About Groq API',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Groq provides ultra-fast AI inference with their specialized hardware. Get your free API key from console.groq.com',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.8),
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            '• Fast response times\n• Multiple model options\n• Free tier available',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
          ),
        ],
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
              iconName: 'api',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            title: Text(
              'AI Provider Settings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle:
                Text(_isConnected ? 'Connected to Groq' : 'Not configured'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isConnected)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.successLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: Colors.white,
                          size: 12,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Connected',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(width: 2.w),
                CustomIconWidget(
                  iconName: _isExpanded ? 'expand_less' : 'expand_more',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ],
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
                  _buildInfoCard(),
                  Text(
                    'Groq API Key',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: 1.h),
                  TextField(
                    controller: _apiKeyController,
                    obscureText: _isObscured,
                    decoration: InputDecoration(
                      hintText: 'Enter your Groq API key (gsk_...)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                            icon: CustomIconWidget(
                              iconName:
                                  _isObscured ? 'visibility' : 'visibility_off',
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                              size: 20,
                            ),
                          ),
                          IconButton(
                            onPressed: _apiKeyController.text.isNotEmpty
                                ? _clearApiKey
                                : null,
                            icon: CustomIconWidget(
                              iconName: 'clear',
                              color: AppTheme.errorLight,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveApiKey,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.lightTheme.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Save Key'),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _testConnection,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.successLight,
                            foregroundColor: Colors.white,
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 4.w,
                                  height: 4.w,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text('Test Connection'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.warningLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.warningLight.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'security',
                          color: AppTheme.warningLight,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            'Your API key is stored locally and securely on your device.',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.warningLight,
                                    ),
                          ),
                        ),
                      ],
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
