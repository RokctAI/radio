import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:single_radio/presentation/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:single_radio/application/artwork/artwork_provider.dart';
import 'package:single_radio/utils/app_layout.dart';

class BlurredBackgroundWithImage extends ConsumerWidget {
  final Widget child;
  final double? height;

  const BlurredBackgroundWithImage({super.key, required this.child, this.height});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artwork = ref.watch(artworkProvider);
    return Stack(
      children: [
        artwork.imageUrl.isNotEmpty
            ? Positioned.fill(
                child: Image.network(
                  artwork.imageUrl,
                  height: AppLayout.getScreenHeight(),
                  width: AppLayout.getScreenWidth(),
                  fit: BoxFit.fill,
                ).blurred(
                  blur: 40,
                  blurColor: AppStyle.black,
                  colorOpacity: .5,
                ),
              )
            : Positioned.fill(
                    child: (artwork.image ??
                            Image.asset(
                              'assets/images/back_blur_img.jpg',
                              height: AppLayout.getScreenHeight(),
                              width: AppLayout.getScreenWidth(),
                              fit: BoxFit.fill,
                            ))
                        .blurred(
                      blur: 40,
                      blurColor: AppStyle.black,
                      colorOpacity: .5,
                    ),
                  ),
        Positioned.fill(child: child),
      ],
    );
  }
}
