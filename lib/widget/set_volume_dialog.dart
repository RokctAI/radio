import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/color_utils.dart';
import '../utils/app_layout.dart';

class SetVolumeDialog extends StatelessWidget {
  final double currentVolume;
  final Function onChangedValue;

  const SetVolumeDialog(
      {super.key, required this.currentVolume, required this.onChangedValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorUtils.getRadioFragTopBottomColor(context),
        borderRadius: BorderRadius.circular(
          AppLayout.getHeight(2),
        ),
      ),
      padding: EdgeInsets.all(AppLayout.getHeight(10)),
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/images/ic_volume.svg',
            width: AppLayout.getHeight(20),
            height: AppLayout.getHeight(20),
          ),
          Expanded(
            child: VerticalSeekBarWrapper(
              child: VerticalSeekBar(
                thumbColor: ColorUtils.getLineColor(context),
                progressColor: ColorUtils.getLineColor(context),
                backgroundColor: Colors.white,
                currentVolume: currentVolume,
                onChangedValue: (value) {
                  onChangedValue(value);
                },
                maxValue: 1.0,
              ),
            ),
          ),
          SvgPicture.asset(
            'assets/images/ic_mute.svg',
            width: AppLayout.getHeight(20),
            height: AppLayout.getHeight(20),
          ),
        ],
      ),
    );
  }
}

class VerticalSeekBarWrapper extends StatelessWidget {
  final Widget child;

  const VerticalSeekBarWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: child,
    );
  }
}

class VerticalSeekBar extends StatefulWidget {
  final Color thumbColor;
  final Color progressColor;
  final Color backgroundColor;
  final double currentVolume;
  final double maxValue;
  final Function onChangedValue;

  const VerticalSeekBar({
    super.key,
    required this.thumbColor,
    required this.progressColor,
    required this.backgroundColor,
    required this.currentVolume,
    required this.onChangedValue,
    required this.maxValue,
  });

  @override
  State<VerticalSeekBar> createState() => _VerticalSeekBarState();
}

class _VerticalSeekBarState extends State<VerticalSeekBar> {
  double _value = 0.0;

  @override
  void initState() {
    super.initState();
    _value = widget.currentVolume;
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 2.0,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 5,
        ),
        thumbColor: widget.thumbColor,
        overlayColor: Colors.transparent,
        activeTrackColor: widget.progressColor,
        inactiveTrackColor: widget.backgroundColor,
      ),
      child: Slider(
        value: _value,
        max: widget.maxValue,
        onChanged: (newValue) {
          widget.onChangedValue(newValue);
          setState(() {
            _value = newValue;
          });
        },
      ),
    );
  }
}
