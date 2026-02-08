import 'package:flutter/material.dart';
import 'package:qr_folio/core/theme/app_colors.dart';
import 'package:qr_folio/core/widgets/textfieldcard.dart';

class InfoTab extends StatefulWidget {
  const InfoTab({super.key});

  @override
  State<InfoTab> createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
  String name = 'John Doe';
  String phone = '+1 234 567 8900';
  String email = 'john.doe@example.comdfghjkjhgfdsfghjkjhgf';
  String location = 'New York, USA';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),

          Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          TextFieldCard(
            label: 'Name',
            value: name,
            icon: Icons.person,
            onSave: (value) => setState(() => name = value),
          ),
          const SizedBox(height: 12),
          TextFieldCard(
            label: 'Phone',
            value: phone,
            icon: Icons.phone,
            onSave: (value) => setState(() => phone = value),
            validator: (value) {
              if (value.length < 11) return 'Invalid phone number';
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFieldCard(
            label: 'Email',
            value: email,
            icon: Icons.email,
            onSave: (value) => setState(() => email = value),
            validator: emailValidator,
          ),
          const SizedBox(height: 12),
          TextFieldCard(
            label: 'Location',
            value: location,
            icon: Icons.location_on,
            onSave: (value) => setState(() => location = value),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

String? emailValidator(String value) {
  if (value.trim().isEmpty) {
    return 'Email is required';
  }

  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  if (!emailRegex.hasMatch(value.trim())) {
    return 'Enter a valid email address';
  }

  return null; // ✅ valid
}
