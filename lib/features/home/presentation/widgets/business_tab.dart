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

class _BusinessTabState extends State<BusinessTab>
    with SingleTickerProviderStateMixin {
  late String _company;
  late String _position;
  late String _referalCode;
  late String _experience;
  late String _summary;
  late String _companyEmail;
  late String _location;
  late String _description;

  late final AnimationController _animController;
  late final List<Animation<double>> _fadeAnims;
  late final List<Animation<Offset>> _slideAnims;

  static const _itemCount = 9;

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
              'Business Information',
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
              label: 'Company',
              value: _company,
              icon: Icons.business,
              onSave: (value) {
                setState(() => _company = value);
                widget.onUpdate?.call('companyName', value);
              },
            ),
          ),
          const SizedBox(height: 12),
          _animatedItem(
            2,
            TextFieldCard(
              label: 'Position',
              value: _position,
              icon: Icons.badge,
              onSave: (value) {
                setState(() => _position = value);
                widget.onUpdate?.call('designation', value);
              },
            ),
          ),
          const SizedBox(height: 12),
          _animatedItem(
            3,
            TextFieldCard(
              label: 'Referal Code',
              value: _referalCode,
              icon: Icons.confirmation_num,
              onSave: (value) {
                setState(() => _referalCode = value);
                widget.onUpdate?.call('companyReferralCode', value);
              },
            ),
          ),
          const SizedBox(height: 12),
          _animatedItem(
            4,
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
          ),
          const SizedBox(height: 12),
          _animatedItem(
            5,
            TextFieldCard(
              label: 'Description',
              value: _description,
              icon: Icons.description,
              onSave: (value) {
                setState(() => _description = value);
                widget.onUpdate?.call('companyDescription', value);
              },
            ),
          ),
          const SizedBox(height: 12),
          _animatedItem(
            6,
            TextFieldCard(
              label: 'Professional Summary',
              value: _summary,
              icon: Icons.summarize,
              onSave: (value) {
                setState(() => _summary = value);
                widget.onUpdate?.call('description', value);
              },
            ),
          ),
          const SizedBox(height: 12),
          _animatedItem(
            7,
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
          ),
          const SizedBox(height: 12),
          _animatedItem(
            8,
            TextFieldCard(
              label: 'Location',
              value: _location,
              icon: Icons.location_city,
              onSave: (value) {
                setState(() => _location = value);
                widget.onUpdate?.call('companyAddress', value);
              },
            ),
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
