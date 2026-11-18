part of 'auth_cubit.dart';

class AuthState extends Equatable {
  final StatusState<AuthResponseModel> loginStatus;
  final StatusState<void> logoutStatus;

  const AuthState({
    this.loginStatus = const StatusState.initial(),
    this.logoutStatus = const StatusState.initial(),
  });

  AuthState copyWith({
    StatusState<AuthResponseModel>? loginStatus,
    StatusState<void>? logoutStatus,
  }) {
    return AuthState(
      loginStatus: loginStatus ?? this.loginStatus,
      logoutStatus: logoutStatus ?? this.logoutStatus,
    );
  }

  @override
  List<Object?> get props => [loginStatus, logoutStatus];
}
