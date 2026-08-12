import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:remixicon/remixicon.dart';

import '../utils/Constant.dart';
import 'animated_stand_widget.dart';
import '../utils/app_layout.dart';

class VinylPlayer extends StatefulWidget {
  final bool isPlaying;
  final Image artWork;

  const VinylPlayer(
      {super.key, required this.artWork, required this.isPlaying,});

  @override
  _VinylPlayerState createState() => _VinylPlayerState();
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
      /*Positioned(
      right: 45, // Adjust the position as needed
      //top: AppLayout.getScreenWidth() / 3,  // Adjust the position as needed
     top: 43,  // Adjust the position as needed

       // child: ClipRRect(
          //borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'assets/images/logo2.png',
            height: 35,
            width: 35,
          ),
       // ),
      ),*/
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              color: Colors.white30,
            ),
            child: Stack(
              children: [
                Positioned(
                  left: -16, // Adjust the position as needed
                  //top: AppLayout.getScreenWidth() / 3,  // Adjust the position as needed
                  bottom: -16,  // Adjust the position as needed
                  child: Icon(
                    Remix.circle_fill, // Replace with the specific Remix icon
                    color: Colors.white.withOpacity(0.09),
                    size: 290,
                  ),
                ),
                Positioned(
                  left: -16, // Adjust the position as needed
                  //top: AppLayout.getScreenWidth() / 3,  // Adjust the position as needed
                  bottom: -16,  // Adjust the position as needed
                  child: Icon(
                    Remix.circle_fill, // Replace with the specific Remix icon
                    color: Colors.white.withOpacity(0.09),
                    size: 290,
                  ),
                ),
                // Add the SVG behind the color
             /*   Positioned(
                  left: 13,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: SvgPicture.asset(
                    'assets/images/device.svg',
                    //fit: BoxFit.cover,
                    fit: BoxFit.fitWidth,
                  ),
                ), */
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
        Positioned(
          left: 50, // Adjust the position as needed
          top: 50,  // Adjust the position as needed
          child: Container(
            decoration:  BoxDecoration(
             // color: Colors.white30,
              //shape: BoxShape.circle,
             border: Border.all(
               color: Colors.white30,
               width: 4.0, ),
            ),
            child: const Icon(
              Remix.square_fill, // Replace with the specific Remix icon
              color: Colors.black45,
              size: 15,
            ),
          ),
        ),
        Positioned(
          left: 52, // Adjust the position as needed
          bottom: 42,  // Adjust the position as needed
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white30,
                width: 3.0,
              ),
              /*boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 5), // Adjust the shadow position
                ),
              ],*/
            ),
            child: Icon(widget.isPlaying ?
            Remix.edit_circle_fill : Remix.shut_down_fill, // Replace with the specific Remix icon
              color: Colors.black54,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
