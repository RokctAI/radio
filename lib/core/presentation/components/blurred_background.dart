import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:single_radio/radio/application/artwork/artwork_notifier.dart';
import 'package:single_radio/core/utils/app_layout.dart';

class BlurredBackgroundWithImage extends StatelessWidget {
  final Widget child;
  final double? height;

  const BlurredBackgroundWithImage({super.key, required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    final artworkNotifier = Provider.of<ArtworkNotifier>(context);
    return Stack(
      children: [
        artworkNotifier.imageUrl.isNotEmpty
            ? Positioned.fill(
                child: Image.network(
                  artworkNotifier.imageUrl,
                  height: AppLayout.getScreenHeight(),
                  width: AppLayout.getScreenWidth(),
                  fit: BoxFit.fill,
                ).blurred(
                  blur: 40,
                  blurColor: Colors.black,
                  colorOpacity: .5,
                ),
              )
            : Positioned.fill(
                    child: artworkNotifier.image.blurred(
                      blur: 40,
                      blurColor: Colors.black,
                      colorOpacity: .5,
                    ),
                  ),
        Positioned.fill(child: child),
      ],
    );
  }
}
