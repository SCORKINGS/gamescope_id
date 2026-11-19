import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi locale Indonesia untuk intl
  await initializeDateFormatting('id', null);
  runApp(const GameScopeApp());
}

class GameScopeApp extends StatelessWidget {
  const GameScopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GameScope ID',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
      // Aktifkan scroll behavior berbasis mouse untuk Flutter Web
      scrollBehavior: const _WebScrollBehavior(),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.bgPrimary,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.bgSurface,
        primary: AppColors.accentLime,
        secondary: AppColors.accentOrange,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgSurface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textPrimary),
        bodyMedium: TextStyle(color: AppColors.textPrimary),
        bodySmall: TextStyle(color: AppColors.textSecondary),
      ),
      dividerColor: AppColors.divider,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.accentLime,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.bgElevated,
        contentTextStyle: TextStyle(color: AppColors.textPrimary),
      ),
    );
  }
}

// Scroll behavior untuk mendukung drag mouse di Flutter Web
class _WebScrollBehavior extends MaterialScrollBehavior {
  const _WebScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
