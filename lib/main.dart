import 'package:flutter/material.dart';
import 'core/config/theme/app_theme.dart';
import 'core/services/app_init_service.dart';
import 'core/database/database_helper.dart';
import 'features/splash/presentation/pages/splash_screen.dart';

/// Main entry point of the BetterMuslim application
/// 
/// This app follows Clean Architecture principles with:
/// - Feature-driven modular structure
/// - BLoC for state management
/// - SQLite for local data persistence
/// - GetIt for dependency injection
/// 
/// University Final Project - Demonstrates:
/// - SOLID principles
/// - Clean code practices
/// - Comprehensive documentation
/// - Production-ready architecture
void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Configure system UI
  AppTheme.configureSystemUI();

  // Initialize database
  try {
    debugPrint('🔄 Initializing database...');
    await DatabaseHelper.instance.database;
    debugPrint('✅ Database initialized successfully');
  } catch (e) {
    debugPrint('❌ Error initializing database: $e');
  }

  // Check if first launch and initialize app
  try {
    final isFirstLaunch = await AppInitService.isFirstLaunch();
    if (isFirstLaunch) {
      debugPrint('🎉 First launch detected - initializing app...');
      await AppInitService.initializeApp();
      await AppInitService.markFirstLaunchComplete();
      debugPrint('✅ App initialization complete');
    } else {
      final launchCount = await AppInitService.getLaunchCount();
      debugPrint('👋 Welcome back! Launch #$launchCount');
    }
  } catch (e) {
    debugPrint('❌ Error during app initialization: $e');
  }

  // Run the app
  runApp(const BetterMuslimApp());
}

/// Root widget of the application
class BetterMuslimApp extends StatelessWidget {
  const BetterMuslimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App configuration
      title: 'BetterMuslim',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,

      // Home page - Start with splash screen
      home: const SplashScreen(),

      // TODO: Add GoRouter navigation
      // routerConfig: AppRouter.router,

      // TODO: Add BLoC providers
      // builder: (context, child) {
      //   return MultiBlocProvider(
      //     providers: [
      //       BlocProvider(create: (_) => getIt<PrayerBloc>()),
      //       // Add other BLoCs here
      //     ],
      //     child: child!,
      //   );
      // },
    );
  }
}
