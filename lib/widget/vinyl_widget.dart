
import 'package:flutter/material.dart';

import '../utils/Constant.dart';
import 'animated_stand_widget.dart';
import '../utils/app_layout.dart';

class VinylPlayer extends StatefulWidget {
  final bool isPlaying;
  final Image artWork;

  const VinylPlayer(
      {Key? key, required this.artWork, required this.isPlaying,})
      : super(key: key);

  @override
  _VinylPlayerState createState() => _VinylPlayerState();
}

class _VinylPlayerState extends State<VinylPlayer> with SingleTickerProviderStateMixin{
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..stop();
  }

  @override
  void didUpdateWidget(covariant VinylPlayer oldWidget) {
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying && Constant.isRotate) {
        _animationController.repeat();
      } else {
        _animationController.stop();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(260)),
              color: Colors.white30,
            ),
            child: RotationTransition(
              turns: _animationController,
              child: Container(
                height: AppLayout.getHeight(260),
                width: AppLayout.getHeight(260),
                padding: const EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppLayout.getHeight(260)),
                ),
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.circular(AppLayout.getHeight(200)),
                  child: widget.artWork,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: -72,
          bottom: 30,
          child: AnimatedStand(
            isPlaying: widget.isPlaying,
          ),
        ),
      ],
    );
  }
}
