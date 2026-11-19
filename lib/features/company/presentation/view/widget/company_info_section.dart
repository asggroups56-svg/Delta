import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../core/theme/app_colors.dart';

/// Collapsible information card used across the company profile page.
///
/// The section starts as a closed header item and only reveals its rows after
/// the user taps the header. Its expanded state survives scrolling because the
/// card requests to be kept alive.
///
/// [onExpanded] is called once the first time the user opens the section,
/// making it easy to trigger lazy data loads (e.g. fetching the accounts tree
/// only when its card is actually opened).
class CompanyInfoSection extends StatefulWidget {
  const CompanyInfoSection({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.rows,
    this.initiallyExpanded = false,
    this.contentPadding,
    this.onExpanded,
  });

  final IconData icon;
  final Color color;
  final String title;
  final List<Widget> rows;
  final bool initiallyExpanded;
  final EdgeInsetsGeometry? contentPadding;

  /// Called the first time (and only once) the section is expanded.
  final VoidCallback? onExpanded;

  @override
  State<CompanyInfoSection> createState() => _CompanyInfoSectionState();
}

class _CompanyInfoSectionState extends State<CompanyInfoSection>
    with AutomaticKeepAliveClientMixin<CompanyInfoSection> {
  late bool _expanded = widget.initiallyExpanded;

  /// Tracks whether [widget.onExpanded] has already been fired, so it is
  /// called only once regardless of how many times the user opens the section.
  bool _onExpandedFired = false;

  @override
  void initState() {
    super.initState();
    // If the section starts expanded, fire the callback immediately.
    if (widget.initiallyExpanded && widget.onExpanded != null) {
      _onExpandedFired = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onExpanded!();
      });
    }
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded && !_onExpandedFired && widget.onExpanded != null) {
      _onExpandedFired = true;
      widget.onExpanded!();
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final headerRadius = BorderRadius.vertical(
      top: Radius.circular(20.r),
      bottom: Radius.circular(_expanded ? 0 : 20.r),
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColor.borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggle,
              borderRadius: headerRadius,
              child: Container(
                padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 12.w, 12.h),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.08),
                  borderRadius: headerRadius,
                  border: _expanded
                      ? Border(
                          bottom: BorderSide(
                            color: widget.color.withValues(alpha: 0.18),
                          ),
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(7.r),
                      decoration: BoxDecoration(
                        color: widget.color.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(widget.icon, size: 16.r, color: widget.color),
                    ),
                    Gap(10.w),
                    Expanded(
                      child: Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColor.titleFormFiledColor(context),
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                    Gap(8.w),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOutCubic,
                      child: Container(
                        width: 28.r,
                        height: 28.r,
                        decoration: BoxDecoration(
                          color: widget.color.withValues(
                            alpha: _expanded ? 0.16 : 0.08,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.expand_more_rounded,
                          size: 18.r,
                          color: widget.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: _expanded
                ? Padding(
                    padding:
                        widget.contentPadding ??
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _withDividers(context, widget.rows),
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }

  List<Widget> _withDividers(BuildContext context, List<Widget> items) {
    final list = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      list.add(items[i]);
      if (i < items.length - 1) {
        list.add(
          Divider(
            height: 16.h,
            color: AppColor.borderColor(context).withValues(alpha: 0.6),
          ),
        );
      }
    }
    return list;
  }
}
