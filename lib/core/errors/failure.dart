abstract class Failure {
  final String message;

  Failure({required this.message});
}

class ApiError extends Failure {
  ApiError({required super.message});
}
