import 'package:shule_direct/core/constants/import_files.dart';

class AppBadge extends StatelessWidget {
  final String count;

  const AppBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: const BoxDecoration(
        color: AppColors.badgeColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: AppText(count, fontSize: 9, color: Colors.white),
      ),
    );
  }
}
