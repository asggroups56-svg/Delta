import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/core/utils/navigator_methods.dart';
import 'package:my_template/features/auth/data/model/workspace_module.dart';
import 'package:my_template/features/auth/presentation/view/cubit/auth_cubit.dart';
import 'package:my_template/features/auth/presentation/view/screen/widget/branding_panel_widget.dart';
import 'package:my_template/features/auth/presentation/view/screen/widget/login_form_panel_widget.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _toggleLanguage() async {
    final next = context.locale.languageCode == 'ar' ? 'en' : 'ar';
    await context.setLocale(Locale(next));
    if (mounted) setState(() {});
  }

  void _onAuthStateChanged(BuildContext context, AuthState state) {
    if (state.loginStatus.isSuccess) {
      CommonMethods.showToast(
        message:
            state.loginStatus.data?.message ??
            "${AppLocaleKey.loginBtn.tr()} SUCCESS",
      );
      NavigatorMethods.pushReplacementNamed(
        context,
        RoutesName.mainShellScreen,
      );
    }
    if (state.loginStatus.isFailure) {
      log(state.loginStatus.error?.toString() ?? "Login failed");
      final error = state.loginStatus.error ?? "Login failed";
      CommonMethods.showToast(message: error, type: ToastType.error);
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    final workspace = workspaceModuleById(cubit.selectedModuleId);

    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final compactLayout =
              constraints.maxHeight < 720 ||
              MediaQuery.viewInsetsOf(context).bottom > 0;

          return BlocConsumer<AuthCubit, AuthState>(
            listener: _onAuthStateChanged,
            builder: (context, state) {
              final loginRow = Row(
                crossAxisAlignment: compactLayout
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.stretch,
                children: [
                  if (constraints.maxWidth > 900)
                    Expanded(flex: 5, child: BrandingPanel()),
                  Expanded(
                    flex: 4,
                    child: LoginFormPanel(
                      formKey: _formKey,
                      compactLayout: compactLayout,
                      workspace: workspace,
                      isLoading: state.loginStatus.isLoading,
                      onToggleLanguage: _toggleLanguage,
                      onSubmit: _submit,
                    ),
                  ),
                ],
              );

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: compactLayout
                      ? loginRow
                      : IntrinsicHeight(child: loginRow),
                ),
              );
            },
          );
        },
      ),
    );
  }
}