# Slice: Musina FM app -> Rokct SDKs

Pre-SDK classification pass. No code moved yet. This decides **SDK count and
scope** only; the file-by-file target paths come later, once the skeleton
exists, because the destination directories are dictated by
`shared-workflows/scripts/sdk_validator.py` rather than by the current layout.

Current state: 31 Dart files, 3,354 lines, `flutter analyze` clean.

## How to audit this

- Unreferenced files were found by scanning every `.dart` for each filename
  across the whole tree, excluding self and `main.dart`. Two came back dead.
- Destination rules used: ADR-005 (feature SDKs import only `base_sdk`),
  `base_sdk` already owns `splash_page` and shared assets (stated in
  `launch/dart/manifest.json`'s `_comment_app_assets`), and the validator's
  required shape (`di/`, `application/<feature>/`,
  `infrastructure/repositories/`, `infrastructure/models/{data,response}/`,
  `domain/interface/`).
- Anything marked **split** does not map 1:1 and is listed again below with the
  split described.

## Totals by destination

| Destination | Files | Lines |
|---|---|---|
| `base` | 12 | 785 |
| `radio` (new) | 12 | 1,802 |
| `promotions` | 3 | 278 |
| `comms` | 0 (config only) | - |
| `telemetry` | 0 (does not exist yet) | - |
| dies | 3 | 293 |
| split across several | 1 | 71 |

## -> `base`

Shared kernel. None of this is radio-specific.

| File | Lines | Note |
|---|---|---|
| `utils/app_style.dart` | 41 | becomes `AppStyle` tokens |
| `utils/color_utils.dart` | 114 | 20 provider-lookup wrappers; collapses into `AppStyle` |
| `utils/app_layout.dart` | 73 | screen metrics + system chrome |
| `notifier/theme_provider.dart` | 40 | `ThemeMode` + light/dark `ThemeData`; `brand_hook` territory |
| `utils/app_pref.dart` | 33 | SharedPreferences wrapper |
| `utils/language.dart` | 26 | string constants -> `tr_keys` |
| `utils/duration_extension.dart` | 16 | generic `Duration` formatting |
| `utils/remote_config.dart` | 116 | Firebase Remote Config binding |
| `utils/firebase_init.dart` | 20 | Firebase boot -> `boot_hooks` |
| `utils/webview.dart` | 32 | generic in-app webview |
| `dialog/no_internet_dialog.dart` | 88 | connectivity is not radio-specific |
| `screen/splash_screen.dart` | 160 | `base` already owns `splash_page`; only the min-version gate is app logic |

## -> `radio` (new SDK)

The vertical. One SDK, not three: metadata is meaningless without playback,
and the sleep timer is meaningless without both.

| File | Lines | Lands as |
|---|---|---|
| `notifier/radio_notifier.dart` | 220 | **split** - see below |
| `notifier/image_url_notifier.dart` | 35 | `application/artwork/` |
| `notifier/timer_notifier.dart` | 34 | `application/sleep_timer/` |
| `screen/radio_player.dart` | 330 | `templates/pages/` - the `home_sdk` page |
| `screen/home_screen.dart` | 261 | `templates/pages/` - drawer shell hosting the player |
| `screen/timer_screen.dart` | 256 | `templates/pages/` |
| `widget/vinyl_widget.dart` | 130 | `templates/widgets/` |
| `widget/animated_stand_widget.dart` | 46 | `templates/widgets/` |
| `widget/count_down_timer.dart` | 110 | `templates/widgets/` |
| `widget/seek_bar.dart` | 146 | `templates/widgets/` - candidate for `base`, used only here today |
| `widget/blur_bg_widget.dart` | 39 | `templates/widgets/` - generic blur, but driven by artwork state |
| `dialog/exit_dialog.dart` | 126 | `templates/widgets/` - copy is playback-specific ("play in the Background") |

Models to be **created**, not moved. None exist today; `radio_notifier` parses
raw maps inline (`data['results']`, `song['album']['cover_big']`,
`matchedTrack['artworkUrl100']`, metadata as a bare `List<String>`):

- `infrastructure/models/data/` - track metadata, station/stream
- `infrastructure/models/response/` - iTunes search response, Deezer search response
- `domain/interface/` - artwork provider contract, so iTunes and Deezer become
  two implementations behind one interface instead of two methods falling
  through to each other by name

## -> `promotions`

| File | Lines | Note |
|---|---|---|
| `ads/interstitial_ad.dart` | 192 | AdMob + Unity + Facebook mediation |
| `ads/open_ad_manager.dart` | 63 | app-open ads |
| `ads/ads_callback.dart` | 23 | dismiss/failed signalling |

Also moving here: the ad-interval counter (`loadCount`, `savedAds`) currently
living inside `radio_notifier`, and the interstitial gate in
`radio_player._openTimer`. Under ADR-005 `radio` cannot import `promotions`, so
the timer screen's "show an ad first" behaviour becomes an interface in
`radio/domain/interface/` with a host adapter in `templates/`.

## -> `comms`

No files, config only: `Constant.oneSignalId` and the OneSignal init block in
`main.dart`.

## -> `telemetry`

Nothing to move. `core/telemetry/dart` is an empty placeholder; the Frappe side
already has `src/telemetry` and an `api_error_log` doctype. Listener counting
starts as a DocType there, then a Dart client. `radio` reaches it through an
interface + host adapter, not a direct import.

## Splits

**`utils/constant.dart` (71 lines)** - one class, four owners:

| Keys | Owner |
|---|---|
| `appName`, `appMotto`, `minAppVersion`, social + privacy + about + rate URLs | `base` config / per-app values |
| `streamUrl`, `titleSeparators`, `itunesSearchUrl`, `deezerSearchUrl`, `deezerSearchHost`, `deezerApiKey`, `isRotate` | `radio` |
| `admobAppId`, `openAds`, `bannerAds`, `interAds`, all Unity + Facebook placements, `adsKey`, `adsIntervalClicks`, `adsInterval`, `showADS` | `promotions` |
| `oneSignalId` | `comms` |
| `messagingSenderId`, `myPreference`, `dismiss`, `failed` | `base` |

**`notifier/radio_notifier.dart` (220 lines)** - one class, four layers:

| Concern | Lands as |
|---|---|
| play/pause/toggle, volume, `RadioPlayer` wiring | `application/playback/` |
| `_normalizeMetadata` | `domain/` - pure, and the one piece that is unit-testable today |
| iTunes + Deezer HTTP | `infrastructure/repositories/` behind `domain/interface/` |
| `loadCount`, `savedAds`, `admobHelper` | `promotions`, via interface |

**`main.dart` (100 lines)** - dies as a file. App shells track zero `lib/`
files, so its content becomes manifest declarations: Firebase and OneSignal
boot -> `boot_hooks`, provider registration -> `di_hooks`, routes -> `routes`.

## Dies

| File | Lines | Why |
|---|---|---|
| `utils/html_view.dart` | 80 | unreferenced by any file in the tree |
| `widget/set_volume_dialog.dart` | 113 | unreferenced, and declares a second `VerticalSeekBar` duplicating `widget/seek_bar.dart` |
| `main.dart` | 100 | regenerated by the composer |

## Open questions

1. **Which monorepo hosts `radio`?** The checklist lists `core`, `zones`,
   `commerce`, `Users`, `pay`, `productivity`, `agent`, and says propose a new
   repo only if none fits. None obviously does.
2. **Does the app's composer template already have a `home_sdk` declarer?**
   `radio` wants to be it, and two is a hard error.
3. **`seek_bar.dart` and `blur_bg_widget.dart`** are generic enough for `base`
   but are used only by the player today. Cheap to move later either way.
4. **76 `Colors.*` sites across 16 files** must become `AppStyle.*` - raw
   `Colors.*` is forbidden in templates. That conversion belongs to the move,
   not to now.
