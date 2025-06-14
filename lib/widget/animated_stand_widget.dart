import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedStand extends StatefulWidget {
  final bool isPlaying;

  const AnimatedStand({Key? key, required this.isPlaying}) : super(key: key);

  @override
  _AnimatedStandState createState() => _AnimatedStandState();
}

class _AnimatedStandState extends State<AnimatedStand>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedStand oldWidget) {
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: -30 / 360, end: -12 / 360).animate(_animationController),
      child: SvgPicture.asset(
        "assets/images/stand.svg",
      ),
    );
  }
}