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

class _SocialTabState extends State<SocialTab> {
  late String _twitter;
  late String _linkedin;
  late String _instagram;
  late String _facebook;
  late String _github;
  late String _whatsapp;
  late String _website;

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
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),

          Text(
            'Social Links',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          TextFieldCard(
            label: 'Twitter',
            value: _twitter,
            icon: Icons.alternate_email,
            onSave: (value) => setState(() {
              _twitter = value;
              widget.onUpdate?.call('twitter', value);
            }),
          ),
          const SizedBox(height: 12),
          TextFieldCard(
            label: 'LinkedIn',
            value: _linkedin,
            icon: Icons.work,
            onSave: (value) => setState(() {
              _linkedin = value;
              widget.onUpdate?.call('linkedin', value);
            }),
          ),
          const SizedBox(height: 12),
          TextFieldCard(
            label: 'Instagram',
            value: _instagram,
            icon: Icons.photo_camera,
            onSave: (value) => setState(() {
              _instagram = value;
              widget.onUpdate?.call('instagram', value);
            }),
          ),
          const SizedBox(height: 12),
          TextFieldCard(
            label: 'Facebook',
            value: _facebook,
            icon: Icons.facebook,
            onSave: (value) => setState(() {
              _facebook = value;
              widget.onUpdate?.call('facebook', value);
            }),
          ),
          const SizedBox(height: 12),
          TextFieldCard(
            label: 'Github',
            value: _github,
            icon: Icons.code,
            onSave: (value) => setState(() {
              _github = value;
              widget.onUpdate?.call('github', value);
            }),
          ),
          const SizedBox(height: 12),
          TextFieldCard(
            label: 'Whatsapp',
            value: _whatsapp,
            icon: Icons.chat,
            onSave: (value) => setState(() {
              _whatsapp = value;
              widget.onUpdate?.call('whatsapp', value);
            }),
            
          ),
          const SizedBox(height: 12),
          TextFieldCard(
            label: 'Personal Website',
            value: _website,
            icon: Icons.language,
            onSave: (value) => setState(() {
              _website = value;
              widget.onUpdate?.call('website', value);
            }),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
