class QrStyleEntity {
  final int backgroundColorValue;
  final int qrColorValue;
  final int errorCorrectLevel;
  final double marginModules;
  final double pxSize;
  final bool showCenterLogo;

  const QrStyleEntity({
    required this.backgroundColorValue,
    required this.qrColorValue,
    required this.errorCorrectLevel,
    required this.marginModules,
    required this.pxSize,
    required this.showCenterLogo,
  });
}
