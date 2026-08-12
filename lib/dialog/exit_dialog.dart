import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../utils/ColorUtils.dart';
import '../utils/app_layout.dart';

class ExitDialog extends StatelessWidget {
  final bool? isNotPlaying;
  const ExitDialog({super.key, this.isNotPlaying});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white.withValues(alpha: .08),
      surfaceTintColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: .15)
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 30.0,
              offset: const Offset(0.0, 20.0),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 37, sigmaY: 37),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppLayout.getHeight(15)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Gap(AppLayout.getHeight(8)),
                  SizedBox(
                    width: AppLayout.getWidth(265),
                    height: AppLayout.getHeight(230),
                    child: Image.asset(
                      'assets/images/exit_img.webp',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Gap(AppLayout.getHeight(20)),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.white.withValues(alpha: .4),
                  ),
                  Gap(AppLayout.getHeight(20)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(15)),
                    child: Text(
                      isNotPlaying??false?'Do you want to Exit!':'Would you like to play music in the Background, or Exit?',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'ClashGrotesk',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Gap(AppLayout.getHeight(15)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop( isNotPlaying??false?false:true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: .15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 0.0,
                          minimumSize: const Size(110, 34),
                        ),
                        child: Text(
                          isNotPlaying??false?"Cancel":"Exit",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'ClashGrotesk',
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Gap(AppLayout.getWidth(16)),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop( isNotPlaying??false?true:false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 0.0,
                          minimumSize: const Size(110, 34),
                        ),
                        child: Text(
                          isNotPlaying??false?'Exit':'Background',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'ClashGrotesk',
                            color: ColorUtils.getPrimaryText(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
