package com.hoangdv.admob.admob.native_ads

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import androidx.annotation.LayoutRes
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import com.hoangdv.admob.admob.R
import com.hoangdv.admob.admob.ext.isVisible
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

abstract class BaseNativeAdFactory(
    private val context: Context,
    @LayoutRes private val resLayout: Int
) :
    GoogleMobileAdsPlugin.NativeAdFactory {

    protected var view: View? = null

    protected var nativeView: NativeAdView? = null

    protected var headlineV: TextView? = null

    protected var mediaV: MediaView? = null

    protected var bodyV: TextView? = null

    protected var iconV: ImageView? = null

    protected var callToActionV: TextView? = null

    protected var adLabelV: View? = null

    override fun createNativeAd(
        nativeAd: NativeAd?,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        view = LayoutInflater.from(context).inflate(resLayout, null)
        nativeView = view?.findViewById(R.id.native_ad_view)
        headlineV = view?.findViewById(R.id.tv_title)
        mediaV = view?.findViewById(R.id.media_view)
        bodyV = view?.findViewById(R.id.tv_description)
        iconV = view?.findViewById(R.id.img_icon)
        callToActionV = view?.findViewById(R.id.tv_install)
        adLabelV = view?.findViewById(R.id.tv_ad_label)
        nativeView?.apply {
            this.mediaView = mediaV
            this.mediaView?.mediaContent = nativeAd?.mediaContent
            this.headlineView = headlineV
            this.bodyView = bodyV
            this.iconView = iconV
            this.callToActionView = callToActionV
        }
        bodyV?.apply {
            isVisible = !nativeAd?.body.isNullOrEmpty()
            text = nativeAd?.body
        }
        callToActionV?.apply {
            text = nativeAd?.callToAction
            isVisible = !nativeAd?.callToAction.isNullOrEmpty()
        }
        iconV?.apply {
            setImageDrawable(nativeAd?.icon?.drawable)
            isVisible = nativeAd?.icon?.drawable != null
        }
        headlineV?.text = nativeAd?.headline

        nativeAd?.let { nativeView?.setNativeAd(it) }
        return nativeView!!
    }
}