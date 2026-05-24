import 'package:shule_direct/core/constants/import_files.dart';

class SystemMessage extends StatelessWidget {
  final String text;

  const SystemMessage({super.key, required this.text});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.groupColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: AppText(
          text,
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 13,
        ),
      ),
    );
  }
}
