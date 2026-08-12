import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
// @generated-imports-start
// @generated-imports-end

import 'package:single_radio/presentation/pages/home/home_page.dart';
import 'package:single_radio/presentation/pages/splash/splash_page.dart';
import 'package:single_radio/presentation/pages/timer/timer_page.dart';
import 'package:single_radio/presentation/pages/webview/webview_page.dart';

part 'app_router.gr.dart';

/// Mirrors base_sdk's installed template: composed SDKs get their manifest
/// `routes` injected between the generated markers. The entries below the
/// markers are host-owned, which is the same arrangement paas_driver used for
/// its own pages before they moved into SDKs.
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
// @generated-routes-start
// @generated-routes-end
        CupertinoRoute(path: '/', page: SplashRoute.page, initial: true),
        CupertinoRoute(path: '/home', page: HomeRoute.page),
        CupertinoRoute(path: '/timer', page: TimerRoute.page),
        CupertinoRoute(path: '/webview', page: WebViewRoute.page),
      ];
}
