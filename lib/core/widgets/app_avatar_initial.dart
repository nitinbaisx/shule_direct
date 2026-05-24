import 'package:shule_direct/core/constants/import_files.dart';

class AppAvatarInitial extends StatelessWidget {
  final String name;
  final double radius;
  final Color backgroundColor;
  final String fallback;
  final Color textColor;

  const AppAvatarInitial({
    super.key,
    required this.name,
    this.radius = 16,
    this.backgroundColor = AppColors.primary,
    this.fallback = 'G',
    this.textColor = Colors.white,
  });

  String get _initial {
    if (name.isEmpty) return fallback;
    return name[0].toUpperCase();
  }

  double get _fontSize => radius <= 16 ? 13 : (radius <= 20 ? 15 : 18);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: AppText(
        _initial,
        fontSize: _fontSize,
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
