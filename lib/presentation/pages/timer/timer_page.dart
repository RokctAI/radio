import 'package:flutter/material.dart';
import 'package:single_radio/presentation/theme/theme.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:single_radio/utils/duration_extension.dart';
import 'package:single_radio/infrastructure/services/interstitial_ad.dart';
import 'package:single_radio/application/timer/timer_provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:single_radio/utils/app_layout.dart';
import 'package:single_radio/presentation/styles/app_style.dart';
import 'package:single_radio/utils/language.dart';
import 'package:single_radio/presentation/component/blurred_background.dart';

class TimerView extends ConsumerStatefulWidget {
  const TimerView({super.key});

  static const routeName = '/timer';

  @override
  ConsumerState<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends ConsumerState<TimerView> {

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(timerProvider);
    final timer = ref.read(timerProvider.notifier);
    return Scaffold(
      body: BlurredBackgroundWithImage(
        child: Stack(
          children: [
            Positioned(
                top: MediaQuery.of(context).padding.top,
                left: 0,
                child: InkWell(
                    onTap: () {
                      Navigator.pop(context);

                    },
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                     // child: SvgPicture.asset('assets/images/back_arrow.svg'),
                      child: Row(  // Use a Row to display icon and text together
                        children: [
                          Icon(Remix.arrow_left_line, color: AppStyle.white, size: 30),
                          SizedBox(width: 10), // Add spacing between icon and text
                          Text("Back", style: TextStyle(color: AppStyle.white)),
                        ],
                      ),

                    ))),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Gap(AppLayout.getHeight(30)),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppLayout.getHeight(200)),
                        color: AppStyle.white,
                      ),
                      child: const _CircularSlider()),
                  Gap(AppLayout.getHeight(70)),
                  viewModel.isRunning
                      ? _Button(
                          title: Language.stopTimer,
                          color: Styles.primaryColor,
                          textColor: Styles.textColorDark,
                          onTap: timer.stopTimer,
                        )
                      : _Button(
                          title: Language.startTimer,
                          color: Styles.primaryColor,
                          textColor: Styles.textColorDark,
                          onTap: timer.startTimer,
                        ),
                  Gap(AppLayout.getHeight(30)),
                  const Text(
                    'The radio will be paused\nautomatically',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.0,
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
      bottomNavigationBar: AdmobHelper.showBanner(context),
    );
  }
}

class _CircularSlider extends ConsumerWidget {
  const _CircularSlider();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(timerProvider);
    final timer = ref.read(timerProvider.notifier);

    return SleekCircularSlider(
      appearance: CircularSliderAppearance(
        size: 260,
        startAngle: 270,
        angleRange: 360,
        customWidths: CustomSliderWidths(
          trackWidth: 30,
          progressBarWidth: 30,
          handlerSize: 20,
          shadowWidth: 0,
        ),
        customColors: CustomSliderColors(
          trackColor: const Color(0xFFF6F6F6),
          progressBarColors: Styles.gradientColors1,
          gradientStartAngle: 1,
          shadowColor: Styles.primaryColor,
          dotColor: const Color(0xFFDEDEDE),
          shadowMaxOpacity: 0.0,
        ),
      ),
      onChange: (double value) {
        timer.setTimer(Duration(seconds: value.toInt()));
      },
      initialValue: viewModel.remaining.inSeconds.toDouble(),
      min: 0,
      max: 7250,
      innerWidget: (value) {
        return _TimeLeft(
          hour: viewModel.remaining.formatHour(),
          min: viewModel.remaining.formatMin(),
        );
      },
    );
  }
}

class _TimeLeft extends StatelessWidget {
  const _TimeLeft({
    required this.hour,
    required this.min,
  });

  final String hour;
  final String min;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              hour,
              style: const TextStyle(
                fontSize: 40.0,
                color: AppStyle.black,
                fontFamily: 'ClashGrotesk',
                fontWeight: FontWeight.w500,
              ),
            ),
            Gap(AppLayout.getHeight(7)),
            const Text(
              'hr',
              style: TextStyle(
                fontSize: 15.0,
                color: AppStyle.black,
                fontFamily: 'ClashGrotesk',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              ' : ',
              style: TextStyle(
                fontSize: 40.0,
                color: AppStyle.black,
                fontFamily: 'ClashGrotesk',
                fontWeight: FontWeight.w500,
              ),
            ),
            Gap(AppLayout.getHeight(7)),
            const Text(
              ' ',
              style: TextStyle(
                fontSize: 15.0,
                color: AppStyle.black,
                fontFamily: 'ClashGrotesk',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              min,
              style: const TextStyle(
                fontSize: 40.0,
                color: AppStyle.black,
                fontFamily: 'ClashGrotesk',
                fontWeight: FontWeight.w500,
              ),
            ),
            Gap(AppLayout.getHeight(7)),
            const Text(
              'min',
              style: TextStyle(
                fontSize: 15.0,
                color: AppStyle.black,
                fontFamily: 'ClashGrotesk',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.title,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  final Color textColor;
  final Color color;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(textColor),
        backgroundColor: WidgetStateProperty.all<Color>(color),
        minimumSize: WidgetStateProperty.all<Size>(const Size(250, 45)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
        onTap();
      },
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20.0,
          fontFamily: 'ClashGrotesk',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
