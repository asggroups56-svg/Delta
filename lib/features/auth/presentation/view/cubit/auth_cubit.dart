import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/auth/data/repository/auth_repo.dart';

import '../../../data/model/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AuthCubit(this.authRepo) : super(const AuthState());

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController connectionNameController =
      TextEditingController();

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
