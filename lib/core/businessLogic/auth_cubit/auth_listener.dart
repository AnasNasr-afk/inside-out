abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

// ── Google Sign In ─────────────────────────────────────
class GoogleSignInLoadingState extends AuthStates {}
class GoogleSignInSuccessState extends AuthStates {}
class GoogleSignInErrorState extends AuthStates {
  final String error;
  GoogleSignInErrorState(this.error);
}

// ── Register ───────────────────────────────────────────
class RegisterLoadingState extends AuthStates {}
class RegisterSuccessState extends AuthStates {}
class RegisterErrorState extends AuthStates {
  final String error;
  RegisterErrorState(this.error);
}

// ── Login ──────────────────────────────────────────────
class LoginLoadingState extends AuthStates {}
class LoginSuccessState extends AuthStates {
  final String userId;
  LoginSuccessState(this.userId);
}
class LoginErrorState extends AuthStates {
  final String error;
  LoginErrorState(this.error);
}

// ── Logout ─────────────────────────────────────────────
class LogoutLoadingState extends AuthStates {}
class LogoutSuccessState extends AuthStates {}