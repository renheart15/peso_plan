import 'package:equatable/equatable.dart';

/// Immutable auth state used by AuthNotifier.
class AuthState extends Equatable {
  const AuthState({
    this.isLoggedIn = false,
    this.isFirstLogin = false,
    this.isEmailVerified = false,
    this.isLoading = false,
    this.userId,
    this.householdId,
    this.userName,
    this.userEmail,
    this.error,
  });

  final bool isLoggedIn;
  final bool isFirstLogin;
  final bool isEmailVerified;
  final bool isLoading;
  final int? userId;
  final int? householdId;
  final String? userName;
  final String? userEmail;
  final String? error;

  AuthState copyWith({
    bool? isLoggedIn,
    bool? isFirstLogin,
    bool? isEmailVerified,
    bool? isLoading,
    int? userId,
    int? householdId,
    String? userName,
    String? userEmail,
    String? error,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isFirstLogin: isFirstLogin ?? this.isFirstLogin,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isLoading: isLoading ?? this.isLoading,
      userId: userId ?? this.userId,
      householdId: householdId ?? this.householdId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        isLoggedIn,
        isFirstLogin,
        isEmailVerified,
        isLoading,
        userId,
        householdId,
        userName,
        userEmail,
        error,
      ];
}
