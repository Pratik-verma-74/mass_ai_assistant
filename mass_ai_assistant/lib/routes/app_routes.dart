import 'package:flutter/material.dart';
import '../presentation/main_chat_interface/main_chat_interface.dart';
import '../presentation/voice_command_mode/voice_command_mode.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/settings_and_personalization/settings_and_personalization.dart';
import '../presentation/ai_skills_hub/ai_skills_hub.dart';
import '../presentation/individual_skill_screen/individual_skill_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String mainChatInterface = '/main-chat-interface';
  static const String voiceCommandMode = '/voice-command-mode';
  static const String onboardingFlow = '/onboarding-flow';
  static const String settingsAndPersonalization =
      '/settings-and-personalization';
  static const String aiSkillsHub = '/ai-skills-hub';
  static const String individualSkill = '/individual-skill-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const OnboardingFlow(),
    mainChatInterface: (context) => const MainChatInterface(),
    voiceCommandMode: (context) => const VoiceCommandMode(),
    onboardingFlow: (context) => const OnboardingFlow(),
    settingsAndPersonalization: (context) => const SettingsAndPersonalization(),
    aiSkillsHub: (context) => const AiSkillsHub(),
    individualSkill: (context) => const IndividualSkillScreen(),
    // TODO: Add your other routes here
  };
}
