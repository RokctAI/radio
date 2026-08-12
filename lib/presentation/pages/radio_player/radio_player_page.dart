import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:single_radio/presentation/theme/theme.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:music_visualizer/music_visualizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';
import 'package:single_radio/presentation/pages/radio_player/widgets/count_down_timer.dart';
import 'package:text_scroll/text_scroll.dart';

import 'package:single_radio/application/ads/ads_provider.dart';
import 'package:single_radio/application/artwork/artwork_provider.dart';
import 'package:single_radio/presentation/pages/radio_player/widgets/exit_dialog.dart';
import 'package:single_radio/application/playback/playback_provider.dart';
import 'package:single_radio/app_constants.dart';
import 'package:single_radio/infrastructure/services/app_background.dart';
import 'package:single_radio/utils/app_layout.dart';
import 'package:single_radio/presentation/component/blurred_background.dart';
import 'package:single_radio/presentation/pages/radio_player/widgets/seek_bar.dart';
import 'package:single_radio/presentation/pages/radio_player/widgets/vinyl_player.dart';
import 'package:single_radio/presentation/routes/app_router.dart';

/// Visualiser bar styling. Presentation data, so it lives with the page
/// rather than on the notifier -- application must not import presentation.
final List<Color> _barColors = [
  AppStyle.whiteAlpha(0.5),
  AppStyle.whiteAlpha(0.5),
  AppStyle.whiteAlpha(0.5),
  AppStyle.whiteAlpha(0.5),
];
const List<int> _barDurations = [900, 700, 600, 800, 500];

class RadioPlayerPage extends ConsumerWidget {
  final Function() onOpenSlider;
  final bool isOpen;

  const RadioPlayerPage(
      {super.key, required this.onOpenSlider, required this.isOpen});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final radioModel = ref.watch(playbackProvider);
    final playback = ref.read(playbackProvider.notifier);
    return PopScope(
      // WillPopScope is deprecated. canPop stays false so the back gesture is
      // always handled here, which means the confirmed-exit path now has to
      // leave explicitly -- onWillPop used to do that by returning true at the
      // root route. ExitDialog pops true for "exit" in both of its modes, so
      // the playing and not-playing branches collapse into one.
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (isOpen) {
          onOpenSlider();
          return;
        }

        final navigator = Navigator.of(context);
        final wasPlaying = radioModel.isPlaying;

        // showDialog returns null when the barrier is tapped, so this must
        // stay nullable -- reading it as a plain bool threw.
        final exitConfirmed = await showDialog<bool>(
          context: context,
          barrierColor: AppStyle.blackAlpha(.5),
          builder: (BuildContext dialogContext) {
            return ExitDialog(isNotPlaying: !wasPlaying);
          },
        );

        if (exitConfirmed == true) {
          if (navigator.canPop()) {
            navigator.pop();
          } else {
            await SystemNavigator.pop();
          }
        } else if (wasPlaying) {
          // "Background" -- keep playing, drop the app to the launcher.
          playback.markBackButtonPressed();
          await AppBackground.minimize();
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
                          Icon(Remix.arrow_left_line, color: AppStyle.white, size: 30),
                          SizedBox(width: 10),
                          Text("Back", style: TextStyle(color: AppStyle.white)),
                        ],
                      )
                          : const Row(
                        children: [
                          Icon(Remix.menu_fill, color: AppStyle.white, size: 30),
                          SizedBox(width: 10),
                          Text("Menu", style: TextStyle(color: AppStyle.white)),
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
                                    future: playback.radioPlayer.getArtworkImage(),
                                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                                      Image artwork;
                                      if (snapshot.hasData) {
                                        artwork = snapshot.data;
                                        ref.read(artworkProvider.notifier).setImage(snapshot.data);
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
                                colors: _barColors,
                                duration: _barDurations,
                              ),
                            ),
                          ),
                        SizedBox(
                          width: AppLayout.getScreenWidth() * .85,
                          child: Column(
                            children: [
                              TextScroll(
                                radioModel.track,
                                intervalSpaces: 7,
                                velocity: const Velocity(pixelsPerSecond: Offset(30, 0)),
                                delayBefore: const Duration(seconds: 1),
                                pauseBetween: const Duration(seconds: 2),
                                style: const TextStyle(
                                  fontSize: 34.0,
                                  color: AppStyle.white,
                                  fontFamily: 'ClashGrotesk',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextScroll(
                                radioModel.artist,
                                intervalSpaces: 10,
                                velocity: const Velocity(pixelsPerSecond: Offset(40, 0)),
                                delayBefore: const Duration(seconds: 1),
                                pauseBetween: const Duration(seconds: 2),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: AppStyle.white,
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
                        onTap: () => _openTimer(context, ref),
                      ),
                      Gap(AppLayout.getHeight(20)),
                      if (radioModel.hasVolume)
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            color: AppStyle.surfaceOverlay,
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
                                onTap: () => _toggleVolume(ref),
                                child: Icon(
                                  _getVolumeIcon(radioModel.volume),
                                  color: AppStyle.white,
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
                                    thumbColor: AppStyle.white,
                                    overlayColor: AppStyle.transparent,
                                    activeTrackColor: AppStyle.trackInactive,
                                    inactiveTrackColor: AppStyle.trackInactive,
                                  ),
                                  child: Slider(
                                    value: radioModel.volume,
                                    min: 0,
                                    max: 100,
                                    divisions: 100,
                                    onChanged: (newValue) {
                                      playback.setVolume(newValue);
                                    },
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: playback.togglePlayer,
                                icon: Icon(
                                  radioModel.isPlaying ? Remix.pause_circle_fill : Remix.play_circle_fill,
                                  color: radioModel.isPlaying ? AppStyle.textGrey : AppStyle.white,
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

  /// Capture the navigator before any await so the BuildContext is never used
  /// across an async gap -- this screen is stateless, so there is no mounted
  /// check available to fall back on.
  Future<void> _openTimer(BuildContext context, WidgetRef ref) async {
    final navigator = Navigator.of(context);
    final router = AutoRouter.of(context);
    final playback = ref.read(playbackProvider.notifier);

    await playback.loadCount();
    if (!navigator.mounted) return;

    if (playback.countAds == 0) {
      playback.admobHelper.showInterad(ref.read(adsProvider.notifier));
      if (ref.read(adsProvider).outcome.contains(Constant.dismiss)) {
        await playback.savedAds();
      }
    } else {
      await playback.savedAds();
    }

    router.push(const TimerRoute());
  }

  void _toggleVolume(WidgetRef ref) {
    final playback = ref.read(playbackProvider.notifier);
    final volume = ref.read(playbackProvider).volume;
    playback.setVolume(volume == 0 ? 100 : 0);
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
