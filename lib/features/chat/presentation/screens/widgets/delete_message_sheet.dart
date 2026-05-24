import 'package:shule_direct/core/constants/import_files.dart';

void showDeleteMessageSheet({
  required BuildContext context,
  required VoidCallback onDelete,
}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppText(
                'Delete message',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 8),
              const AppText(
                'Do you want to delete this message?',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const AppText(
                  'Cancel',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  onDelete();
                },
                child: const AppText(
                  'Delete',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.errorColor,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
