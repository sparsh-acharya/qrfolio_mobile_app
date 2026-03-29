import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_folio/core/theme/app_colors.dart';
import 'package:qr_folio/core/widgets/wallpaper.dart';
import 'package:qr_folio/core/widgets/professional_detail_card.dart';
import 'package:qr_folio/features/home/domain/entity/user_data_entity.dart';
import 'package:qr_folio/features/home/presentation/widgets/export_card.dart';
import 'package:qr_folio/features/media/domain/entity/media_entity.dart';
import 'package:qr_folio/features/media/presentation/bloc/media_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PublicProfileScreen extends StatefulWidget {
  final UserDataEntity user;

  const PublicProfileScreen({super.key, required this.user});

  @override
  State<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final List<Animation<double>> _fadeAnims;
  late final List<Animation<Offset>> _slideAnims;

  static const _itemCount = 6;

  final GlobalKey _exportCardKey = GlobalKey();

  UserDataEntity get user => widget.user;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
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

    // Fetch media for the gallery section
    context.read<MediaBloc>().add(FetchMediaEvent());
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Widget _animatedItem(int index, Widget child) {
    return FadeTransition(
      opacity: _fadeAnims[index],
      child: SlideTransition(position: _slideAnims[index], child: child),
    );
  }

  Future<void> _captureAndShareCard() async {
    // Wait a frame so the offstage widget is fully laid out
    await Future.delayed(const Duration(milliseconds: 100));

    final boundary =
        _exportCardKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (boundary == null) return;

    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;

    final pngBytes = byteData.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/qr_card.png');
    await file.writeAsBytes(pngBytes);

    await Share.shareXFiles([XFile(file.path)], text: 'My QR Folio Card');
  }

  Future<void> _captureAndSharePdf() async {
    // Wait a frame so the offstage widget is fully laid out
    await Future.delayed(const Duration(milliseconds: 100));

    final boundary =
        _exportCardKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (boundary == null) return;

    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;

    final pngBytes = byteData.buffer.asUint8List();

    final pdf = pw.Document();
    final imageProvider = pw.MemoryImage(pngBytes);

    // Use exact card dimensions (1280x720) and remove all margins
    final format = PdfPageFormat(1280, 720, marginAll: 0);

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.FullPage(
            ignoreMargins: true,
            child: pw.Image(imageProvider, fit: pw.BoxFit.cover),
          );
        },
      ),
    );

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/qr_card.pdf');
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(file.path)], text: 'My QR Folio Card PDF');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Wallpaper(),
        // Export card rendered off-screen (must be painted for toImage to work)
        Positioned(
          left: -10000,
          top: -10000,
          child: RepaintBoundary(
            key: _exportCardKey,
            child: ExportCard(user: user),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.iconPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Public Profile',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.iconPrimary),
                color: AppColors.cardSecondaryBg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: AppColors.cardSecondaryBorder,
                    width: 1,
                  ),
                ),
                onSelected: (value) {
                  if (value == 'share') {
                    Share.share('https://www.qrfolio.net/profile/${user.xid}');
                  } else if (value == 'download_img') {
                    _captureAndShareCard();
                  } else if (value == 'download_pdf') {
                    _captureAndSharePdf();
                  } else if (value == 'view_card') {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: const EdgeInsets.all(10),
                        child: InteractiveViewer(
                          child: FittedBox(child: ExportCard(user: user)),
                        ),
                      ),
                    );
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'share',
                    child: Text(
                      'Share',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'download_pdf',
                    child: Text(
                      'Download card pdf',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'download_img',
                    child: Text(
                      'Download card img',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'view_card',
                    child: Text(
                      'View card',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Header Section (Profile Pic, Name, Designation, Company)
                _animatedItem(0, _buildHeader(context)),
                const SizedBox(height: 30),

                // 2. Contact Info Section
                _animatedItem(1, _buildContactInfo()),
                const SizedBox(height: 30),

                // 3. QR Image
                _animatedItem(2, _buildQrSection()),
                const SizedBox(height: 30),

                // 4. About Me
                _animatedItem(3, _buildAboutMeSection()),
                const SizedBox(height: 30),

                // 5. Professional Details
                _animatedItem(4, _buildProfessionalDetails()),
                const SizedBox(height: 30),

                // 6. Media Gallery
                _animatedItem(5, _buildMediaGallery()),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.cardPrimaryBg,
            border: Border.all(color: AppColors.primaryBlue, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardGradShadow,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: user.profilePhotoUrl != null
              ? ClipOval(
                  child: Image.network(
                    user.profilePhotoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          user.core.name != null && user.core.name!.isNotEmpty
                              ? user.core.name![0].toUpperCase()
                              : 'U',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Center(
                  child: Text(
                    user.core.name != null && user.core.name!.isNotEmpty
                        ? user.core.name![0].toUpperCase()
                        : 'U',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 15),
        Text(
          user.core.name ?? 'Unknown User',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          user.professional.designation,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          user.professional.companyName,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textTertiary),
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardSecondaryBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardSecondaryBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _contactRow(Icons.email, user.core.email ?? 'No email provided'),
          const Divider(color: AppColors.cardSecondaryBorder, height: 20),
          _contactRow(
            Icons.phone,
            user.core.phone.isNotEmpty ? user.core.phone : 'No phone provided',
          ),
          const Divider(color: AppColors.cardSecondaryBorder, height: 20),
          _contactRow(
            Icons.location_on,
            user.personal.address.isNotEmpty
                ? user.personal.address
                : 'No address provided',
          ),
        ],
      ),
    );
  }

  Widget _contactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryBlueLight, size: 20),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildQrSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "My QR Code",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 15),
        Center(
          child: Container(
            padding: const EdgeInsets.all(4), // For the gradient border effect
            decoration: BoxDecoration(
              gradient: AppColors.cardLinGradBorder,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardGradShadow,
                  blurRadius: 15,
                  spreadRadius: 0,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.cardSecondaryBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: AppColors.cardPrimaryBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(user.qr.imageBytes, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutMeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About Me",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardSecondaryBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cardSecondaryBorder, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            user.personal.description.isNotEmpty
                ? user.personal.description
                : 'No description provided.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfessionalDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Professional Details",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 15),
        ProfessionalDetailsContainer(
          companyName: user.professional.companyName,
          designation: user.professional.designation,
          experience: user.professional.companyExperience,
          referralCode: user.professional.referralCode,
        ),
      ],
    );
  }

  Widget _buildMediaGallery() {
    return BlocBuilder<MediaBloc, MediaState>(
      builder: (context, state) {
        if (state is LoadingMediaState) {
          return _buildGalleryShell(
            child: const SizedBox(
              height: 300,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (state is ErrorMediaState) {
          return _buildGalleryShell(
            child: SizedBox(
              height: 300,
              child: Center(
                child: Text(
                  'Failed to load gallery',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ),
          );
        } else if (state is LoadedMediaState) {
          final images = state.mediaList
              .where((m) => m.type.toLowerCase() == 'image')
              .toList();
          final videos = state.mediaList
              .where((m) => m.type.toLowerCase() == 'video')
              .toList();
          final docs = state.mediaList
              .where((m) => m.type.toLowerCase() == 'document')
              .toList();

          return _buildGalleryShell(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    indicatorAnimation: TabIndicatorAnimation.elastic,
                    indicator: BoxDecoration(
                      color: AppColors.cardSecondaryBg,
                      border: Border.all(color: AppColors.cardSecondaryBorder),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.textPrimary,
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.image_outlined, size: 16),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                'Images',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.video_collection_outlined,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                'Videos',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.description_outlined, size: 16),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                'Docs',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 300,
                    child: TabBarView(
                      children: [
                        _buildImageGrid(images),
                        _buildVideoList(videos),
                        _buildDocList(docs),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Default / initial state — show nothing
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildGalleryShell({required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gallery',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.cardSecondaryBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cardSecondaryBorder, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }

  // ── Images Tab ──────────────────────────────────────────
  Widget _buildImageGrid(List<MediaEntity> images) {
    if (images.isEmpty) {
      return Center(
        child: Text(
          'No images yet',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textTertiary),
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(4),
      itemCount: images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (_, i) {
        return GestureDetector(
          onTap: () => _showImagePreview(images[i].url),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardPrimaryBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                images[i].url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showImagePreview(String url) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: InteractiveViewer(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(url, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  // ── Videos Tab ─────────────────────────────────────────
  Widget _buildVideoList(List<MediaEntity> videos) {
    if (videos.isEmpty) {
      return Center(
        child: Text(
          'No videos yet',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textTertiary),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(4),
      itemCount: videos.length,
      itemBuilder: (_, i) {
        final videoUrl = videos[i].url;
        final videoId = _extractYoutubeId(videoUrl);
        final thumbnailUrl =
            'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

        return GestureDetector(
          onTap: () => _openUrl(videoUrl),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 180,
            decoration: BoxDecoration(
              color: AppColors.cardPrimaryBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.cardPrimaryBg,
                      child: const Center(
                        child: Icon(
                          Icons.video_library,
                          color: Colors.grey,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String? _extractYoutubeId(String url) {
    try {
      if (url.contains('watch?v=')) {
        return url.split('watch?v=')[1].split('&')[0];
      }
      if (url.contains('youtu.be/')) {
        return url.split('youtu.be/')[1].split('?')[0];
      }
      if (url.contains('embed/')) {
        return url.split('embed/')[1].split('?')[0];
      }
      if (url.contains('/v/')) {
        return url.split('/v/')[1].split('?')[0];
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // ── Docs Tab ───────────────────────────────────────────
  Widget _buildDocList(List<MediaEntity> docs) {
    if (docs.isEmpty) {
      return Center(
        child: Text(
          'No documents yet',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textTertiary),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(4),
      itemCount: docs.length,
      itemBuilder: (_, i) {
        return GestureDetector(
          onTap: () => _openUrl(docs[i].url),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.cardSecondaryBg,
              border: Border.all(color: AppColors.cardSecondaryBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.cardSecondaryBorder,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          docs[i].title.isEmpty ? "Untitled" : docs[i].title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          docs[i].mimeType,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.textTertiary,
                                fontSize: 11,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.open_in_new,
                    color: AppColors.primaryBlueLight,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
