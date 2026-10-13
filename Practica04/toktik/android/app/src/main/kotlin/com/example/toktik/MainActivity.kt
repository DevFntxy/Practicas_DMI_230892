package com.example.toktik

import android.content.ComponentName
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "com.example.toktik/seasonal_launcher_icon"
    private val aliasNames = mapOf(
        "normal" to "MainActivityNormal",
        "halloween" to "MainActivityHalloween",
        "christmas" to "MainActivityChristmas",
        "valentines" to "MainActivityValentines",
    )

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                if (call.method != "setSeasonalIcon") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }

                val season = call.argument<String>("season")
                if (season == null || season !in aliasNames) {
                    result.error(
                        "INVALID_SEASON",
                        "Unknown seasonal app icon: $season",
                        null,
                    )
                    return@setMethodCallHandler
                }

                try {
                    setSeasonalIcon(season)
                    result.success(null)
                } catch (error: Exception) {
                    result.error("ICON_UPDATE_FAILED", error.message, null)
                }
            }
    }

    private fun setSeasonalIcon(season: String) {
        val flags = PackageManager.DONT_KILL_APP
        val selectedComponent = ComponentName(
            packageName,
            "$packageName.${aliasNames.getValue(season)}",
        )
        packageManager.setComponentEnabledSetting(
            selectedComponent,
            PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
            flags,
        )

        aliasNames.values
            .filter { it != aliasNames.getValue(season) }
            .forEach { aliasName ->
                packageManager.setComponentEnabledSetting(
                    ComponentName(packageName, "$packageName.$aliasName"),
                    PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                    flags,
                )
            }
    }
}
