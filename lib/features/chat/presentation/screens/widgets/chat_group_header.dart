import 'package:shule_direct/core/constants/import_files.dart';

class ChatGroupHeader extends StatelessWidget {
  final String groupName;
  final int onlineCount;
  final VoidCallback onBack;

  const ChatGroupHeader({
    super.key,
    required this.groupName,
    required this.onlineCount,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onBack,
                  child: const Icon(
                    Icons.arrow_back,
                    size: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 4),
                const AppText(
                  'Group Chat',
                  fontSize: 12,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios_rounded, size: 10),
                const SizedBox(width: 4),
                Flexible(
                  child: AppText(
                    groupName,
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios_rounded, size: 10),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 4, 12),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    AppAvatarInitial(
                      name: groupName,
                      radius: 22,
                      backgroundColor: AppColors.avtarColor,
                      textColor: AppColors.primary,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppColors.onlineGreen,
                          shape: BoxShape.circle,
                          border:
                          Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        groupName,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const SizedBox(width: 4),
                          AppText(
                            '$onlineCount Online',
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
                    size: 22,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(
                    Icons.person_add_outlined,
                    color: AppColors.textSecondary,
                    size: 22,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
