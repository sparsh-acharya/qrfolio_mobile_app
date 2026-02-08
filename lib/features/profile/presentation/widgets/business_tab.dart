import 'package:flutter/material.dart';
import 'package:qr_folio/core/theme/app_colors.dart';
import 'package:qr_folio/core/widgets/textfieldcard.dart';

class BusinessTab extends StatefulWidget {
  const BusinessTab({super.key});

  @override
  State<BusinessTab> createState() => _BusinessTabState();
}

class _BusinessTabState extends State<BusinessTab> {
  String company = 'Acme Corporation';
  String position = 'Senior Developer';
  String department = 'Engineering';
  String website = 'www.acmecorp.com';
  String office = '123 Business St, NY';


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
          TextFieldCard(label: 'Company', value: company, icon: Icons.business, onSave: (value) => setState(() => company = value)),
          const SizedBox(height: 12),
          TextFieldCard(label: 'Position', value: position, icon: Icons.badge, onSave: (value) => setState(() => position = value)),
          const SizedBox(height: 12),
          TextFieldCard(label: 'Department', value: department, icon: Icons.engineering, onSave: (value) => setState(() => department = value)),
          const SizedBox(height: 12),
          TextFieldCard(label: 'Website', value: website, icon: Icons.language, onSave: (value) => setState(() => website = value)),
          const SizedBox(height: 12),
          TextFieldCard(label: 'Office', value: office, icon: Icons.location_city, onSave: (value) => setState(() => office = value)),
          const SizedBox(height: 50),

        ],
      ),
    );
  }


}
