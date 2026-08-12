// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashPage();
    },
  );
}

/// generated route for
/// [TimerPage]
class TimerRoute extends PageRouteInfo<void> {
  const TimerRoute({List<PageRouteInfo>? children})
    : super(TimerRoute.name, initialChildren: children);

  static const String name = 'TimerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TimerPage();
    },
  );
}

/// generated route for
/// [WebViewPage]
class WebViewRoute extends PageRouteInfo<WebViewRouteArgs> {
  WebViewRoute({Key? key, required String url, List<PageRouteInfo>? children})
    : super(
        WebViewRoute.name,
        args: WebViewRouteArgs(key: key, url: url),
        initialChildren: children,
      );

  static const String name = 'WebViewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WebViewRouteArgs>();
      return WebViewPage(key: args.key, url: args.url);
    },
  );
}

class WebViewRouteArgs {
  const WebViewRouteArgs({this.key, required this.url});

  final Key? key;

  final String url;

  @override
  String toString() {
    return 'WebViewRouteArgs{key: $key, url: $url}';
  }
}
