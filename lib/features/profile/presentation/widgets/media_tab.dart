import 'package:flutter/material.dart';
import 'package:qr_folio/core/theme/app_colors.dart';
import 'package:qr_folio/features/home/presentation/pages/home.dart';
import 'package:qr_folio/features/home/presentation/widgets/imagecara.dart';
import 'package:url_launcher/url_launcher.dart';

class MediaTab extends StatelessWidget {
  MediaTab({super.key});
  final PageController _carouselController = PageController(
    viewportFraction: 0.8,
  );
  final List<String> _carouselImages = [
    'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=1000&q=80',
    'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=1000&q=80',
    'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=1000&q=80',
  ];
  final List<VideoItem> videos = [
    VideoItem(youtubeUrl: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"),
    VideoItem(youtubeUrl: "https://www.youtube.com/watch?v=3JZ_D3ELwOQ"),
    VideoItem(youtubeUrl: "https://www.youtube.com/watch?v=l9nh1l8ZIJQ"),
  ];
  Future<void> openYoutube(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      _showError(context, 'Invalid video URL');
      return;
    }

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      _showError(context, 'Could not open YouTube');
    }
  }
   void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
            'Image Library',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: ImageCara(
              carouselController: _carouselController,
              carouselImages: _carouselImages,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Video Library',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return SizedBox(
                  width: 300,

                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: VideoCard(
                      video: video,
                      onTap: () {
                        openYoutube(context, video.youtubeUrl);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      ),
    );
  }
}
