import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/auth/data/model/workspace_module.dart';
import 'package:my_template/features/auth/presentation/view/screen/widget/login_field_label_widget.dart';
import 'package:my_template/features/auth/presentation/view/screen/widget/login_top_bar_widget.dart';
import 'package:my_template/features/auth/presentation/view/screen/widget/login_welcome_header_widget.dart';

import 'login_submit_button_widget.dart';

class LoginFormPanel extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool compactLayout;
  final WorkspaceModule? workspace;
  final bool isLoading;
  final VoidCallback onToggleLanguage;
  final VoidCallback onSubmit;

  const LoginFormPanel({
    super.key,
    required this.formKey,
    required this.compactLayout,
    required this.workspace,
    required this.isLoading,
    required this.onToggleLanguage,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.whiteColor(context),
      padding: EdgeInsets.symmetric(
        horizontal: compactLayout ? 24.w : 42.w,
        vertical: compactLayout ? 16.h : 32.h,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LoginTopBar(onToggleLanguage: onToggleLanguage),
                Gap((compactLayout ? 20 : 48).h),
                LoginWelcomeHeader(workspace: workspace),
                Gap((compactLayout ? 18 : 32).h),
                UsernameField(),
                Gap((compactLayout ? 10 : 18).h),
                PasswordField(),
                Gap((compactLayout ? 10 : 18).h),
                ConnectionNameField(
                  isRequired: workspace != null,
                ),
                Gap((compactLayout ? 16 : 26).h),
                LoginSubmitButton(
                  isLoading: isLoading,
                  onPressed: onSubmit, isArabic: Directionality.of(context) == TextDirection.rtl,
                  
                ),
                Gap((compactLayout ? 10 : 18).h),
                ChangeWorkspaceButton(
                  isArabic: Directionality.of(context) == TextDirection.rtl,
                ),
                Gap((compactLayout ? 10 : 18).h),
                LoginVersionText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}