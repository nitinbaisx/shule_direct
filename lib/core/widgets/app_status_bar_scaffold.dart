import 'package:flutter/services.dart';
import 'package:shule_direct/core/constants/app_system_ui.dart';
import 'package:shule_direct/core/constants/import_files.dart';

class AppStatusBarScaffold extends StatelessWidget {
  final SystemUiOverlayStyle overlayStyle;
  final Color statusBarColor;
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  const AppStatusBarScaffold({
    super.key,
    required this.overlayStyle,
    required this.statusBarColor,
    this.backgroundColor,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  factory AppStatusBarScaffold.primary({
    Key? key,
    PreferredSizeWidget? appBar,
    Color? backgroundColor,
    required Widget body,
    Widget? bottomNavigationBar,
    Widget? floatingActionButton,
  }) {
    return AppStatusBarScaffold(
      key: key,
      overlayStyle: AppSystemUi.primaryStatusBar,
      statusBarColor: AppColors.primary,
      backgroundColor: backgroundColor ?? AppColors.background,
      appBar: appBar,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }

  factory AppStatusBarScaffold.light({
    Key? key,
    required Widget body,
    Widget? bottomNavigationBar,
    Widget? floatingActionButton,
  }) {
    return AppStatusBarScaffold(
      key: key,
      overlayStyle: AppSystemUi.lightStatusBar,
      statusBarColor: Colors.white,
      backgroundColor: AppColors.background,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: ColoredBox(
        color: statusBarColor,
        child: Scaffold(
          backgroundColor: backgroundColor ?? statusBarColor,
          appBar: appBar,
          body: body,
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButton: floatingActionButton,
        ),
      ),
    );
  }
}
