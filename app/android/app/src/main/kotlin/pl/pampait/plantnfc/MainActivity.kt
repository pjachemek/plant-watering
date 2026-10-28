package pl.pampait.plantnfc

import android.app.PendingIntent
import android.content.Intent
import android.content.IntentFilter
import android.nfc.NfcAdapter
import android.os.Build
import android.os.PatternMatcher
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * While the app is on screen, stickers holding our tag link come straight to
 * this activity instead of Android's "open web link" prompt (ADR-0010).
 * Flutter's deep linking then routes the intent's URI to `/p/:tagToken`.
 *
 * The filter matches only `https://plants.pampait.pl/p/...`, so every other
 * tag, and phone-as-card features such as contactless payment, keep working
 * through Android as usual. No polling is added: Android already polls for
 * NFC while the screen is on.
 *
 * Android drops this filter whenever reader mode (used to write stickers) is
 * turned off, so Dart switches it off while an NFC session is open and back on
 * when the session closes, through the `tag_dispatch` channel.
 */
class MainActivity : FlutterActivity() {
    private val nfcAdapter: NfcAdapter? by lazy { NfcAdapter.getDefaultAdapter(this) }

    /** False while Dart holds an NFC reader session. */
    private var dispatchWanted = true
    private var resumed = false

    private val tagLinkFilters by lazy {
        arrayOf(
            IntentFilter(NfcAdapter.ACTION_NDEF_DISCOVERED).apply {
                addDataScheme("https")
                addDataAuthority(TAG_HOST, null)
                addDataPath(TAG_PATH_PREFIX, PatternMatcher.PATTERN_PREFIX)
            },
        )
    }

    private val dispatchIntent: PendingIntent by lazy {
        // Explicit component: only this activity can receive it. It must be
        // mutable on Android 12+ so the system can attach the tag data.
        val intent = Intent(this, MainActivity::class.java)
            .addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
        val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            PendingIntent.FLAG_MUTABLE
        } else {
            0
        }
        PendingIntent.getActivity(this, 0, intent, flags)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setEnabled" -> {
                        dispatchWanted = call.arguments as? Boolean ?: true
                        applyDispatch()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onResume() {
        super.onResume()
        resumed = true
        applyDispatch()
    }

    override fun onPause() {
        resumed = false
        nfcAdapter?.disableForegroundDispatch(this)
        super.onPause()
    }

    /** Foreground dispatch may only be changed while this activity is resumed. */
    private fun applyDispatch() {
        val adapter = nfcAdapter ?: return
        if (!resumed) return
        if (dispatchWanted && adapter.isEnabled) {
            adapter.enableForegroundDispatch(this, dispatchIntent, tagLinkFilters, null)
        } else {
            adapter.disableForegroundDispatch(this)
        }
    }

    private companion object {
        const val CHANNEL = "pl.pampait.plantnfc/tag_dispatch"
        const val TAG_HOST = "plants.pampait.pl"
        const val TAG_PATH_PREFIX = "/p/"
    }
}
