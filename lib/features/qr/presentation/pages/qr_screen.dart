import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr/qr.dart';
import 'package:qr_folio/core/theme/app_colors.dart';
import 'package:qr_folio/core/widgets/animated_tab_body.dart';
import 'package:qr_folio/core/widgets/appbar.dart';
import 'package:qr_folio/core/widgets/navbar.dart';
import 'package:qr_folio/core/widgets/wallpaper.dart';
import 'package:qr_folio/features/home/domain/entity/user_data_entity.dart';
import 'package:qr_folio/features/home/presentation/bloc/user_bloc.dart';
import 'package:qr_folio/features/qr/domain/entity/qr_style_entity.dart';
import 'package:qr_folio/features/qr/presentation/bloc/qr_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class QrScreen extends StatefulWidget {
  final UserDataEntity userData;
  const QrScreen({super.key, required this.userData});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen>
    with SingleTickerProviderStateMixin {
  final int _currentIndex = 2;
  final MobileScannerController _scannerController = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );

  Color _bgColor = Colors.white;
  Color _qrColor = Colors.black;
  int _errorCorrectLevel = QrErrorCorrectLevel.H;
  double _marginModules = 4;
  double _pxSize = 120;
  bool _showCenterLogo = false;
  bool _scanPaused = false;
  bool _showInvalidProfilePopup = false;

  late final AnimationController _animController;
  late final List<Animation<double>> _fadeAnims;
  late final List<Animation<Offset>> _slideAnims;

  static const _itemCount = 2;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnims = List.generate(_itemCount, (i) {
      final start = i * 0.15;
      final end = (start + 0.5).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _animController,
        curve: Interval(start, end, curve: Curves.easeOut),
      );
    });

    _slideAnims = List.generate(_itemCount, (i) {
      final start = i * 0.15;
      final end = (start + 0.5).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0, 0.08),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animController.forward();
    });
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Widget _animatedItem(int index, Widget child) {
    return FadeTransition(
      opacity: _fadeAnims[index],
      child: SlideTransition(position: _slideAnims[index], child: child),
    );
  }

  QrStyleEntity _currentStyle() {
    return QrStyleEntity(
      backgroundColorValue: _bgColor.value,
      qrColorValue: _qrColor.value,
      errorCorrectLevel: _errorCorrectLevel,
      marginModules: _marginModules,
      pxSize: _pxSize,
      showCenterLogo: _showCenterLogo,
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.cardSecondaryBg,
        ),
      );
  }

  String _colorToHex(Color color) {
    final hex = color.value.toRadixString(16).padLeft(8, '0').toUpperCase();
    return '#${hex.substring(2)}';
  }

  String _errorLabel(int value) {
    if (value == QrErrorCorrectLevel.L) return 'L';
    if (value == QrErrorCorrectLevel.M) return 'M';
    if (value == QrErrorCorrectLevel.Q) return 'Q';
    return 'H';
  }

  bool _isScannedUrl(String value) {
    final uri = Uri.tryParse(value);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  bool _isValidProfileQr(String value) {
    final uri = Uri.tryParse(value);
    if (uri == null) return false;
    if (uri.scheme != 'https') return false;
    if (uri.host.toLowerCase() != 'www.qrfolio.net') return false;
    if (uri.pathSegments.length != 2) return false;
    if (uri.pathSegments[0] != 'profile') return false;

    final userId = uri.pathSegments[1].trim();
    if (userId.isEmpty) return false;

    // Require exact profile URL shape without query params or fragments.
    if (uri.hasQuery || uri.fragment.isNotEmpty) return false;

    return true;
  }

  Future<void> _restartScanner() async {
    setState(() {
      _scanPaused = false;
      _showInvalidProfilePopup = false;
    });
    await _scannerController.start();
  }

  Future<void> _openColorPicker({
    required String title,
    required Color initialColor,
    required ValueChanged<Color> onSelected,
  }) async {
    Color selected = initialColor;

    final presets = <Color>[
      Colors.white,
      Colors.black,
      const Color(0xFF14B8A6),
      const Color(0xFF4A90E2),
      const Color(0xFF8B5CF6),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFF0F162A),
      const Color(0xFF94A3B8),
    ];

    final pickedColor = await showDialog<Color>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final red = selected.red.toDouble();
            final green = selected.green.toDouble();
            final blue = selected.blue.toDouble();

            return AlertDialog(
              backgroundColor: AppColors.cardSecondaryBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.cardSecondaryBorder),
              ),
              title: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: selected,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.cardSecondaryBorder,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _colorToHex(selected),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: selected.computeLuminance() > 0.5
                              ? Colors.black
                              : Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: presets.map((color) {
                        final isSelected = selected.value == color.value;
                        return InkWell(
                          onTap: () => setDialogState(() => selected = color),
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.accentTealLight
                                    : AppColors.cardSecondaryBorder,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    _buildRgbSlider(
                      label: 'R',
                      value: red,
                      activeColor: Colors.redAccent,
                      onChanged: (v) {
                        setDialogState(
                          () => selected = Color.fromARGB(
                            selected.alpha,
                            v.round(),
                            selected.green,
                            selected.blue,
                          ),
                        );
                      },
                    ),
                    _buildRgbSlider(
                      label: 'G',
                      value: green,
                      activeColor: Colors.greenAccent,
                      onChanged: (v) {
                        setDialogState(
                          () => selected = Color.fromARGB(
                            selected.alpha,
                            selected.red,
                            v.round(),
                            selected.blue,
                          ),
                        );
                      },
                    ),
                    _buildRgbSlider(
                      label: 'B',
                      value: blue,
                      activeColor: Colors.blueAccent,
                      onChanged: (v) {
                        setDialogState(
                          () => selected = Color.fromARGB(
                            selected.alpha,
                            selected.red,
                            selected.green,
                            v.round(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.textTertiary),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(dialogContext, selected),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: AppColors.textPrimary,
                  ),
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );

    if (pickedColor != null) {
      onSelected(pickedColor);
    }
  }

  Widget _buildRgbSlider({
    required String label,
    required double value,
    required Color activeColor,
    required ValueChanged<double> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 16,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: activeColor,
              inactiveTrackColor: AppColors.cardSecondaryBorder,
              thumbColor: activeColor,
              overlayColor: activeColor.withAlpha(40),
            ),
            child: Slider(
              min: 0,
              max: 255,
              divisions: 255,
              value: value.clamp(0.0, 255.0).toDouble(),
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(
          width: 36,
          child: Text(
            value.round().toString(),
            style: const TextStyle(color: AppColors.textTertiary, fontSize: 12),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildColorPickerTile({
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardSecondaryBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardSecondaryBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.cardSecondaryBorder),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$subtitle (${_colorToHex(color)})',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onTap,
            child: const Text(
              'Pick',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardSecondaryBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardSecondaryBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textTertiary),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildLogoToggleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardSecondaryBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardSecondaryBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.chipSecondaryBg,
              border: Border.all(color: AppColors.cardSecondaryBorder),
            ),
            child: const Icon(
              Icons.image_outlined,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Center Logo',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Spacer(),
          Switch(
            value: _showCenterLogo,
            activeColor: AppColors.textSecondary,
            activeTrackColor: AppColors.chipPrimaryBg,
            inactiveThumbColor: AppColors.textTertiary,
            inactiveTrackColor: AppColors.cardSecondaryBorder,
            onChanged: (value) => setState(() => _showCenterLogo = value),
          ),
        ],
      ),
    );
  }

  Widget _buildScanTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 18, bottom: 140),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.cardSecondaryBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.cardSecondaryBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Scan QR',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Align QR inside the frame to scan.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    height: 320,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        MobileScanner(
                          controller: _scannerController,
                          onDetect: (capture) async {
                            if (_scanPaused) return;

                            if (capture.barcodes.isEmpty) return;
                            final value = capture.barcodes.first.rawValue;
                            if (value == null || value.isEmpty) return;

                            setState(() {
                              _scanPaused = true;
                            });

                            await _scannerController.stop();

                            if (_isValidProfileQr(value)) {
                              final uri = Uri.parse(value);
                              final canOpen = await canLaunchUrl(uri);
                              if (canOpen) {
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              } else {
                                _showMessage('Unable to open scanned URL.');
                              }
                            } else {
                              if (mounted) {
                                setState(() {
                                  _showInvalidProfilePopup = true;
                                });
                              }
                              return;
                            }

                            await Future<void>.delayed(
                              const Duration(milliseconds: 900),
                            );
                            if (mounted) {
                              await _restartScanner();
                            }
                          },
                        ),
                        if (_showInvalidProfilePopup)
                          Positioned(
                            top: 12,
                            left: 12,
                            right: 12,
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2D191C),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF6C2E35),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: Color(0xFFFFB4B4),
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    const Expanded(
                                      child: Text(
                                        'Not a valid user profile page',
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => _restartScanner(),
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColors.textSecondary,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.textSecondary.withAlpha(180),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Expanded(
      child: SizedBox(
        height: 56,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Ink(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 18, color: textColor),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomizeActions() {
    return Column(
      children: [
        Row(
          children: [
            _buildActionButton(
              title: 'Download PNG',
              icon: Icons.download_rounded,
              backgroundColor: AppColors.primaryBlue,
              textColor: AppColors.textPrimary,
              onTap: () => context.read<QrBloc>().add(
                QrDownloadPngEvent(
                  data: widget.userData.qr.url,
                  style: _currentStyle(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            _buildActionButton(
              title: 'Download SVG',
              icon: Icons.download_rounded,
              backgroundColor: AppColors.cardSecondaryBg,
              textColor: AppColors.textPrimary,
              onTap: () => context.read<QrBloc>().add(
                QrDownloadSvgEvent(
                  data: widget.userData.qr.url,
                  style: _currentStyle(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildActionButton(
              title: 'Copy Link',
              icon: Icons.content_copy_rounded,
              backgroundColor: AppColors.cardSecondaryBorder,
              textColor: AppColors.textPrimary,
              onTap: () => context.read<QrBloc>().add(
                QrCopyLinkEvent(url: widget.userData.qr.url),
              ),
            ),
            const SizedBox(width: 10),
            _buildActionButton(
              title: 'Share',
              icon: Icons.share_outlined,
              backgroundColor: AppColors.cardPrimaryBg,
              textColor: AppColors.textTertiary,
              onTap: () => context.read<QrBloc>().add(
                QrShareEvent(
                  data: widget.userData.qr.url,
                  style: _currentStyle(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomizeTab() {
    final double qrPreviewSize = _pxSize.clamp(120.0, 320.0).toDouble();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 18, bottom: 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'QR Designer',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                  letterSpacing: -0.8,
                ),
              ),
              Spacer(),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _bgColor = Colors.white;
                    _qrColor = Colors.black;
                    _errorCorrectLevel = QrErrorCorrectLevel.H;
                    _marginModules = 4;
                    _pxSize = 120;
                    _showCenterLogo = false;
                  });
                },
                icon: const Icon(
                  Icons.restart_alt,
                  color: AppColors.textSecondary,
                ),
                label: Text(
                  'Reset defaults',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Tune colors, correction, margin and size before sharing.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textTertiary),
          ),
          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: AppColors.cardLinGradBorder,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppColors.cardLinGrad,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: qrPreviewSize,
                    height: qrPreviewSize,
                    child: PrettyQrView.data(
                      data: widget.userData.qr.url,
                      errorCorrectLevel: _errorCorrectLevel,
                      decoration: PrettyQrDecoration(
                        image: _showCenterLogo
                            ? const PrettyQrDecorationImage(
                                image: Svg('assets/logo.svg'),
                                scale: 0.2,
                              )
                            : null,
                        background: _bgColor,
                        quietZone: PrettyQrQuietZone.modules(_marginModules),
                        shape: PrettyQrShape.custom(
                          PrettyQrSquaresSymbol(color: _qrColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          _buildColorPickerTile(
            title: 'Background Color',
            subtitle: 'Default white',
            color: _bgColor,
            onTap: () => _openColorPicker(
              title: 'Pick Background Color',
              initialColor: _bgColor,
              onSelected: (color) => setState(() => _bgColor = color),
            ),
          ),
          const SizedBox(height: 10),
          _buildColorPickerTile(
            title: 'QR Image Color',
            subtitle: 'Default black',
            color: _qrColor,
            onTap: () => _openColorPicker(
              title: 'Pick QR Color',
              initialColor: _qrColor,
              onSelected: (color) => setState(() => _qrColor = color),
            ),
          ),
          const SizedBox(height: 10),

          _buildLogoToggleCard(),
          const SizedBox(height: 10),

          _buildControlCard(
            title: 'Correction Level',
            subtitle: 'Current: ${_errorLabel(_errorCorrectLevel)}',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  [
                    QrErrorCorrectLevel.L,
                    QrErrorCorrectLevel.M,
                    QrErrorCorrectLevel.Q,
                    QrErrorCorrectLevel.H,
                  ].map((level) {
                    final isSelected = _errorCorrectLevel == level;
                    return GestureDetector(
                      onTap: () => setState(() => _errorCorrectLevel = level),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.chipPrimaryBg
                              : AppColors.chipSecondaryBg,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.chipPrimaryBorder
                                : AppColors.cardSecondaryBorder,
                          ),
                        ),
                        child: Text(
                          _errorLabel(level),
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 10),

          _buildControlCard(
            title: 'Margin',
            subtitle: '${_marginModules.toStringAsFixed(1)} modules',
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppColors.primaryBlue,
                inactiveTrackColor: AppColors.cardSecondaryBorder,
                thumbColor: AppColors.textSecondary,
                overlayColor: AppColors.primaryBlue.withAlpha(30),
              ),
              child: Slider(
                min: 0,
                max: 10,
                divisions: 10,
                value: _marginModules,
                onChanged: (value) => setState(() => _marginModules = value),
              ),
            ),
          ),
          const SizedBox(height: 10),

          _buildControlCard(
            title: 'PX Size',
            subtitle: '${_pxSize.toStringAsFixed(0)} px',
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppColors.primaryBlue,
                inactiveTrackColor: AppColors.cardSecondaryBorder,
                thumbColor: AppColors.textSecondary,
                overlayColor: AppColors.primaryBlue.withAlpha(30),
              ),
              child: Slider(
                min: 100,
                max: 160,
                divisions: 60,
                value: _pxSize,
                onChanged: (value) => setState(() => _pxSize = value),
              ),
            ),
          ),
          const SizedBox(height: 14),

          _buildCustomizeActions(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is NavItemSelectedState && state.index == 2) {
          _animController.reset();
          _animController.forward();
        }
      },
      child: BlocListener<QrBloc, QrState>(
      listener: (context, state) {
        if (state is QrActionInProgress) {
          _showMessage(state.action);
        } else if (state is QrActionSuccess) {
          _showMessage(state.message);
        } else if (state is QrActionFailure) {
          _showMessage(state.message);
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Stack(
          children: [
            const Wallpaper(),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(90),
                child: Appbar(user: widget.userData),
              ),
              body: SafeArea(
                top: false,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          // 0 – Tab bar
                          _animatedItem(
                            0,
                            TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,
                            overlayColor: WidgetStateProperty.all(
                              Colors.transparent,
                            ),
                            indicatorAnimation: TabIndicatorAnimation.elastic,
                            indicator: BoxDecoration(
                              color: AppColors.cardSecondaryBg,
                              border: Border.all(
                                color: AppColors.cardSecondaryBorder,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelColor: Colors.white,
                            unselectedLabelColor: AppColors.textPrimary,
                            dividerColor: Colors.transparent,
                            tabs: [
                              Tab(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.qr_code_scanner, size: 17),
                                    SizedBox(width: 5),
                                    Text(
                                      'Scan',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Tab(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.qr_code, size: 17),
                                    SizedBox(width: 5),
                                    Text(
                                      'Customize',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          ),
                          const SizedBox(height: 8),
                          // 1 – Tab content
                          Expanded(
                            child: _animatedItem(
                              1,
                              TabBarView(
                                children: [
                                  AnimatedTabBody(child: _buildScanTab()),
                                  AnimatedTabBody(child: _buildCustomizeTab()),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Navbar(currentIndex: _currentIndex),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
