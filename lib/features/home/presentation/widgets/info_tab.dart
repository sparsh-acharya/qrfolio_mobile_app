import 'package:flutter/material.dart';
import 'package:qr_folio/core/theme/app_colors.dart';
import 'package:qr_folio/core/widgets/textfieldcard.dart';

class InfoTab extends StatefulWidget {
  final String name;
  final String phone;
  final String email;
  final String location;
  final Function(String key, dynamic value)? onUpdate;
  const InfoTab({
    super.key,
    required this.name,
    required this.phone,
    required this.email,
    required this.location,
    this.onUpdate,
  });

  @override
  State<InfoTab> createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> with SingleTickerProviderStateMixin {
  late String _name;
  late String _phone;
  late String _email;
  late String _location;

  late final AnimationController _animController;
  late final List<Animation<double>> _fadeAnims;
  late final List<Animation<Offset>> _slideAnims;

  static const _itemCount = 5;

  @override
  void initState() {
    super.initState();
    _name = widget.name;
    _phone = widget.phone;
    _email = widget.email;
    _location = widget.location;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnims = List.generate(_itemCount, (i) {
      final start = i * 0.12;
      final end = (start + 0.4).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _animController,
        curve: Interval(start, end, curve: Curves.easeOut),
      );
    });

    _slideAnims = List.generate(_itemCount, (i) {
      final start = i * 0.12;
      final end = (start + 0.4).clamp(0.0, 1.0);
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
              'Personal Information',
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
              editable: false,
              label: 'Name',
              value: _name,
              icon: Icons.person,
            ),
          ),
          const SizedBox(height: 12),
          _animatedItem(
            2,
            TextFieldCard(
              label: 'Phone',
              value: _phone,
              icon: Icons.phone,
              onSave: (value) {
                setState(() => _phone = value);
                widget.onUpdate?.call('phone', value.toString());
              },
              validator: (value) {
                if (value.length < 11) return 'Invalid phone number';
                return null;
              },
            ),
          ),
          const SizedBox(height: 12),
          _animatedItem(
            3,
            TextFieldCard(
              editable: false,
              label: 'Email',
              value: _email,
              icon: Icons.email,
            ),
          ),
          const SizedBox(height: 12),
          _animatedItem(
            4,
            TextFieldCard(
              label: 'Location',
              value: _location,
              icon: Icons.location_on,
              onSave: (value) {
                setState(() => _location = value);
                widget.onUpdate?.call('address', value);
              },
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
