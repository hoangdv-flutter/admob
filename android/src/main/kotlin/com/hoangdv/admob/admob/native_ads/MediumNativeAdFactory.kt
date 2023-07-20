package com.hoangdv.admob.admob.native_ads

import android.view.LayoutInflater
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import com.hoangdv.admob.admob.databinding.MediumNativeAdsBinding
import com.hoangdv.admob.admob.ext.isVisible
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory

class MediumNativeAdFactory(private val layoutInflater: LayoutInflater) : NativeAdFactory {

    companion object {
        const val FACTORY_ID = "mediumNativeAdView"
    }

    override fun createNativeAd(
        nativeAd: NativeAd?,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val binding = MediumNativeAdsBinding.inflate(layoutInflater)
        binding.root.apply {
            mediaView = binding.mediaView
            headlineView = binding.tvTitle
            bodyView = binding.tvDescription
            iconView = binding.imgIcon
            callToActionView = binding.tvInstall
        }
        binding.mediaView.mediaContent = nativeAd?.mediaContent
        binding.tvDescription.apply {
            isVisible = !nativeAd?.body.isNullOrEmpty()
            text = nativeAd?.body
        }
        binding.tvInstall.apply {
            text = nativeAd?.callToAction
            isVisible = !nativeAd?.callToAction.isNullOrEmpty()
        }
        binding.imgIcon.apply {
            setImageDrawable(nativeAd?.icon?.drawable)
            isVisible = nativeAd?.icon?.drawable != null
        }
        binding.tvTitle.text = nativeAd?.headline

        nativeAd?.let { binding.root.setNativeAd(it) }
        return binding.root
    }
}