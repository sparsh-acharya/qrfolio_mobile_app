import 'package:flutter/material.dart';
import 'package:qr_folio/core/theme/app_colors.dart';
import 'package:qr_folio/core/widgets/textfieldcard.dart';

class SocialTab extends StatefulWidget {
  final String twitter;
  final String linkedin;
  final String instagram;
  final String facebook;
  final String github;
  final String whatsapp;
  final String website;
  final Function(String key, dynamic value)? onUpdate;
  const SocialTab({
    super.key,
    required this.twitter,
    required this.linkedin,
    required this.instagram,
    required this.facebook,
    required this.github,
    required this.whatsapp,
    required this.website,
    this.onUpdate,
  });

  @override
  State<SocialTab> createState() => _SocialTabState();
}

class _SocialTabState extends State<SocialTab>
    with SingleTickerProviderStateMixin {
  late String _twitter;
  late String _linkedin;
  late String _instagram;
  late String _facebook;
  late String _github;
  late String _whatsapp;
  late String _website;

  late final AnimationController _animController;
  late final List<Animation<double>> _fadeAnims;
  late final List<Animation<Offset>> _slideAnims;

  static const _itemCount = 8;

  @override
  void initState() {
    super.initState();
    _twitter = widget.twitter;
    _linkedin = widget.linkedin;
    _instagram = widget.instagram;
    _facebook = widget.facebook;
    _github = widget.github;
    _whatsapp = widget.whatsapp;
    _website = widget.website;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnims = List.generate(_itemCount, (i) {
      final start = i * 0.08;
      final end = (start + 0.35).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _animController,
        curve: Interval(start, end, curve: Curves.easeOut),
      );
    });

    _slideAnims = List.generate(_itemCount, (i) {
      final start = i * 0.08;
      final end = (start + 0.35).clamp(0.0, 1.0);
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
    _animController.dispose();
    super.dispose();
  }

  Widget _animatedItem(int index, Widget child) {
    return FadeTransition(
      opacity: _fadeAnims[index],
      child: SlideTransition(position: _slideAnims[index], child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          _animatedItem(
            0,
            Text(
              'Social Links',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _animatedItem(
            1,
            TextFieldCard(
              label: 'Twitter',
              value: _twitter,
              icon: Icons.alternate_email,
              onSave: (value) => setState(() {
                _twitter = value;
                widget.onUpdate?.call('twitter', value);
              }),
            ),
          ),
          const SizedBox(height: 12),
          _animatedItem(
            2,
            TextFieldCard(
              label: 'LinkedIn',
              value: _linkedin,
              icon: Icons.work,
              onSave: (value) => setState(() {
                _linkedin = value;
                widget.onUpdate?.call('linkedin', value);
              }),
            ),
          ),
          const SizedBox(height: 12),
          _animatedItem(
            3,
            TextFieldCard(
              label: 'Instagram',
              value: _instagram,
              icon: Icons.photo_camera,
              onSave: (value) => setState(() {
                _instagram = value;
                widget.onUpdate?.call('instagram', value);
              }),
            ),
          ),
          const SizedBox(height: 12),
          _animatedItem(
            4,
            TextFieldCard(
              label: 'Facebook',
              value: _facebook,
              icon: Icons.facebook,
              onSave: (value) => setState(() {
                _facebook = value;
                widget.onUpdate?.call('facebook', value);
              }),
            ),
          ),
          const SizedBox(height: 12),
          _animatedItem(
            5,
            TextFieldCard(
              label: 'Github',
              value: _github,
              icon: Icons.code,
              onSave: (value) => setState(() {
                _github = value;
                widget.onUpdate?.call('github', value);
              }),
            ),
          ),
          const SizedBox(height: 12),
          _animatedItem(
            6,
            TextFieldCard(
              label: 'Whatsapp',
              value: _whatsapp,
              icon: Icons.chat,
              onSave: (value) => setState(() {
                _whatsapp = value;
                widget.onUpdate?.call('whatsapp', value);
              }),
            ),
          ),
          const SizedBox(height: 12),
          _animatedItem(
            7,
            TextFieldCard(
              label: 'Personal Website',
              value: _website,
              icon: Icons.language,
              onSave: (value) => setState(() {
                _website = value;
                widget.onUpdate?.call('website', value);
              }),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
