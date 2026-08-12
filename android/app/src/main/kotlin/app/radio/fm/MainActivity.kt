package app.radio.fm

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    // Replaces the discontinued back_button_behavior plugin, which was three
    // lines of real behaviour wrapped in an abandoned dependency. Sending the
    // task to the back keeps the process -- and playback -- alive, which is
    // what the player's "Background" exit does.
    private val channelName = "app.radio.fm/app_background"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "minimize" -> {
                        moveTaskToBack(true)
                        result.success(null)
                    }
                    // The original plugin fell through to result.success(1)
                    // after notImplemented(), replying twice and throwing on
                    // newer engines. Return here instead.
                    else -> result.notImplemented()
                }
            }
    }
}
