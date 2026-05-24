import 'package:shule_direct/core/constants/import_files.dart';
import 'package:timeago/timeago.dart' as timeago;

class ConversationTile extends StatelessWidget {
  final ConversationEntity conversation;
  final VoidCallback onTap;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.primary,
            backgroundImage: conversation.avatarUrl != null
                ? CachedNetworkImageProvider(conversation.avatarUrl!)
                : null,
            child: conversation.avatarUrl == null
                ? Text(
              conversation.name.isNotEmpty
                  ? conversation.name[0].toUpperCase()
                  : 'G',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )
                : null,
          ),
          if (conversation.isOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.onlineGreen,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        conversation.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        conversation.lastMessage.isNotEmpty
            ? conversation.lastMessage
            : 'Start the conversation',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: conversation.lastMessageTime.isNotEmpty
          ? Text(
        _formatTime(conversation.lastMessageTime),
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      )
          : null,
    );
  }

  String _formatTime(String isoTime) {
    try {
      final dt = DateTime.parse(isoTime);
      return timeago.format(dt, locale: 'en_short');
    } catch (_) {
      return '';
    }
  }
}