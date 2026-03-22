part of 'qr_bloc.dart';

@immutable
sealed class QrState {}

class QrInitial extends QrState {}

class QrActionInProgress extends QrState {
  final String action;

  QrActionInProgress(this.action);
}

class QrActionSuccess extends QrState {
  final String message;

  QrActionSuccess(this.message);
}

class QrActionFailure extends QrState {
  final String message;

  QrActionFailure(this.message);
}
