import 'package:shule_direct/core/constants/import_files.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final VoidCallback? onMoreTap;

  const MessageBubble({
    super.key,
    required this.message,
    this.onMoreTap,
  });

  static const double _bubbleRadius = 12;
  static const double _maxBubbleWidthFactor = 0.72;

  @override
  Widget build(BuildContext context) {
    final maxWidth =
        MediaQuery.sizeOf(context).width * _maxBubbleWidthFactor;
    return message.isMe
        ? _sentBubble(maxWidth)
        : _receivedBubble(maxWidth);
  }

  Widget _sentBubble(double maxWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _actionIcons(),
            const SizedBox(width: 8),
            Flexible(
              child: _messageColumn(
                maxWidth: maxWidth,
                bubbleColor: AppColors.sentBubble,
                textColor: AppColors.sentBubbleText,
                meta: _sentMeta(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _receivedBubble(double maxWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _senderAvatar(),
            const SizedBox(width: 8),
            Flexible(
              child: _messageColumn(
                maxWidth: maxWidth,
                bubbleColor: AppColors.receivedBubble,
                textColor: AppColors.receivedBubbleText,
                meta: _receivedMeta(),
              ),
            ),
            const SizedBox(width: 8),
            _actionIcons(),
          ],
        ),
      ),
    );
  }

  Widget _messageColumn({
    required double maxWidth,
    required Color bubbleColor,
    required Color textColor,
    required Widget meta,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _bubble(
              color: bubbleColor,
              textColor: textColor,
              isReceived: bubbleColor == AppColors.receivedBubble,
            ),
            const SizedBox(height: 6),
            meta,
          ],
        ),
      ),
    );
  }

  Widget _bubble({
    required Color color,
    required Color textColor,
    bool isReceived = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(_bubbleRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.replyTo != null)
            _replySnippet(message.replyTo!, isReceived: isReceived),
          Text(
            message.content,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sentMeta() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _metaTime(),
       const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
             Icon(
              Icons.check,
              size: 14,
              color: AppColors.textSecondary,
            ),
             SizedBox(width: 4),
             AppText(
              'You',
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _receivedMeta() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: AppText(
            message.senderName,
            fontSize: 12,
            color: AppColors.textSecondary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        _metaTime(),
      ],
    );
  }

  Widget _actionIcons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.emoji_emotions_outlined,
            size: 20,
            color: AppColors.textSecondary.withOpacity(0.8),
          ),
          const SizedBox(width: 2),
          if (onMoreTap != null)
            GestureDetector(
              onTap: onMoreTap,
              child: Icon(
                Icons.more_vert,
                size: 20,
                color: AppColors.textSecondary.withOpacity(0.8),
              ),
            ),
        ],
      ),
    );
  }

  Widget _metaTime() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.access_time,
          size: 14,
          color: AppColors.textSecondary.withOpacity(0.9),
        ),
        const SizedBox(width: 4),
        AppText(
          _formatTime(message.createdAt),
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }

  Widget _senderAvatar() {
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.avtarColor,
      backgroundImage: message.senderAvatar != null
          ? CachedNetworkImageProvider(message.senderAvatar!)
          : null,
      child: message.senderAvatar == null
          ? AppText(
              message.senderName.isNotEmpty
                  ? message.senderName[0].toUpperCase()
                  : 'U',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            )
          : null,
    );
  }

  Widget _replySnippet(MessageEntity reply, {required bool isReceived}) {
    final labelColor =
        isReceived ? Colors.white.withOpacity(0.9) : AppColors.textSecondary;
    final bodyColor =
        isReceived ? Colors.white.withOpacity(0.75) : AppColors.textSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isReceived
            ? Colors.white.withOpacity(0.15)
            : Colors.black.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: isReceived ? Colors.white70 : AppColors.primary,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            _getReplyName(reply),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: labelColor,
          ),
          const SizedBox(height: 2),
          AppText(
            reply.content,
            fontSize: 11,
            color: bodyColor,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return DateFormat('HH:mm').format(dt);
  }
  String _getReplyName(MessageEntity reply) {
    if (reply.isMe) return 'You';
    if (reply.senderName.isNotEmpty &&
        reply.senderName != 'Unknown' &&
        reply.senderName != '') {
      return reply.senderName;
    }

    return 'Unknown';
  }
}
