enum ApiStatus {
  initial,
  loading,
  success,
  failure,
}

extension ApiStatusX on ApiStatus {
  bool get isInitial => this == ApiStatus.initial;
  bool get isLoading => this == ApiStatus.loading;
  bool get isSuccess => this == ApiStatus.success;
  bool get isFailure => this == ApiStatus.failure;
}
