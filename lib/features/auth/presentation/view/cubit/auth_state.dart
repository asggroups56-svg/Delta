part of 'auth_cubit.dart';

class AuthState extends Equatable {
  final StatusState<AuthResponseModel> loginStatus;
  final bool rememberMe;

  const AuthState({
    this.loginStatus = const StatusState.initial(),
    this.rememberMe = false,
  });

  AuthState copyWith({
    StatusState<AuthResponseModel>? loginStatus,
    bool? rememberMe,
  }) {
    return AuthState(
      loginStatus: loginStatus ?? this.loginStatus,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }

  @override
  List<Object?> get props => [loginStatus, rememberMe];
}
