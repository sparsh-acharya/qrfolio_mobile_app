part of 'qr_bloc.dart';

@immutable
sealed class QrEvent {}

class QrDownloadPngEvent extends QrEvent {
  final String data;
  final QrStyleEntity style;

  QrDownloadPngEvent({required this.data, required this.style});
}

class QrDownloadSvgEvent extends QrEvent {
  final String data;
  final QrStyleEntity style;

  QrDownloadSvgEvent({required this.data, required this.style});
}

class QrCopyLinkEvent extends QrEvent {
  final String url;

  QrCopyLinkEvent({required this.url});
}

class QrShareEvent extends QrEvent {
  final String data;
  final QrStyleEntity style;

  QrShareEvent({required this.data, required this.style});
}
