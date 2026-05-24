import 'package:shule_direct/core/constants/import_files.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final ValueChanged<String>? onSubmitted;
  final TextCapitalization textCapitalization;
  final EdgeInsetsGeometry? contentPadding;
  final double borderRadius;
  final Color? fillColor;
  final InputBorder? border;
  final FocusNode? focusNode;

  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.onSubmitted,
    this.textCapitalization = TextCapitalization.none,
    this.contentPadding,
    this.borderRadius = 8,
    this.fillColor = AppColors.inputFill,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        filled: fillColor != null,
        fillColor: fillColor,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
        suffixIcon: suffixIcon,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
        enabledBorder: border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
        focusedBorder: border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
      ),
    );
  }
}

class AppLabeledField extends StatelessWidget {
  final String label;
  final AppTextField field;

  const AppLabeledField({
    super.key,
    required this.label,
    required this.field,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          label,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 8),
        field,
      ],
    );
  }
}

