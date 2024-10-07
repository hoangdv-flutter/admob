package com.hoangdv.admob.admob.util

import android.app.Activity
import com.google.android.ump.ConsentDebugSettings
import com.google.android.ump.ConsentRequestParameters
import com.google.android.ump.UserMessagingPlatform
import com.hoangdv.admob.admob.PluginMethods
import io.flutter.plugin.common.MethodChannel

class UserConsentRequester {
    companion object {

        var onConsentRequestDismiss: (() -> Unit)? = null
        var onRequestInitAdSdk: (() -> Unit)? = null

        fun requestConsentInformation(
            channel: MethodChannel, activity: Activity
        ) {
            val debugSetting = ConsentDebugSettings.Builder(activity)
                .setDebugGeography(ConsentDebugSettings.DebugGeography.DEBUG_GEOGRAPHY_EEA)
                .addTestDeviceHashedId("5E9443F94E7A3271A01B7F72618F3CFB")
                .addTestDeviceHashedId("812201C6E5F501E98EA1298F4A034968")
                .build()

            val params = ConsentRequestParameters.Builder().setConsentDebugSettings(debugSetting)
                .setTagForUnderAgeOfConsent(false).build()

            val consentInformation = UserMessagingPlatform.getConsentInformation(activity)
            consentInformation.requestConsentInfoUpdate(activity, params, {
                UserMessagingPlatform.loadAndShowConsentFormIfRequired(
                    activity
                ) { _ ->
                    onRequestInitAdSdk?.invoke()
                    onConsentRequestDismiss?.invoke()
                    channel.invokeMethod(PluginMethods.onRequestInitAdSdk, "")
                    channel.invokeMethod(PluginMethods.onConsentDismiss, "")
                }
            }, { _ ->
                onConsentRequestDismiss?.invoke()
                channel.invokeMethod(PluginMethods.onConsentDismiss, "")
            })
            onRequestInitAdSdk?.invoke()
            channel.invokeMethod(PluginMethods.onRequestInitAdSdk, "")
        }
    }
}