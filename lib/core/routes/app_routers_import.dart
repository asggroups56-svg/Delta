import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/features/auth/presentation/view/screen/login_screen.dart';
import 'package:my_template/features/auth/presentation/view/screen/signup_screen.dart';
import 'package:my_template/features/auth/presentation/view/screen/forgot_password_screen.dart';
import 'package:my_template/features/home/presentation/view/screen/accounting_dashboard_screen.dart';
import 'package:my_template/features/home/presentation/view/screen/main_shell_screen.dart';
import 'package:my_template/features/reports/presentation/view/screen/reports_screen.dart';
import 'package:my_template/features/home/presentation/view/screen/home_screen.dart';
import 'package:my_template/features/onboarding/presentation/view/screen/onboarding_screen.dart';
import 'package:my_template/features/knowledge/presentation/view/screen/knowledge_screen.dart';
import 'package:my_template/features/quick_actions/presentation/view/screen/create_invoice_screen.dart';
import 'package:my_template/features/quick_actions/presentation/view/screen/add_lead_screen.dart';
import 'package:my_template/features/quick_actions/presentation/view/screen/scan_upload_screen.dart';
import 'package:my_template/features/quick_actions/presentation/view/screen/ai_copilot_screen.dart';

import '../../features/auth/presentation/view/cubit/auth_cubit.dart';
import '../../features/splash/presentation/view/screen/splash_screen.dart' show SplashScreen;
import '../services/services_locator.dart';

part 'app_routers.dart';
