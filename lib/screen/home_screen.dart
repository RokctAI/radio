import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ads/open_ad_manager.dart';
import '../dialog/no_internet_dialog.dart';
import '../notifier/radio_notifier.dart';
import '../utils/Constant.dart';
import '../utils/app_layout.dart';
import '../utils/app_style.dart';
import '../widget/blur_bg_widget.dart';
import 'radio_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{
  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();
  bool isDrawerOpen = false;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;

  Timer? _timer;
  bool _connectionStatus = true;
  late StreamSubscription<ConnectivityResult> _subscription;


  Future<void> _checkConnectivityOpen() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _connectionStatus = false;
      });

      // Show dialog for no internet
      if(mounted) {
        await showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return NoInternetDialog(onRetry: () {
              _checkConnectivityOpen();
            },);
          },
        );
      }
    }
  }

  Future<void> _checkConnectivity(ConnectivityResult connectivityResult) async {
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _connectionStatus = false;
      });

      if(!_connectionStatus) {
        await showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return NoInternetDialog(onRetry: (){
              _checkConnectivityOpen();
            },);
          },
        );
      }
    }
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
    // _subscription = Connectivity().onConnectivityChanged.listen(_checkConnectivity);
    _checkConnectivityOpen();
    appOpenAdManager.loadAd();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _cancelTimer();
    _subscription.cancel();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
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
                if (await canLaunch(url)) {
                await launch((url));
                }
                _sliderDrawerKey.currentState!.closeSlider();
                setState(() {
                  isDrawerOpen = false;
                });
              },
            ),
            child: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => RadioNotifier()),
              ],
              child: RadioPlayerScreen(
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
      ),
    );
  }
}

class _SliderView extends StatelessWidget {
  final Function(String)? onItemClick;

  const _SliderView({Key? key, this.onItemClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: Colors.transparent,
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 60,
                      width: 60,
                    ),
                  ),
                ),
                Gap(AppLayout.getWidth(25)),
                Text(
                  Constant.appName,
                  style: TextStyle(
                    fontSize: 28.0,
                    color: Styles.primaryColor,
                    fontFamily: 'ClashDisplay',
                    fontWeight: FontWeight.bold,
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
          Gap(AppLayout.getHeight(65)),
        ],
      ),
    );
  }
}

class _SliderMenuItem extends StatelessWidget {
  final String title;
  final String url;
  final Function(String)? onTap;

  const _SliderMenuItem({Key? key, required this.title, required this.onTap, required this.url})
      : super(key: key);

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
  Menu('Twitter', Constant.twitterUrl),
  Menu('Facebook', Constant.facebookUrl),
  Menu('WhatsApp', Constant.whatsappUrl),
  Menu('Privacy Policy', Constant.privacyUrl),
  Menu('About Us', Constant.aboutUsUrl),
  Menu('Rate Us', Constant.rateUsUrl),
];