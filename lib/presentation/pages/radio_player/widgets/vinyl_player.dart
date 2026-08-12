import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import 'package:single_radio/app_constants.dart';
import 'package:single_radio/presentation/pages/radio_player/widgets/animated_stand.dart';
import 'package:single_radio/utils/app_layout.dart';

class VinylPlayer extends StatefulWidget {
  final bool isPlaying;
  final Image artWork;

  const VinylPlayer(
      {super.key, required this.artWork, required this.isPlaying,});

  @override
  State<VinylPlayer> createState() => _VinylPlayerState();
}

class _VinylPlayerState extends State<VinylPlayer> with SingleTickerProviderStateMixin {
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
              borderRadius: BorderRadius.all(Radius.circular(50)),
              color: Colors.white30,
            ),
            child: Stack(
              children: [
                // Platter behind the record. 0.17 is the two stacked 0.09
                // layers this replaces, composited.
                Positioned(
                  left: -16,
                  bottom: -16,
                  child: Icon(
                    Remix.circle_fill,
                    color: Colors.white.withValues(alpha: 0.17),
                    size: 290,
                  ),
                ),
                RotationTransition(
                  turns: _animationController,
                  child: Container(
                    height: AppLayout.getHeight(260),
                    width: AppLayout.getHeight(260),
                    padding: const EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppLayout.getHeight(260)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppLayout.getHeight(200)),
                      child: widget.artWork,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        Positioned(
          right: -60,
          bottom: 32,
          child: AnimatedStand(
            isPlaying: widget.isPlaying,
          ),
        ),
        // Deck knobs.
        Positioned(
          left: 50,
          top: 50,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white30,
                width: 4.0,
              ),
            ),
            child: const Icon(
              Remix.square_fill,
              color: Colors.black45,
              size: 15,
            ),
          ),
        ),
        Positioned(
          left: 52,
          bottom: 42,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white30,
                width: 3.0,
              ),
            ),
            child: Icon(
              widget.isPlaying ? Remix.edit_circle_fill : Remix.shut_down_fill,
              color: Colors.black54,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
