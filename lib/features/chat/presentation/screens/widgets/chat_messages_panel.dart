import 'package:shule_direct/core/constants/import_files.dart';

class ChatMessagesPanel extends StatelessWidget {
  final Widget child;

  const ChatMessagesPanel({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 0.9;

    return Center(
      child: Container(
        width: width,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: child,
        ),
      ),
    );
  }
}
