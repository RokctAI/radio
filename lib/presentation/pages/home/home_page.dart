import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:single_radio/presentation/theme/theme.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:single_radio/infrastructure/services/open_ad_manager.dart';
import 'package:single_radio/presentation/component/no_internet_dialog.dart';
import 'package:single_radio/app_constants.dart';
import 'package:single_radio/utils/app_layout.dart';
import 'package:single_radio/presentation/styles/app_style.dart';
import 'package:single_radio/presentation/component/blurred_background.dart';
import 'package:single_radio/presentation/pages/radio_player/radio_player_page.dart';

@RoutePage(name: 'HomeRoute')
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
  GlobalKey<SliderDrawerState>();
  bool isDrawerOpen = false;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;

  Timer? _timer;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _noInternetDialogOpen = false;

  /// connectivity_plus 6 reports a list of active transports. Offline is an
  /// empty list, or one that contains nothing but [ConnectivityResult.none].
  bool _isOffline(List<ConnectivityResult> results) =>
      results.isEmpty || results.every((r) => r == ConnectivityResult.none);

  Future<void> _checkConnectivityOpen() async {
    await _handleConnectivity(await Connectivity().checkConnectivity());
  }

  Future<void> _handleConnectivity(List<ConnectivityResult> results) async {
    if (!_isOffline(results) || !mounted || _noInternetDialogOpen) return;

    _noInternetDialogOpen = true;
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return NoInternetDialog(
          onRetry: () {
            _checkConnectivityOpen();
          },
        );
      },
    );
    _noInternetDialogOpen = false;
  }

  void _startTimer() {
    _timer = Timer(const Duration(seconds: 4), () {
      AppLayout.screenPortrait1();
    });
  }

  void _cancelTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _subscription =
        Connectivity().onConnectivityChanged.listen(_handleConnectivity);
    _checkConnectivityOpen();
    appOpenAdManager.loadAd();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _cancelTimer();
    _subscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLayout.screenPortrait1();
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.localPosition.dy > MediaQuery.of(context).size.height - 50) {
          _startTimer();
        }
      },
      child: Scaffold(
        body: BlurredBackgroundWithImage(
          child: SliderDrawer(
            appBar: null,
            key: _sliderDrawerKey,
            animationDuration: 300,
            sliderOpenSize: AppLayout.getScreenWidth() * .7,
            slider: _SliderView(
              onItemClick: (url) async{
                // Convert string to Uri
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
                _sliderDrawerKey.currentState!.closeSlider();
                setState(() {
                  isDrawerOpen = false;
                });
              },
            ),
            child: RadioPlayerPage(
                onOpenSlider: () {
                  if (_sliderDrawerKey.currentState!.isDrawerOpen) {
                    _sliderDrawerKey.currentState!.closeSlider();
                    setState(() {
                      isDrawerOpen = false;
                    });
                  } else {
                    _sliderDrawerKey.currentState!.openSlider();
                    setState(() {
                      isDrawerOpen = true;
                    });
                  }
                },
                isOpen: isDrawerOpen,
              ),
          ),
        ),
      ),
    );
  }
}

class _SliderView extends StatelessWidget {
  final Function(String)? onItemClick;

  const _SliderView({this.onItemClick});

  Future<String> _getVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: AppStyle.transparent,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/logo2.png',
                      width: 100,
                    ),
                  ),
                ),
                Gap(AppLayout.getWidth(2)),
                Text(
                  Constant.appName,
                  style: TextStyle(
                    fontSize: 28.0,
                    color: Styles.primaryColor,
                    fontFamily: 'ClashDisplay',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(AppLayout.getWidth(2)),
                Text(
                  Constant.appMotto,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Styles.primaryColor,
                    fontFamily: 'ClashDisplay',
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Gap(AppLayout.getHeight(20)),
          const Spacer(),
          Column(
            children: [
              for (var menu in menuItems)
                _SliderMenuItem(
                  title: menu.title,
                  onTap: onItemClick,
                  url: menu.url,
                ),
            ],
          ),
          const Spacer(),
          Gap(AppLayout.getHeight(20)),
          FutureBuilder<String>(
            future: _getVersion(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Text(
                  'Version: ${snapshot.data ?? ''}',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Styles.primaryColor.withValues(alpha: 0.7),
                    fontFamily: 'ClashGrotesk',
                    fontWeight: FontWeight.w400,
                  ),
                );
              } else {
                return const SizedBox.shrink(); // Or a loading indicator
              }
            },
          ),
          Gap(AppLayout.getHeight(45)),
        ],
      ),
    );
  }
}

class _SliderMenuItem extends StatelessWidget {
  final String title;
  final String url;
  final Function(String)? onTap;

  const _SliderMenuItem({required this.title, required this.onTap, required this.url});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.0,
            color: Styles.primaryColor,
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () => onTap?.call(url));
  }
}

class Menu {
  final String title;
  final String url;
  Menu(this.title, this.url);
}

List<Menu> menuItems = [
  Menu('X (Twitter)', Constant.twitterUrl),
  Menu('Facebook', Constant.facebookUrl),
  Menu('WhatsApp', Constant.whatsappUrl),
  Menu('Privacy Policy', Constant.privacyUrl),
  Menu('About Us', Constant.aboutUsUrl),
  Menu('Rate Us', Constant.rateUsUrl),
];
