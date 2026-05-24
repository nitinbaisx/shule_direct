import 'package:shule_direct/core/constants/import_files.dart';

class ConversationHeader extends StatelessWidget {
  const ConversationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          const AppText(
            'Groups',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                AppText(
                  'Form - 1',
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
