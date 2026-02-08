import 'package:flutter/material.dart';
import 'package:qr_folio/core/theme/app_colors.dart';
import 'package:qr_folio/core/widgets/appbar.dart';
import 'package:qr_folio/core/widgets/qr_id_chip.dart';
import 'package:qr_folio/core/widgets/share_profile_chip.dart';
import 'package:qr_folio/core/widgets/wallpaper.dart';
import 'package:qr_folio/features/home/presentation/widgets/imagecara.dart';
import 'package:qr_folio/core/widgets/navbar.dart';
import 'package:qr_folio/core/widgets/professional_detail_card.dart';
import 'package:qr_folio/features/home/presentation/widgets/profile_card.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final int _currentIndex = 0;
  final PageController _carouselController = PageController(
    viewportFraction: 0.8,
  );

  final List<String> _carouselImages = [
    'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=1000&q=80',
    'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=1000&q=80',
    'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=1000&q=80',
  ];
  final List<IconData> _professionalIcons = [Icons.business, Icons.person];
  final List<String> skills = [
    "Flutter Development",
    "Dart",
    "Firebase",
    "Node.js",
    "PostgreSQL",
    "MongoDB",
    "System Design",
    "REST APIs",
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Wallpaper(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(90),
            child: Appbar(),
          ),
          body: SafeArea(
            top: false,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Scrollable main content
                SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    bottom: 120,
                    left: 20,
                    right: 20,
                    top: 10,
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Welcome Back, Sparsh!",

                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      ProfileCard(),

                      const SizedBox(height: 20),
                      Row(
                        children: [
                          QrIDChip(),
                          const SizedBox(width: 10),
                          ShareProfileChip(),
                        ],
                      ),

                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Professional Details",
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                  ),
                                ),

                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.edit),
                                  iconSize: 20,
                                  color: AppColors.primaryBlueLight,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ProfessionalDetailsContainer(
                              companyName: "edihub.in",
                              designation: "Creative Head",
                              experience: "6 Years",
                              referralCode: "EDI21DRO2",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Professional Summary",
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                  ),
                                ),

                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.edit),
                                  iconSize: 20,
                                  color: AppColors.primaryBlueLight,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "We create visually stunning and engaging content. As a team of passionate creatives and expert editors, we specialize in transforming raw footage into captivating visual narratives that engage, inspire, and leave a lasting impact.",
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 12,
                                height: 1.5,
                              ),
                            ),
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
    );
  }
}





String getYoutubeId(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return "";

  // Handle youtu.be/<id>
  if (uri.host.contains('youtu.be') && uri.pathSegments.isNotEmpty) {
    return uri.pathSegments.first;
  }

  // Handle youtube.com/watch?v=<id>
  if (uri.queryParameters['v'] != null) {
    return uri.queryParameters['v'] ?? "";
  }

  // Handle youtube.com/embed/<id> or /v/<id>
  if (uri.pathSegments.length >= 2 &&
      (uri.pathSegments[0] == 'embed' || uri.pathSegments[0] == 'v')) {
    return uri.pathSegments[1];
  }

  // Fallback regex
  final regExp = RegExp(r"(?:v=|\/)([0-9A-Za-z_-]{11})");
  final match = regExp.firstMatch(url);
  return match != null ? match.group(1) ?? "" : "";
}

class VideoItem {
  final String youtubeUrl;

  VideoItem({required this.youtubeUrl});

  String get videoId => getYoutubeId(youtubeUrl);

  String get thumbnail => "https://img.youtube.com/vi/$videoId/hqdefault.jpg";
}

class VideoCard extends StatelessWidget {
  final VideoItem video;
  final VoidCallback onTap;

  const VideoCard({super.key, required this.video, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                video.thumbnail,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),

              Container(color: Colors.black.withOpacity(0.25)),

              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SkillChips extends StatelessWidget {
  final List<String> skills;

  const SkillChips({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: skills.map((skill) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primaryBlue, width: 1),
          ),
          child: Text(
            skill,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryBlue,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class ProfInfoCard extends StatelessWidget {
  const ProfInfoCard({
    super.key,
    required IconData professionalIcons,
    required this.label,
    required this.value,
  }) : _professionalIcons = professionalIcons;

  final IconData _professionalIcons;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: 140,
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.cardPrimaryBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardPrimaryBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(_professionalIcons, size: 50, color: AppColors.textSecondary),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
