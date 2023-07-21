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

    protected var nativeAdView: NativeAdView? = null

    protected var headlineView: TextView? = null

    protected var mediaView: MediaView? = null

    protected var bodyView: TextView? = null

    protected var iconView: ImageView? = null

    protected var callToActionView: TextView? = null

    protected var adLabelView: View? = null

    override fun createNativeAd(
        nativeAd: NativeAd?,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        view = LayoutInflater.from(context).inflate(resLayout, null)
        nativeAdView = view?.findViewById(R.id.native_ad_view)
        headlineView = view?.findViewById(R.id.tv_title)
        mediaView = view?.findViewById(R.id.media_view)
        bodyView = view?.findViewById(R.id.tv_description)
        iconView = view?.findViewById(R.id.img_icon)
        callToActionView = view?.findViewById(R.id.tv_install)
        adLabelView = view?.findViewById(R.id.tv_ad_label)
        nativeAdView?.apply {
            this.mediaView = mediaView
            this.mediaView?.mediaContent = nativeAd?.mediaContent
            this.headlineView = headlineView
            this.bodyView = bodyView
            this.iconView = iconView
            this.callToActionView = callToActionView
        }
        bodyView?.apply {
            isVisible = !nativeAd?.body.isNullOrEmpty()
            text = nativeAd?.body
        }
        callToActionView?.apply {
            text = nativeAd?.callToAction
            isVisible = !nativeAd?.callToAction.isNullOrEmpty()
        }
        iconView?.apply {
            setImageDrawable(nativeAd?.icon?.drawable)
            isVisible = nativeAd?.icon?.drawable != null
        }
        headlineView?.text = nativeAd?.headline

        nativeAd?.let { nativeAdView?.setNativeAd(it) }
        return nativeAdView!!
    }
}