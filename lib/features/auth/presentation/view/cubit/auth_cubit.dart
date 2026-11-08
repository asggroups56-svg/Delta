import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:my_template/core/cache/shared_pref/shared_pref.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/auth/data/repository/auth_repo.dart';

import '../../../data/model/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AuthCubit(this.authRepo) : super(const AuthState()) {
    final prefs = CacheHelper.sharedPreferences;
    final savedAddress = prefs.getString(CacheHelper.accountAddressKey);
    if (savedAddress != null && savedAddress.isNotEmpty) {
      connectionNameController.text = savedAddress;
    }
    final savedModule = prefs.getString(CacheHelper.selectedModuleKey);
    if (savedModule != null && savedModule.isNotEmpty) {
      selectedModuleId = savedModule;
    }
  }

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController connectionNameController =
      TextEditingController();

  /// Workspace chosen on the pre-login access page (accounting, assets,
  /// sales, purchases, inventory). It is kept here so a signed-in session can
  /// start in the section the user picked.
  String? selectedModuleId;

  void selectModule(String moduleId) => selectedModuleId = moduleId;

  set password(String password) => passwordController.text = password;

  Future<void> login({BuildContext? context}) async {
    if (isClosed) return;
    emit(state.copyWith(loginStatus: StatusState.loading()));

    final result = await authRepo.login(
      username: usernameController.text,
      password: passwordController.text,
      connectionName: connectionNameController.text,
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(
        state.copyWith(loginStatus: StatusState.failure(error.errMessage)),
      ),
      (success) {
        emit(state.copyWith(loginStatus: StatusState.success(success)));
      },
    );
  }

  @override
  Future<void> close() {
    usernameController.dispose();
    passwordController.dispose();
    connectionNameController.dispose();
    return super.close();
  }
}
