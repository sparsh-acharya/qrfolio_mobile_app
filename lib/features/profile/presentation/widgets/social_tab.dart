import 'package:flutter/material.dart';
import 'package:qr_folio/core/theme/app_colors.dart';
import 'package:qr_folio/core/widgets/textfieldcard.dart';

class SocialTab extends StatefulWidget {
  const SocialTab({super.key});

  @override
  State<SocialTab> createState() => _SocialTabState();
}

class _SocialTabState extends State<SocialTab> {
  String twitter = '@johndoe';
  String linkedin = 'linkedin.com/in/johndoe';
  String instagram = '@johndoe';
  String facebook = 'johndoe';
  String github = 'johndoeCode';
  String whatsapp = '+1234567890';
  String website = 'www.johndoe.com';

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
            value: twitter,
            icon: Icons.alternate_email,
            onSave: (value) => setState(() => twitter = value),
          ),
          const SizedBox(height: 12),
          TextFieldCard(
            label: 'LinkedIn',
            value: linkedin,
            icon: Icons.work,
            onSave: (value) => setState(() => linkedin = value),
          ),
          const SizedBox(height: 12),
          TextFieldCard(
            label: 'Instagram',
            value: instagram,
            icon: Icons.photo_camera,
            onSave: (value) => setState(() => instagram = value),
          ),
          const SizedBox(height: 12),
          TextFieldCard(
            label: 'Facebook',
            value: facebook,
            icon: Icons.facebook,
            onSave: (value) => setState(() => facebook = value),
          ),
          const SizedBox(height: 12),
          TextFieldCard(
            label: 'Github',
            value: github,
            icon: Icons.code,
            onSave: (value) => setState(() => github = value),
          ),
          const SizedBox(height: 12),
          TextFieldCard(
            label: 'Whatsapp',
            value: whatsapp,
            icon: Icons.chat,
            onSave: (value) => setState(() => whatsapp = value),
            validator: (value) {
              if (value.length < 10) return 'Invalid phone number';
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFieldCard(
            label: 'Personal Website',
            value: website,
            icon: Icons.language,
            onSave: (value) => setState(() => website = value),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
