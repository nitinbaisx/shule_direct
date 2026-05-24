import 'package:shule_direct/core/constants/import_files.dart';

class ConversationListScreen extends StatelessWidget {
  const ConversationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ConversationCubit>()..loadConversations(),
      child: AppStatusBarScaffold.primary(
        appBar: const CommonAppbar(),
        body: BlocBuilder<ConversationCubit, ConversationState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ConversationHeader(),
                const SizedBox(
                  height: 8,
                ),
                const ConversationSearchBar(),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: AppText(
                    'Recent',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(child: _buildBody(context, state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ConversationState state) {
    if (state is ConversationLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (state is ConversationEmpty) {
      return const  Center(
        child:  AppText(
          'No groups found',
          fontSize: 13,
          color: AppColors.textSecondary,
        ),
      );
    }
    if (state is ConversationError) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                state.message,
                fontSize: 13,
                color: AppColors.errorColor,
              ),
              const SizedBox(height: 12),
              AppPrimaryButton(
                label: 'Retry',
                onPressed: () =>
                    context.read<ConversationCubit>().loadConversations(),
              ),
            ],
          ),
        ),
      );
    }
    if (state is ConversationLoaded) {
      return ListView.separated(
        itemCount: state.conversations.length,
        separatorBuilder: (_, __) => const Divider(
          height: 1,
          indent: 72,
          color: AppColors.divider,
        ),
        itemBuilder: (context, index) {
          final conv = state.conversations[index];
          return ConversationTile(
            conversation: conv,
            onTap: () => context.push('/chat/${conv.id}', extra: conv.name),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }
}
