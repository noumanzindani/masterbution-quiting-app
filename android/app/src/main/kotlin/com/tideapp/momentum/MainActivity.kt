package com.tideapp.momentum

import android.content.ComponentName
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Hosts the Flutter engine plus the "discreet mode" platform channel.
 *
 * Discreet mode swaps the launcher entry between the default [MainActivity] and
 * a disguised `<activity-alias>` (its own neutral label + icon). We enable
 * exactly one launcher component at a time via [PackageManager], so the app
 * always shows a single home-screen icon. `DONT_KILL_APP` keeps the running
 * process alive through the switch.
 */
class MainActivity : FlutterActivity() {
    private val channelName = "com.tideapp.momentum/disguise"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setDiscreet" -> {
                        val enabled = call.argument<Boolean>("enabled") ?: false
                        applyDiscreet(enabled)
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun applyDiscreet(enabled: Boolean) {
        val pm = packageManager
        val defaultComponent = ComponentName(this, "$packageName.MainActivity")
        val disguiseComponent = ComponentName(this, "$packageName.DisguiseAlias")

        val toEnable = if (enabled) disguiseComponent else defaultComponent
        val toDisable = if (enabled) defaultComponent else disguiseComponent

        pm.setComponentEnabledSetting(
            toEnable,
            PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
            PackageManager.DONT_KILL_APP,
        )
        pm.setComponentEnabledSetting(
            toDisable,
            PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
            PackageManager.DONT_KILL_APP,
        )
    }
}
