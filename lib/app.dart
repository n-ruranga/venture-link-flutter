import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venture_link/core/constants/strings.dart';
import 'package:venture_link/core/routes/app_router.dart';
import 'package:venture_link/core/theme/app_theme.dart';

class VentureLinkApp extends ConsumerWidget {
  const VentureLinkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
