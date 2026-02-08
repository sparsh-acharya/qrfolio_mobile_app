import 'package:flutter/material.dart';
import 'package:qr_folio/core/theme/app_colors.dart';

class ImageCara extends StatelessWidget {
  const ImageCara({
    super.key,
    required PageController carouselController,
    required List<String> carouselImages,
  }) : _carouselController = carouselController,
       _carouselImages = carouselImages;

  final PageController _carouselController;
  final List<String> _carouselImages;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _carouselController,
      padEnds: false,
      itemCount: _carouselImages.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              _carouselImages[index],
              fit: BoxFit.cover,
              errorBuilder: (context, _, _) => Container(
                color: AppColors.backgroundPrimary,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.broken_image,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
