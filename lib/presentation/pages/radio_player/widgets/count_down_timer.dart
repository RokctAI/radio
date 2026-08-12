import 'package:flutter/material.dart';
import 'package:single_radio/presentation/theme/theme.dart';
//import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';

import 'package:single_radio/application/timer/timer_provider.dart';
import 'package:single_radio/utils/app_layout.dart';
import 'package:single_radio/utils/duration_extension.dart';

class CountDownTimer extends ConsumerWidget {
  final Function onTap;

  const CountDownTimer({super.key, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(timerProvider);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        viewModel.isRunning
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: AppLayout.getWidth(100),
                    height: AppLayout.getHeight(40),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(13)),
                      color: AppStyle.surfaceOverlayAlt,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          viewModel.remaining.format(),
                          style: const TextStyle(
                            fontSize: 24.0,
                            color: AppStyle.white,
                            fontFamily: 'ClashGrotesk',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (viewModel.maxTime > 0)
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 4.0,
                        overlayColor: AppStyle.transparent,
                        activeTrackColor: AppStyle.whiteAlpha(.75),
                        inactiveTrackColor: AppStyle.whiteAlpha(.35),
                        thumbShape: SliderComponentShape.noThumb,
                      ),
                      child: Slider(
                        value: viewModel.remaining.inSeconds.toDouble(),
                        max: viewModel.maxTime.toDouble(),
                        onChanged: (newValue) {},
                      ),
                    ),
                  InkWell(
                      onTap: () {
                        ref.read(timerProvider.notifier).stopTimer();
                      },
                      child: const Icon(
                        Remix.close_line, // Replace with the specific Remix icon
                        color: AppStyle.white,
                       // size: 290,
                      )
                  )],
              )
            : GestureDetector(
                onTap: () {
                  onTap();
                },
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(29)),
                    color: AppStyle.surfaceOverlayAlt,
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: AppLayout.getWidth(13),
                      vertical: AppLayout.getWidth(10)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Remix.timer_line, // Replace with the specific Remix icon
                        color: AppStyle.white,
                        //size: 290,
                      ),
                      Gap(AppLayout.getWidth(10)),
                      const Text(
                        'Set Timer',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: AppStyle.white,
                          fontFamily: 'ClashGrotesk',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }
}
