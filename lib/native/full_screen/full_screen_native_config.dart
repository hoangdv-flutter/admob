part of 'full_screen_native_loader.dart';

class FullScreenNativeConfig {
  bool fullscreenNativeAfterInter;
  int durationInSeconds;

  FullScreenNativeConfig({
    required this.fullscreenNativeAfterInter,
    required this.durationInSeconds,
  });

  static FullScreenNativeConfig defaultConfig() => FullScreenNativeConfig(
      fullscreenNativeAfterInter: true, durationInSeconds: 5);

  factory FullScreenNativeConfig.fromJson(Map<String, dynamic> json) =>
      FullScreenNativeConfig(
        fullscreenNativeAfterInter: json["fullscreen_native_after_inter"],
        durationInSeconds: json["duration_in_seconds"],
      );

  Map<String, dynamic> toJson() => {
        "fullscreen_native_after_inter": fullscreenNativeAfterInter,
        "duration_in_seconds": durationInSeconds,
      };
}
