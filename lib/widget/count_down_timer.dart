import 'package:flutter/material.dart';
//import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

import '../notifier/timer_notifier.dart';
import '../utils/app_layout.dart';
import '../utils/duration_extension.dart';

class CountDownTimer extends StatelessWidget {
  final Function onTap;

  const CountDownTimer({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TimerNotifier>(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        viewModel.timer?.isActive ?? false
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: AppLayout.getWidth(100),
                    height: AppLayout.getHeight(40),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(13)),
                      color: Colors.white12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          viewModel.timerDuration.format(),
                          style: const TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
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
                        overlayColor: Colors.transparent,
                        activeTrackColor: Colors.white.withValues(alpha: .75),
                        inactiveTrackColor: Colors.white.withValues(alpha: .35),
                        thumbShape: SliderComponentShape.noThumb,
                      ),
                      child: Slider(
                        value: viewModel.timerDuration.inSeconds.toDouble(),
                        max: viewModel.maxTime.toDouble(),
                        onChanged: (newValue) {},
                      ),
                    ),
                  InkWell(
                      onTap: () {
                        viewModel.stopTimer();
                      },
                      child: const Icon(
                        Remix.close_line, // Replace with the specific Remix icon
                        color: Colors.white,
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
                    color: Colors.white12,
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: AppLayout.getWidth(13),
                      vertical: AppLayout.getWidth(10)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Remix.timer_line, // Replace with the specific Remix icon
                        color: Colors.white,
                        //size: 290,
                      ),
                      Gap(AppLayout.getWidth(10)),
                      const Text(
                        'Set Timer',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
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
