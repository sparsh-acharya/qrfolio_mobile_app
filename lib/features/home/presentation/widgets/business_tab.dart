import 'package:flutter/material.dart';
import 'package:qr_folio/core/theme/app_colors.dart';
import 'package:qr_folio/core/widgets/textfieldcard.dart';

class BusinessTab extends StatefulWidget {
  final String company;
  final String position;
  final String referalCode;
  final String experience;
  final String description;
  final String summary;
  final String companyEmail;
  final String location;
  final Function(String key, dynamic value)? onUpdate;
  const BusinessTab({
    super.key,
    required this.company,
    required this.position,
    required this.referalCode,
    required this.companyEmail,
    required this.location,
    required this.experience,
    required this.description,
    this.onUpdate,
    required this.summary,
  });

  @override
  State<BusinessTab> createState() => _BusinessTabState();
}

class _BusinessTabState extends State<BusinessTab> {
  late String _company;
  late String _position;
  late String _referalCode;
  late String _experience;
  late String _summary;
  late String _companyEmail;
  late String _location;
  late String _description;
  @override
  void initState() {
    super.initState();
    _company = widget.company;
    _position = widget.position;
    _referalCode = widget.referalCode;
    _experience = widget.experience;
    _companyEmail = widget.companyEmail;
    _location = widget.location;
    _description = widget.description;
    _summary = widget.summary;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            'Business Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          TextFieldCard(
            label: 'Company',
            value: _company,
            icon: Icons.business,
            onSave: (value) {
              setState(() => _company = value);
              widget.onUpdate?.call('companyName', value);
            },
          ),
          const SizedBox(height: 12),
          TextFieldCard(
            label: 'Position',
            value: _position,
            icon: Icons.badge,
            onSave: (value) {
              setState(() => _position = value);
              widget.onUpdate?.call('designation', value);
            },
          ),
          const SizedBox(height: 12),
          TextFieldCard(
            label: 'Referal Code',
            value: _referalCode,
            icon: Icons.confirmation_num,
            onSave: (value) {
              setState(() => _referalCode = value);
              widget.onUpdate?.call('companyReferralCode', value);
            },
          ),
          const SizedBox(height: 12),
          TextFieldCard(
            keyboardType: TextInputType.number,
            label: 'Experience (in years)',
            value: _experience,
            icon: Icons.star_rate_outlined,
            onSave: (value) {
              setState(() => _experience = value);
              widget.onUpdate?.call('companyExperience', value);
            },
          ),
          const SizedBox(height: 12),
          TextFieldCard(
            label: 'Description',
            value: _description,
            icon: Icons.description,
            onSave: (value) {
              setState(() => _description = value);
              widget.onUpdate?.call('companyDescription', value);
            },
          ),
          const SizedBox(height: 12),
          TextFieldCard(
            label: 'Professional Summary',
            value: _summary,
            icon: Icons.summarize,
            onSave: (value) {
              setState(() => _summary = value);
              widget.onUpdate?.call('description', value);
            },
          ),
          const SizedBox(height: 12),
          TextFieldCard(
            keyboardType: TextInputType.emailAddress,
            label: 'Company Email',
            value: _companyEmail,
            icon: Icons.email,
            onSave: (value) {
              setState(() => _companyEmail = value);
              widget.onUpdate?.call('companyEmail', value);
            },
            validator: emailValidator,
          ),
          const SizedBox(height: 12),
          TextFieldCard(
            label: 'Location',
            value: _location,
            icon: Icons.location_city,
            onSave: (value) {
              setState(() => _location = value);
              widget.onUpdate?.call('companyAddress', value);
            },
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }

  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  if (!emailRegex.hasMatch(value)) {
    return 'Enter a valid email address';
  }

  return null; // ✅ valid
}
