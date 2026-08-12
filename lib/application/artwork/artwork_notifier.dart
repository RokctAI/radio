import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:single_radio/application/artwork/artwork_state.dart';

class ArtworkNotifier extends StateNotifier<ArtworkState> {
  ArtworkNotifier() : super(const ArtworkState());

  void setImageUrl(String url) => state = state.copyWith(imageUrl: url);

  /// Replaces the artwork only when the decoded bytes actually differ, so a
  /// repeated metadata event does not rebuild the background.
  void setImage(Image image) {
    final current = state.image;
    if (current != null &&
        current.image is MemoryImage &&
        image.image is MemoryImage) {
      final existingBytes = (current.image as MemoryImage).bytes;
      final newBytes = (image.image as MemoryImage).bytes;
      if (existingBytes == newBytes) return;
    }
    state = state.copyWith(image: image);
  }
}
