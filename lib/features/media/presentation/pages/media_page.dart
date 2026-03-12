import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_folio/features/media/presentation/bloc/media_bloc.dart';
import 'package:qr_folio/features/media/presentation/pages/add_media_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_folio/core/theme/app_colors.dart';
import 'package:qr_folio/core/widgets/appbar.dart';
import 'package:qr_folio/core/widgets/navbar.dart';
import 'package:qr_folio/core/widgets/wallpaper.dart';
import 'package:qr_folio/features/home/domain/entity/user_data_entity.dart';
import 'package:qr_folio/features/media/domain/entity/media_entity.dart';

class MediaPage extends StatefulWidget {
  final UserDataEntity user;
  final List<MediaEntity> mediaList;
  const MediaPage({super.key, required this.user, required this.mediaList});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  final int _currentIndex = 2;

  // Separate media into different lists
  List<MediaEntity> get imageList => widget.mediaList
      .where((media) => media.type.toLowerCase() == 'image')
      .toList();

  List<MediaEntity> get videoList => widget.mediaList
      .where((media) => media.type.toLowerCase() == 'video')
      .toList();

  List<MediaEntity> get docList => widget.mediaList
      .where((media) => media.type.toLowerCase() == 'document')
      .toList();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Stack(
        children: [
          const Wallpaper(),

          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(90),
              child: Appbar(user: widget.user),
            ),

            body: SafeArea(
              top: false,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 120,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Gallery",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -1,
                                      ),
                                ),
                                Text(
                                  "0/50 Images • 1/30 Video links",
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppColors.textPrimary,
                                        fontSize: 10,
                                      ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        AddMediaPage(user: widget.user),
                                  ),
                                );
                              },
                              child: Container(
                                width: 120,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Add Media",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

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
                                  Icon(Icons.image_outlined, size: 17),
                                  SizedBox(width: 5),
                                  Text(
                                    "Images",
                                    style: Theme.of(context).textTheme.bodySmall
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
                                  Icon(
                                    Icons.video_collection_outlined,
                                    size: 17,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "Videos",
                                    style: Theme.of(context).textTheme.bodySmall
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
                                  Icon(Icons.document_scanner, size: 17),
                                  SizedBox(width: 5),
                                  Text(
                                    "Docs",
                                    style: Theme.of(context).textTheme.bodySmall
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

                        const SizedBox(height: 20),

                        /// ✅ ONLY THIS SCROLLS
                        Expanded(
                          child: TabBarView(
                            children: [
                              /// TAB 1
                              ImageTab(mediaList: imageList),

                              /// TAB 2
                              VideoTab(mediaList: videoList),

                              DocTab(mediaList: docList),
                            ],
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
    );
  }
}

class DocTab extends StatelessWidget {
  final List<MediaEntity> mediaList;
  const DocTab({super.key, required this.mediaList});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardSecondaryBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardSecondaryBorder),
      ),
      child: ListView.builder(
        itemCount: mediaList.length,
        itemBuilder: (_, i) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.cardSecondaryBg,
              border: Border.all(color: AppColors.cardSecondaryBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.cardSecondaryBorder,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.document_scanner,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Title: ${mediaList[i].title}\nType: ${mediaList[i].mimeType}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    context.read<MediaBloc>().add(
                      DeleteMediaEvent(mediaId: mediaList[i].id),
                    );
                  },
                  icon: Icon(Icons.delete, color: AppColors.error),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class VideoTab extends StatelessWidget {
  final List<MediaEntity> mediaList;
  const VideoTab({super.key, required this.mediaList});

  /// Extract YouTube video ID from various URL formats
  String? _extractYoutubeId(String url) {
    try {
      // Handle youtube.com/watch?v=...
      if (url.contains('watch?v=')) {
        return url.split('watch?v=')[1].split('&')[0];
      }
      // Handle youtu.be/...
      if (url.contains('youtu.be/')) {
        return url.split('youtu.be/')[1].split('?')[0];
      }
      // Handle youtube.com/embed/...
      if (url.contains('embed/')) {
        return url.split('embed/')[1].split('?')[0];
      }
      // Handle youtube.com/v/...
      if (url.contains('/v/')) {
        return url.split('/v/')[1].split('?')[0];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Open YouTube video
  Future<void> _openYoutubeVideo(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } else {
        print('Could not launch $url');
      }
    } catch (e) {
      print('Error opening YouTube: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardSecondaryBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardSecondaryBorder),
      ),
      child: ListView.builder(
        itemCount: mediaList.length,
        itemBuilder: (_, i) {
          final videoUrl = mediaList[i].url;
          final videoId = _extractYoutubeId(videoUrl);
          final thumbnailUrl =
              'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

          return Stack(
            children: [
              GestureDetector(
                onTap: () => _openYoutubeVideo(videoUrl),
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
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.cardPrimaryBg,
                              child: const Center(
                                child: Icon(
                                  Icons.video_library,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Play button overlay
                      Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
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
              ),
              Positioned(
                top: -8,
                right: -8,
                child: IconButton(
                  onPressed: () {
                    context.read<MediaBloc>().add(
                      DeleteMediaEvent(mediaId: mediaList[i].id),
                    );
                  },
                  icon: Icon(Icons.delete, color: AppColors.error),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ImageTab extends StatelessWidget {
  final List<MediaEntity> mediaList;
  const ImageTab({super.key, required this.mediaList});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardSecondaryBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardSecondaryBorder),
      ),
      child: GridView.builder(
        itemCount: mediaList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (_, i) {
          return Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.cardPrimaryBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(mediaList[i].url, fit: BoxFit.cover),
                  ),
                ),
              ),
              Positioned(
                top: -8,
                right: -8,
                child: IconButton(
                  onPressed: () {
                    print("Deleting media with ID: ${mediaList[i].id}");
                    context.read<MediaBloc>().add(
                      DeleteMediaEvent(mediaId: mediaList[i].id),
                    );
                  },
                  icon: Icon(Icons.delete, color: AppColors.error),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
