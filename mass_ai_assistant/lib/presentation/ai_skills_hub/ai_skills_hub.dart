import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/favorites_section.dart';
import './widgets/recently_used_carousel.dart';
import './widgets/search_bar_widget.dart';
import './widgets/skill_category_card.dart';
import './widgets/skill_options_modal.dart';

class AiSkillsHub extends StatefulWidget {
  const AiSkillsHub({Key? key}) : super(key: key);

  @override
  State<AiSkillsHub> createState() => _AiSkillsHubState();
}

class _AiSkillsHubState extends State<AiSkillsHub> {
  String _searchQuery = '';
  bool _isRefreshing = false;

  final List<Map<String, dynamic>> _skillCategories = [
    {
      "id": "productivity",
      "title": "Productivity",
      "icon": "work",
      "skills": [
        {
          "id": "notes",
          "name": "Smart Notes",
          "description": "AI-powered note taking",
          "icon": "note_add",
          "route": "/individual-skill-screen"
        },
        {
          "id": "summarizer",
          "name": "Summarizer",
          "description": "Summarize documents",
          "icon": "summarize",
          "route": "/individual-skill-screen"
        },
        {
          "id": "task_planner",
          "name": "Task Planner",
          "description": "Plan your daily tasks",
          "icon": "task_alt",
          "route": "/individual-skill-screen"
        },
        {
          "id": "email_draft",
          "name": "Email Draft",
          "description": "Generate email drafts",
          "icon": "email",
          "route": "/individual-skill-screen"
        }
      ]
    },
    {
      "id": "learning",
      "title": "Learning",
      "icon": "school",
      "skills": [
        {
          "id": "translator",
          "name": "Translator",
          "description": "Multi-language translation",
          "icon": "translate",
          "route": "/individual-skill-screen"
        },
        {
          "id": "quiz_maker",
          "name": "Quiz Maker",
          "description": "Create learning quizzes",
          "icon": "quiz",
          "route": "/individual-skill-screen"
        },
        {
          "id": "study_guide",
          "name": "Study Guide",
          "description": "Generate study materials",
          "icon": "menu_book",
          "route": "/individual-skill-screen"
        },
        {
          "id": "flashcards",
          "name": "Flashcards",
          "description": "Create digital flashcards",
          "icon": "style",
          "route": "/individual-skill-screen"
        }
      ]
    },
    {
      "id": "business",
      "title": "Business Tools",
      "icon": "business_center",
      "skills": [
        {
          "id": "data_analysis",
          "name": "Data Analysis",
          "description": "Analyze business data",
          "icon": "analytics",
          "route": "/individual-skill-screen"
        },
        {
          "id": "meeting_summary",
          "name": "Meeting Summary",
          "description": "Summarize meetings",
          "icon": "groups",
          "route": "/individual-skill-screen"
        },
        {
          "id": "report_generator",
          "name": "Report Generator",
          "description": "Generate business reports",
          "icon": "assessment",
          "route": "/individual-skill-screen"
        },
        {
          "id": "presentation",
          "name": "Presentation",
          "description": "Create presentations",
          "icon": "slideshow",
          "route": "/individual-skill-screen"
        }
      ]
    },
    {
      "id": "daily_assistant",
      "title": "Daily Assistant",
      "icon": "assistant",
      "skills": [
        {
          "id": "calendar_integration",
          "name": "Calendar",
          "description": "Manage your schedule",
          "icon": "calendar_today",
          "route": "/individual-skill-screen"
        },
        {
          "id": "whatsapp_integration",
          "name": "WhatsApp",
          "description": "Quick messaging",
          "icon": "message",
          "route": "/individual-skill-screen"
        },
        {
          "id": "web_search",
          "name": "Web Search",
          "description": "Smart web searches",
          "icon": "search",
          "route": "/individual-skill-screen"
        },
        {
          "id": "reminders",
          "name": "Reminders",
          "description": "Set smart reminders",
          "icon": "alarm",
          "route": "/individual-skill-screen"
        }
      ]
    }
  ];

  final List<Map<String, dynamic>> _recentlyUsedSkills = [
    {
      "id": "notes",
      "name": "Smart Notes",
      "description": "AI-powered note taking",
      "icon": "note_add",
      "route": "/individual-skill-screen"
    },
    {
      "id": "translator",
      "name": "Translator",
      "description": "Multi-language translation",
      "icon": "translate",
      "route": "/individual-skill-screen"
    },
    {
      "id": "summarizer",
      "name": "Summarizer",
      "description": "Summarize documents",
      "icon": "summarize",
      "route": "/individual-skill-screen"
    },
    {
      "id": "calendar_integration",
      "name": "Calendar",
      "description": "Manage your schedule",
      "icon": "calendar_today",
      "route": "/individual-skill-screen"
    }
  ];

  final List<Map<String, dynamic>> _favoriteSkills = [
    {
      "id": "notes",
      "name": "Smart Notes",
      "description": "AI-powered note taking",
      "icon": "note_add",
      "route": "/individual-skill-screen"
    },
    {
      "id": "task_planner",
      "name": "Task Planner",
      "description": "Plan your daily tasks",
      "icon": "task_alt",
      "route": "/individual-skill-screen"
    }
  ];

  List<Map<String, dynamic>> get _filteredCategories {
    if (_searchQuery.isEmpty) {
      return _skillCategories;
    }

    return _skillCategories
        .map((category) {
          final filteredSkills =
              (category["skills"] as List<Map<String, dynamic>>)
                  .where((skill) =>
                      (skill["name"] as String)
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()) ||
                      (skill["description"] as String)
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()))
                  .toList();

          return {
            ...category,
            "skills": filteredSkills,
          };
        })
        .where((category) => (category["skills"] as List).isNotEmpty)
        .toList();
  }

  List<Map<String, dynamic>> get _searchResults {
    if (_searchQuery.isEmpty) return [];

    final List<Map<String, dynamic>> results = [];
    for (final category in _skillCategories) {
      final skills = (category["skills"] as List<Map<String, dynamic>>)
          .where((skill) =>
              (skill["name"] as String)
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              (skill["description"] as String)
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
      results.addAll(skills);
    }
    return results;
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call to refresh skills
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _handleSkillTap(Map<String, dynamic> skill) {
    Navigator.pushNamed(context, skill["route"] as String);
  }

  void _handleSkillLongPress(Map<String, dynamic> skill) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SkillOptionsModal(
        skill: skill,
        onOptionSelected: (option) {
          Navigator.pop(context);
          _handleSkillOption(skill, option);
        },
      ),
    );
  }

  void _handleSkillOption(Map<String, dynamic> skill, String option) {
    switch (option) {
      case 'favorite':
        setState(() {
          final isAlreadyFavorite =
              _favoriteSkills.any((fav) => fav["id"] == skill["id"]);
          if (isAlreadyFavorite) {
            _favoriteSkills.removeWhere((fav) => fav["id"] == skill["id"]);
          } else {
            _favoriteSkills.add(skill);
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _favoriteSkills.any((fav) => fav["id"] == skill["id"])
                  ? "Added to favorites"
                  : "Removed from favorites",
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        break;
      case 'shortcut':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Shortcut created on home screen"),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 'share':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Sharing ${skill["name"]}..."),
            duration: const Duration(seconds: 2),
          ),
        );
        break;
      case 'details':
        Navigator.pushNamed(context, skill["route"] as String);
        break;
    }
  }

  void _handleVoiceSearch() {
    Navigator.pushNamed(context, '/voice-command-mode');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.textHighEmphasisLight,
            size: 24,
          ),
        ),
        title: Text(
          "AI Skills Hub",
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/settings-and-personalization'),
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.textHighEmphasisLight,
              size: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.primaryColor,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SearchBarWidget(
                  onSearchChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                  onVoiceSearch: _handleVoiceSearch,
                ),
              ),
              if (_searchQuery.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    child: Text(
                      _searchResults.isEmpty
                          ? "No skills found for '$_searchQuery'"
                          : "${_searchResults.length} skills found",
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textMediumEmphasisLight,
                      ),
                    ),
                  ),
                ),
                if (_searchResults.isEmpty)
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        children: [
                          CustomIconWidget(
                            iconName: 'search_off',
                            color: AppTheme.textDisabledLight,
                            size: 48,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "Try searching for:",
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              color: AppTheme.textMediumEmphasisLight,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Wrap(
                            spacing: 2.w,
                            runSpacing: 1.h,
                            children: [
                              "Notes",
                              "Translator",
                              "Calendar",
                              "Summarizer"
                            ]
                                .map((suggestion) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _searchQuery = suggestion;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 3.w, vertical: 1.h),
                                        decoration: BoxDecoration(
                                          color: AppTheme
                                              .lightTheme.primaryColor
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          suggestion,
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: AppTheme
                                                .lightTheme.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
              ] else ...[
                if (_recentlyUsedSkills.isNotEmpty)
                  SliverToBoxAdapter(
                    child: RecentlyUsedCarousel(
                      recentSkills: _recentlyUsedSkills,
                      onSkillTap: _handleSkillTap,
                    ),
                  ),
                if (_favoriteSkills.isNotEmpty)
                  SliverToBoxAdapter(
                    child: FavoritesSection(
                      favoriteSkills: _favoriteSkills,
                      onSkillTap: _handleSkillTap,
                      onSkillLongPress: _handleSkillLongPress,
                    ),
                  ),
              ],
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final categories = _searchQuery.isNotEmpty
                        ? _filteredCategories
                        : _skillCategories;
                    if (index >= categories.length) return null;

                    return SkillCategoryCard(
                      category: categories[index],
                      onSkillTap: _handleSkillTap,
                      onSkillLongPress: _handleSkillLongPress,
                    );
                  },
                  childCount: _searchQuery.isNotEmpty
                      ? _filteredCategories.length
                      : _skillCategories.length,
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 10.h),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleVoiceSearch,
        backgroundColor:
            AppTheme.lightTheme.floatingActionButtonTheme.backgroundColor,
        foregroundColor:
            AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor,
        icon: CustomIconWidget(
          iconName: 'mic',
          color: AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor!,
          size: 20,
        ),
        label: Text(
          "Voice Command",
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color:
                AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
