import 'package:file_picker/file_picker.dart';
import 'package:shule_direct/core/constants/import_files.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class MessageInputBar extends StatefulWidget {
  final Future<String?> Function(String text) onSend;
  final FocusNode? focusNode;

  const MessageInputBar({
    super.key,
    required this.onSend,
    this.focusNode,
  });

  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final error = await widget.onSend(text);
    if (error == null && mounted) {
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppTextField(
              controller: _controller,
              focusNode: widget.focusNode,
              hintText: 'Enter Message...',
              fillColor: Colors.white,
              textCapitalization: TextCapitalization.sentences,
              borderRadius: 24,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey, width: 0.5)),
              onSubmitted: (_) => _handleSend(),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.attach_file, color: AppColors.primary),
            onPressed: () {
              _openAttachSheet();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.emoji_emotions_outlined,
              color: AppColors.primary,
            ),
            onPressed: () {
              _openEmojiSheet();
            },
          ),
          const SizedBox(width: 4),
          Material(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: _handleSend,
              borderRadius: BorderRadius.circular(10),
              child: const SizedBox(
                width: 42,
                height: 42,
                child: Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openEmojiSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SizedBox(
        height: 320,
        child: EmojiPicker(
          textEditingController: _controller,
          config: const Config(
            height: 320,
            emojiViewConfig: EmojiViewConfig(
              emojiSizeMax: 28,
              columns: 8,
            ),
            categoryViewConfig: CategoryViewConfig(
              initCategory: Category.SMILEYS,
            ),
          ),
        ),
      ),
    );
  }
  void _openAttachSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              'Share File',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _attachOption(
                  icon: Icons.insert_drive_file,
                  label: 'Document',
                  color: Colors.blue,
                  onTap: () async {
                    Navigator.pop(context);
                    await FilePicker.platform.pickFiles(
                      type: FileType.any,
                    );
                  },
                ),
                _attachOption(
                  icon: Icons.image,
                  label: 'Gallery',
                  color: Colors.purple,
                  onTap: () async {
                    Navigator.pop(context);
                    await FilePicker.platform.pickFiles(
                      type: FileType.image,
                    );
                  },
                ),
                _attachOption(
                  icon: Icons.videocam,
                  label: 'Video',
                  color: Colors.red,
                  onTap: () async {
                    Navigator.pop(context);
                    await FilePicker.platform.pickFiles(
                      type: FileType.video,
                    );
                  },
                ),
                _attachOption(
                  icon: Icons.audiotrack,
                  label: 'Audio',
                  color: Colors.orange,
                  onTap: () async {
                    Navigator.pop(context);
                    await FilePicker.platform.pickFiles(
                      type: FileType.audio,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _attachOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          AppText(
            label,
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
