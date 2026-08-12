import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'artwork_state.freezed.dart';

@freezed
class ArtworkState with _$ArtworkState {
  const factory ArtworkState({
    @Default('') String imageUrl,

    /// Null until the stream supplies artwork. The background falls back to
    /// the bundled asset, which used to be built eagerly in the notifier and
    /// so needed screen metrics before the first frame.
    Image? image,
  }) = _ArtworkState;

  const ArtworkState._();

  bool get hasImageUrl => imageUrl.isNotEmpty;
}
