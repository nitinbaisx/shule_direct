import 'package:shule_direct/core/constants/import_files.dart';

class ConversationSearchBar extends StatelessWidget {
  const ConversationSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 0.5),
          ),
          child:  TextField(
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: 'Search messages or users',
              hintStyle: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              suffixIcon: Icon(
                Icons.search,
                color: AppColors.textSecondary,
                size: 18,
              ),
            ),
            onChanged: (value){
              context.read<ConversationCubit>().searchConversation(value);
            },
          ),
        ),
      ),
    );
  }
}
