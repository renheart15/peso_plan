import 'package:equatable/equatable.dart';

/// Immutable auth state used by AuthNotifier.
class AuthState extends Equatable {
  const AuthState({
    this.isLoggedIn = false,
    this.isFirstLogin = false,
    this.isEmailVerified = false,
    this.isLoading = false,
    this.isInitializing = true, // true while the startup session check runs
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

  /// Whether the initial token / session validation is still in progress.
  /// The router keeps the splash screen visible while this is [true] so the
  /// login page never appears (and can never hang) until we know the auth
  /// status.
  final bool isInitializing;

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
    bool? isInitializing,
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
      isInitializing: isInitializing ?? this.isInitializing,
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
        isInitializing,
        userId,
        householdId,
        userName,
        userEmail,
        error,
      ];
}
