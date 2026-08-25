// Copyright (c) 2026 RokctAI
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


﻿
import 'package:flutter/material.dart';
import 'package:single_radio/presentation/theme/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import 'package:single_radio/presentation/styles/color_utils.dart';
import 'package:single_radio/utils/app_layout.dart';

class NoInternetDialog extends StatelessWidget {
  final Function onRetry;
  const NoInternetDialog({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppStyle.transparent,
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
