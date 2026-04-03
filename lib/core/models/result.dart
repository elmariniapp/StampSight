sealed class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;
  factory Result.failure(String message, [Object? error]) = Failure<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(String message, Object? error) failure,
  });
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(String message, Object? error) failure,
  }) =>
      success(data);
}

final class Failure<T> extends Result<T> {
  final String message;
  final Object? error;
  const Failure(this.message, [this.error]);

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(String message, Object? error) failure,
  }) =>
      failure(message, error);
}
