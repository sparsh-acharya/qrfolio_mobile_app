import 'package:flutter/material.dart';
import 'package:qr_folio/core/theme/app_colors.dart';

class TextFieldCard extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final Function(String) onSave;
  final bool editable;
  final String? Function(String value)? validator;

  const TextFieldCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.onSave,
    this.editable = true,
    this.validator,
  });

  @override
  State<TextFieldCard> createState() => _TextFieldCardState();
}

class _TextFieldCardState extends State<TextFieldCard> {
  Future<void> _editField(
    String label,
    String currentValue,
    Function(String) onSave, {
    String? Function(String value)? validator,
  }) async {
    if (!mounted) return;

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        final controller = TextEditingController(text: widget.value);
        final formKey = GlobalKey<FormState>();

        return AlertDialog(
          backgroundColor: AppColors.cardSecondaryBg,
          title: Text(
            'Edit ${widget.label}',
            style: const TextStyle(color: AppColors.textPrimary),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              style: const TextStyle(color: AppColors.textPrimary),
              validator: widget.validator == null
                  ? null
                  : (value) => widget.validator!(value ?? ''),
              decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: const TextStyle(color: AppColors.textTertiary),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColors.cardSecondaryBorder,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.cardSecondaryBorder),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.textTertiary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(dialogContext, controller.text);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: AppColors.textOnPrimary,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (result != null && result.isNotEmpty) {
      widget.onSave(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
        ),
        const SizedBox(height: 5),
        Container(
          height: 50,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.cardSecondaryBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cardSecondaryBg),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  widget.icon,
                  color: AppColors.iconTertiary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Positioned(
                left: 35,
                top: 5,
                child: SizedBox(
                  width: 170,
                  child: Text(
                    widget.value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ),
              if (widget.editable)
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    color: AppColors.iconTertiary,
                    onPressed: () => _editField(
                      widget.label,
                      widget.value,
                      widget.onSave,
                      validator: widget.validator,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
