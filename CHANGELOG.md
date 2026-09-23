## 0.1.0

**Nâng lên google_mobile_ads 9.x + chạy được trên app AGP 9.**

- `google_mobile_ads` `any` → **`^9.1.0`** (GMA Android 25.4.0, iOS 13.7.0,
  UMP Android 4.0.0). Từ 9.x, interface `NativeAdFactory` là class top-level
  `io.flutter.plugins.googlemobileads.NativeAdFactory` thay cho
  `GoogleMobileAdsPlugin.NativeAdFactory` (lồng) — đã sửa import trong
  `BaseNativeAdFactory`, `MediumNativeAdFactory`, `SmallNativeAdViewFactory`.
  Bản cũ báo `Unresolved reference 'NativeAdFactory'` ở `:admob:compileDebugKotlin`.
- Các factory viết cho biến thể **Play Services** (mặc định) của GMA. App nào
  bật `useNextGenSdk` thì kiểu `NativeAd` khác ⇒ factory không biên dịch.
- Android: `compileSdk` 31 → **36**, `minSdk` 16 → **24** (sàn của
  google_mobile_ads 9.x), UMP 2.1.0 → **4.0.0** (bản google_mobile_ads đã kéo
  vào; khai bản cũ chỉ gây hiểu nhầm vì Gradle vẫn lấy bản cao hơn).
- Dart SDK sàn 3.4.1 → **3.10.0**, Flutter 3.3.0 → **3.38.1** (sàn của
  google_mobile_ads 8+).
- Khai `plugin_platform_interface` — code vẫn `import` mà không khai trong
  `pubspec.yaml` (sống nhờ transitive).
- `publish_to: none` (package có `path` dependency tới `flutter_core`).

### Lưu ý cho app dùng package
- Đặt package ở `packages/core/admob`, **cạnh `flutter_core`**
  (pubspec khai `flutter_core: path: ../flutter_core/`).
- App **bắt buộc** khai AdMob App ID, thiếu là crash ngay lúc mở kể cả khi chưa
  hiện quảng cáo nào: Android `com.google.android.gms.ads.APPLICATION_ID`
  (meta-data trong `AndroidManifest.xml`), iOS `GADApplicationIdentifier`
  (`Info.plist`).
- iOS dùng Swift Package Manager: mọi plugin Firebase phải trỏ **cùng một bản**
  firebase-ios-sdk — ghim `firebase_remote_config` cùng đợt phát hành với
  `firebase_core` của app.
- iOS: package chưa hỗ trợ SPM ⇒ vẫn nạp qua CocoaPods.

## 0.0.1

* Bản đầu.
