abstract class AuthStates {}

class AuthInitialState extends AuthStates {}


class GoogleSignInLoadingState extends AuthStates {}
class GoogleSignInSuccessState extends AuthStates {}
class GoogleSignInErrorState extends AuthStates {
  final String error;
  GoogleSignInErrorState(this.error);
}


