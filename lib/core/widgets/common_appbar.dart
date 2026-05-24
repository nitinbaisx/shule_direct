import 'package:shule_direct/core/constants/app_system_ui.dart';
import 'package:shule_direct/core/constants/import_files.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: AppSystemUi.primaryStatusBar,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      flexibleSpace: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            height: kToolbarHeight,
            padding: const EdgeInsets.only(right: 4),
            child: Row(
              children: [
                const SizedBox(width: 8),
                const Icon(Icons.menu, color: Colors.black),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 0.5),
                      ),
                      child: const TextField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'Search here',
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
                      ),
                    ),
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                      icon: const Icon(
                        Icons.notifications_none,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                    const Positioned(
                      right: 6,
                      top: 6,
                      child: AppBadge(count: '3'),
                    ),
                  ],
                ),
                const AppAvatarInitial(
                  name: 'F',
                  radius: 16,
                  backgroundColor: Colors.black,
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
