import 'package:back_button_behavior/back_button_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:music_visualizer/music_visualizer.dart';
import 'package:provider/provider.dart';
import 'package:single_radio/widget/count_down_timer.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../utils/duration_extension.dart';
import '../ads/ads_callback.dart';
import '../dialog/exit_dialog.dart';
import '../notifier/image_url_notifier.dart';
import '../notifier/radio_notifier.dart';
import '../notifier/timer_notifier.dart';
import '../utils/ColorUtils.dart';
import '../utils/Constant.dart';
import '../utils/app_layout.dart';
import '../widget/blur_bg_widget.dart';
import '../widget/seek_bar.dart';
import '../widget/vinyl_widget.dart';
import 'timer_screen.dart';

class RadioPlayerScreen extends StatelessWidget {
  final Function() onOpenSlider;
  final bool isOpen;

  const RadioPlayerScreen(
      {super.key, required this.onOpenSlider, required this.isOpen});

  @override
  Widget build(BuildContext context) {
    final adsCheck = Provider.of<AdsCallBack>(context);
    final radioModel = Provider.of<RadioNotifier>(context);
    // final viewModel = Provider.of<TimerNotifier>(context);
    final imageUrlNotifier = Provider.of<ImageUrlNotifier>(context);
    radioModel.imageUrlNotifier = imageUrlNotifier;
    return WillPopScope(
      onWillPop: () async {
        if (isOpen) {
          onOpenSlider();
          return false;
        } else {
          if (radioModel.isPlaying) {
            bool exitConfirmed = await showDialog(
              context: context,
              barrierColor: Colors.black.withOpacity(.5),
              builder: (BuildContext dialogContext) {
                return const ExitDialog();
              },
            );
            if (exitConfirmed) {
              return true;
            } else {
              radioModel.backButtonPressed = true;
              await BackButtonMethods.minimize();
              return false;
            }
          } else {
            bool exitConfirmed = await showDialog(
              context: context,
              barrierColor: Colors.black.withOpacity(.5),
              builder: (BuildContext dialogContext) {
                return const ExitDialog(isNotPlaying:true,);
              },
            );
            return exitConfirmed ?? false;
          }
        }
      },
      child: GestureDetector(
        onHorizontalDragStart: (details) {
          onOpenSlider();
        },
        child: Scaffold(
          body: BlurredBackgroundWithImage(
            child: Stack(
              children: [
                Positioned(
                    top: MediaQuery.of(context).padding.top,
                    left: 0,
                    child: InkWell(
                        onTap: () {
                          onOpenSlider();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: isOpen
                              ? SvgPicture.asset('assets/images/back_arrow.svg')
                              : SvgPicture.asset('assets/images/menu.svg'),
                        ))),
                Positioned(
                  top: AppLayout.getHeight(80),
                  bottom: AppLayout.getHeight(180),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: AppLayout.getHeight(30)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (radioModel.isLoaded)
                          SizedBox(
                            width: AppLayout.getScreenWidth(),
                            child: Stack(
                              children: [
                                Center(
                                  child: FutureBuilder(
                                    future: radioModel.radioPlayer
                                        .getArtworkImage(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      Image artwork;
                                      if (snapshot.hasData) {
                                        artwork = snapshot.data;
                                        radioModel.imageUrlNotifier
                                            .setImage(snapshot.data);
                                      } else {
                                        radioModel.imageUrl.isNotEmpty
                                            ? artwork = Image.network(
                                                radioModel.imageUrl,
                                                fit: BoxFit.cover,
                                              )
                                            : artwork = Image.asset(
                                                "assets/images/radio_img.webp",
                                                fit: BoxFit.cover,
                                              );
                                      }
                                      return VinylPlayer(
                                        artWork: artwork,
                                        isPlaying: radioModel.isPlaying,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (radioModel.isLoaded)
                          SizedBox(
                            width: AppLayout.getWidth(250),
                            height: AppLayout.getHeight(90),
                            child: AnimatedOpacity(
                              opacity: radioModel.isPlaying ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: MusicVisualizer(
                                barCount: 30,
                                colors: radioModel.colors,
                                duration: radioModel.duration,
                              ),
                            ),
                          ),
                        SizedBox(
                          width: AppLayout.getScreenWidth() * .85,
                          child: Column(
                            children: [
                              TextScroll(
                                radioModel.metadata?[1] ?? '',
                                // numberOfReps: viewModel.timer != null && viewModel.timer!.isActive ? 0 : null,
                                intervalSpaces: 7,
                                velocity: const Velocity(
                                    pixelsPerSecond: Offset(30, 0)),
                                delayBefore: const Duration(seconds: 1),
                                pauseBetween: const Duration(seconds: 2),
                                style: const TextStyle(
                                  fontSize: 34.0,
                                  color: Colors.white,
                                  fontFamily: 'ClashGrotesk',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextScroll(
                                radioModel.metadata?[0] ?? '',
                                // numberOfReps: viewModel.timer != null && viewModel.timer!.isActive ? 0 : null,
                                intervalSpaces: 10,
                                velocity: const Velocity(
                                    pixelsPerSecond: Offset(40, 0)),
                                delayBefore: const Duration(seconds: 1),
                                pauseBetween: const Duration(seconds: 2),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontFamily: 'ClashGrotesk',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).padding.top,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      CountDownTimer(onTap: (){
                        radioModel.loadCount().then((value) {
                          if (radioModel.countAds == 0) {
                            radioModel.admobHelper
                                .showInterad(context);
                            adsCheck
                                .openAdsOnMessageEvent()
                                .then((value) {
                              if (value
                                  .contains(Constant.DISMISS)) {
                                radioModel.savedAds().then((value) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const TimerView(),
                                    ),
                                  );
                                });
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const TimerView()),
                                );
                              }
                            });
                          } else {
                            radioModel.savedAds().then((value) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const TimerView()),
                              );
                            });
                          }
                        });
                      },),
                      Gap(AppLayout.getHeight(20)),
                      if (radioModel.isGetVol)
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            color: Colors.white10,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: AppLayout.getWidth(18),
                              vertical: AppLayout.getWidth(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                radioModel.currentVolume == 0
                                    ? "assets/images/ic_volume_0.svg"
                                    : 0 < radioModel.currentVolume &&
                                            radioModel.currentVolume <= 40
                                        ? "assets/images/ic_volume_1.svg"
                                        : 40 < radioModel.currentVolume &&
                                                radioModel.currentVolume <= 75
                                            ? "assets/images/ic_volume_2.svg"
                                            : "assets/images/ic_volume.svg",
                              ),
                              Expanded(
                                child: SliderTheme(
                                  data: SliderThemeData(
                                    trackHeight: 5.0,
                                    thumbShape: CustomSliderThumbShape(
                                      thumbRadius: 18,
                                    ),
                                    thumbColor: Colors.white,
                                    overlayColor: Colors.transparent,
                                    activeTrackColor: Colors.white38,
                                    inactiveTrackColor: Colors.white38,
                                  ),
                                  child: Slider(
                                    value: radioModel.currentVolume,
                                    min: 0,
                                    max: 100,
                                    divisions: 100,
                                    onChanged: (newValue) {
                                      radioModel.setVolume(newValue);
                                    },
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: radioModel.togglePlayer,
                                icon: SvgPicture.asset(
                                  radioModel.isPlaying
                                      ? "assets/images/ic_radio_pause.svg"
                                      : "assets/images/ic_radio_play.svg",
                                ),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}