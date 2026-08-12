
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../utils/ColorUtils.dart';
import '../utils/app_layout.dart';

class NoInternetDialog extends StatelessWidget {
  final Function onRetry;
  const NoInternetDialog({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: ColorUtils.getBackGround(context),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: AppLayout.getWidth(265),
              height: AppLayout.getHeight(230),
              child:SvgPicture.asset('assets/images/noInternet.svg')
            ),
            Gap(AppLayout.getHeight(20)),
            Divider(
              height: 1,
              thickness: 1,
              color: ColorUtils.getLineColor(context),
            ),
            Gap(AppLayout.getHeight(20)),
            Text(
              'Oops!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
                fontFamily: 'ClashGrotesk',
                color: ColorUtils.getPrimaryText(context),
              ),
            ),
            Gap(AppLayout.getHeight(12)),
            const Text(
              'No internet connection',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'ClashGrotesk',
                color: Color(0xFF6A6E7D),
              ),
            ),
            Gap(AppLayout.getHeight(15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    onRetry();
                    Navigator.of(context).pop(false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorUtils.getPrimaryText(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: 0.0,
                    minimumSize: const Size(117, 37),
                  ),
                  child: Text(
                    'Retry',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'ClashGrotesk',
                      color: ColorUtils.getBlackWhiteReverse(context),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
