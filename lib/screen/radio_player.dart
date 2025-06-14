import 'package:back_button_behavior/back_button_behavior.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:music_visualizer/music_visualizer.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:single_radio/widget/count_down_timer.dart';
import 'package:text_scroll/text_scroll.dart';

import '../ads/ads_callback.dart';
import '../dialog/exit_dialog.dart';
import '../notifier/image_url_notifier.dart';
import '../notifier/radio_notifier.dart';
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
                return const ExitDialog(
                  isNotPlaying: true,
                );
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
                    onTap: onOpenSlider,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: isOpen
                          ? const Row(
                        children: [
                          Icon(Remix.arrow_left_line, color: Colors.white, size: 30),
                          SizedBox(width: 10),
                          Text("Back", style: TextStyle(color: Colors.white)),
                        ],
                      )
                          : const Row(
                        children: [
                          Icon(Remix.menu_fill, color: Colors.white, size: 30),
                          SizedBox(width: 10),
                          Text("Menu", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: AppLayout.getHeight(80),
                  bottom: AppLayout.getHeight(180),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: AppLayout.getHeight(30)),
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
                                    future: radioModel.radioPlayer.getArtworkImage(),
                                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                                      Image artwork;
                                      if (snapshot.hasData) {
                                        artwork = snapshot.data;
                                        radioModel.imageUrlNotifier.setImage(snapshot.data);
                                      } else {
                                        artwork = radioModel.imageUrl.isNotEmpty
                                            ? Image.network(radioModel.imageUrl, fit: BoxFit.cover)
                                            : Image.asset("assets/images/radio_img.png", fit: BoxFit.cover);
                                      }
                                      return Stack(
                                        children: [
                                          VinylPlayer(
                                            artWork: artwork,
                                            isPlaying: radioModel.isPlaying,
                                          ),
                                          if (radioModel.imageUrl.isNotEmpty)
                                            Positioned(
                                              left: 0,
                                              top: 0,
                                              right: 0,
                                              bottom: 0,
                                              child: FutureBuilder(
                                                future: Future.delayed(const Duration(seconds: 0)),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.done) {
                                                    return SizedBox(
                                                      width: 5,
                                                      height: 5,
                                                      child: Image.asset('assets/images/vinylcenter.png'),
                                                    );
                                                  } else {
                                                    return const SizedBox.shrink();
                                                  }
                                                },
                                              ),
                                            ),
                                        ],
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
                                intervalSpaces: 7,
                                velocity: const Velocity(pixelsPerSecond: Offset(30, 0)),
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
                                intervalSpaces: 10,
                                velocity: const Velocity(pixelsPerSecond: Offset(40, 0)),
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
                      CountDownTimer(
                        onTap: () {
                          radioModel.loadCount().then((value) {
                            if (radioModel.countAds == 0) {
                              radioModel.admobHelper.showInterad(context);
                              adsCheck.openAdsOnMessageEvent().then((value) {
                                if (value.contains(Constant.DISMISS)) {
                                  radioModel.savedAds().then((value) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const TimerView(),
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
                                      builder: (context) => const TimerView()),
                                );
                              });
                            }
                          });
                        },
                      ),
                      Gap(AppLayout.getHeight(20)),
                      if (radioModel.isGetVol)
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            color: Colors.white10,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: AppLayout.getWidth(18),
                              vertical: AppLayout.getWidth(10)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () => _toggleVolume(radioModel),
                                child: Icon(
                                  _getVolumeIcon(radioModel.currentVolume),
                                  color: Colors.white,
                                  size: 35.0,
                                ),
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
                                icon: Icon(
                                  radioModel.isPlaying ? Remix.pause_circle_fill : Remix.play_circle_fill,
                                  color: radioModel.isPlaying ? Colors.grey : Colors.white,
                                  size: 48.0,
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

  Future<void> _handlePlayingExit(BuildContext context, RadioNotifier radioModel) async {
    final navigator = Navigator.of(context);
    bool? exitConfirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(.5),
      builder: (BuildContext dialogContext) {
        return const ExitDialog();
      },
    );

    if (exitConfirmed == true) {
      navigator.pop();
    } else {
      radioModel.backButtonPressed = true;
      await BackButtonMethods.minimize();
    }
  }

  Future<void> _handleNotPlayingExit(BuildContext context) async {
    final navigator = Navigator.of(context);
    bool? exitConfirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(.5),
      builder: (BuildContext dialogContext) {
        return const ExitDialog(isNotPlaying: true);
      },
    );

    if (exitConfirmed == true) {
      navigator.pop();
    }
  }

  void _handleTimerTap(BuildContext context, RadioNotifier radioModel, AdsCallBack adsCheck) {
    radioModel.loadCount().then((value) {
      if (radioModel.countAds == 0) {
        radioModel.admobHelper.showInterad(context);
        adsCheck.openAdsOnMessageEvent().then((value) {
          if (value.contains(Constant.DISMISS)) {
            radioModel.savedAds().then((_) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TimerView()),
              );
            });
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TimerView()),
            );
          }
        });
      } else {
        radioModel.savedAds().then((_) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TimerView()),
          );
        });
      }
    });
  }

  void _toggleVolume(RadioNotifier radioModel) {
    if (radioModel.currentVolume == 0) {
      radioModel.setVolume(100);
    } else {
      radioModel.setVolume(0);
    }
  }

  IconData _getVolumeIcon(double volume) {
    if (volume == 0) {
      return Remix.volume_mute_fill;
    } else if (volume <= 40) {
      return Remix.volume_down_fill;
    } else {
      return Remix.volume_up_fill;
    }
  }
}