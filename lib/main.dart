import 'package:flutter/services.dart';
import 'package:shule_direct/core/constants/app_system_ui.dart';
import 'package:shule_direct/core/constants/import_files.dart';
import 'package:shule_direct/core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(AppSystemUi.lightStatusBar);
  await initDependencies();
  runApp(const ShuleDirectApp());
}

class ShuleDirectApp extends StatelessWidget {
  const ShuleDirectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Shule Direct',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: AppSystemUi.lightStatusBar,
        ),
      ),
      routerConfig: appRouter,
    );
  }
}
