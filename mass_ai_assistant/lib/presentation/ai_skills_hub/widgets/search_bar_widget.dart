import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback? onVoiceSearch;

  const SearchBarWidget({
    Key? key,
    required this.onSearchChanged,
    this.onVoiceSearch,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.dividerLight, width: 1),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 4,
                  offset: const Offset(0, 2)),
            ]),
        child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            onChanged: widget.onSearchChanged,
            decoration: InputDecoration(
                hintText: "Search AI skills...",
                hintStyle: AppTheme.lightTheme.textTheme.bodyMedium
                    ?.copyWith(color: AppTheme.textDisabledLight),
                prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                        iconName: 'search',
                        color: AppTheme.textMediumEmphasisLight,
                        size: 20)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? Row(mainAxisSize: MainAxisSize.min, children: [
                        GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              widget.onSearchChanged('');
                            },
                            child: Padding(
                                padding: EdgeInsets.all(2.w),
                                child: CustomIconWidget(
                                    iconName: 'clear',
                                    color: AppTheme.textMediumEmphasisLight,
                                    size: 18))),
                        if (widget.onVoiceSearch != null)
                          GestureDetector(
                              onTap: widget.onVoiceSearch,
                              child: Padding(
                                  padding: EdgeInsets.all(2.w),
                                  child: CustomIconWidget(
                                      iconName: 'mic',
                                      color: AppTheme.lightTheme.primaryColor,
                                      size: 20))),
                      ])
                    : widget.onVoiceSearch != null
                        ? GestureDetector(
                            onTap: widget.onVoiceSearch,
                            child: Padding(
                                padding: EdgeInsets.all(3.w),
                                child: CustomIconWidget(
                                    iconName: 'mic',
                                    color: AppTheme.lightTheme.primaryColor,
                                    size: 20)))
                        : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h)),
            style: AppTheme.lightTheme.textTheme.bodyMedium));
  }
}
