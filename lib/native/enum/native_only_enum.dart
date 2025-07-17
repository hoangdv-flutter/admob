part of '../native_ads_only_loader.dart';

enum NativeOnlyEnum { home, piano, lesson, guitar, drum, saxophone }

extension NativeOnlyEnumExtension on NativeOnlyEnum {
  
  get nativeDebug => "ca-app-pub-3940256099942544/2247696110";
      
  get bannerDebug => "ca-app-pub-3940256099942544/6300978111";
  
  String get adsID {
    switch (this) {
      case NativeOnlyEnum.home:
        return kDebugMode
            ? nativeDebug
            : "ca-app-pub-5390451356176712/3488563064";
      case NativeOnlyEnum.piano:
        return kDebugMode
            ? nativeDebug
            : "ca-app-pub-5390451356176712/4700436916";
      case NativeOnlyEnum.lesson:
        return kDebugMode
            ? nativeDebug
            : "ca-app-pub-5390451356176712/5513705574";
      case NativeOnlyEnum.guitar:
        return kDebugMode
            ? nativeDebug
            : "ca-app-pub-5390451356176712/1128023412";
      case NativeOnlyEnum.drum:
        return kDebugMode
            ? nativeDebug
            : "ca-app-pub-5390451356176712/4875696734";
      case NativeOnlyEnum.saxophone:
        return kDebugMode
            ? nativeDebug
            : "ca-app-pub-5390451356176712/3043740311";
    }
  }

  String get nativeId {
    switch (this) {
      case NativeOnlyEnum.home:
        return "native_home_on_off";
      case NativeOnlyEnum.piano:
        return "native_play_piano_on_off";
      case NativeOnlyEnum.lesson:
        return "native_learn_piano_on_off";
      case NativeOnlyEnum.guitar:
        return "native_guitar_on_off";
      case NativeOnlyEnum.drum:
        return "native_drum_on_off";
      case NativeOnlyEnum.saxophone:
        return "native_saxophone_on_off";
    }
  }

  String get factoryID {
    switch (this) {
      case NativeOnlyEnum.home:
        return NativeAdsFactory.nativeTemplateHigh;
      case NativeOnlyEnum.piano:
        return NativeAdsFactory.nativeTemplateHigh;
      case NativeOnlyEnum.lesson:
        return NativeAdsFactory.nativeTemplateHigh;
      case NativeOnlyEnum.guitar:
        return NativeAdsFactory.nativeTemplateHigh;
      case NativeOnlyEnum.drum:
        return NativeAdsFactory.nativeTemplateHigh;
      case NativeOnlyEnum.saxophone:
        return NativeAdsFactory.nativeTemplateHigh;
    }
  }

  String get bannerID {
    switch (this) {
      case NativeOnlyEnum.home:
        return "banner_home_on_off";
      case NativeOnlyEnum.piano:
        return "banner_play_piano_on_off";
      case NativeOnlyEnum.lesson:
        return "banner_learn_piano_on_off";
      case NativeOnlyEnum.guitar:
        return "banner_guitar_on_off";
      case NativeOnlyEnum.drum:
        return "banner_drum_on_off";
      case NativeOnlyEnum.saxophone:
        return "banner_saxophone_on_off";
    }
  }

  String get bannerAdsID {
    switch (this) {
      case NativeOnlyEnum.home:
        return kDebugMode
            ? bannerDebug
            : "ca-app-pub-5390451356176712/5265659106";
      case NativeOnlyEnum.piano:
        return kDebugMode
            ? bannerDebug
            : "ca-app-pub-5390451356176712/9167646609";
      case NativeOnlyEnum.lesson:
        return kDebugMode
            ? bannerDebug
            : "ca-app-pub-5390451356176712/8639681923";
      case NativeOnlyEnum.guitar:
        return kDebugMode
            ? bannerDebug
            : "ca-app-pub-5390451356176712/5877787219";
      case NativeOnlyEnum.drum:
        return kDebugMode
            ? bannerDebug
            : "ca-app-pub-5390451356176712/9631816509";
      case NativeOnlyEnum.saxophone:
        return kDebugMode
            ? bannerDebug
            : "ca-app-pub-5390451356176712/4564705546";
    }
  }
}
