class InterstitialNativeConfig {
  bool showable;
  bool nativeFullScreen;

  InterstitialNativeConfig({
    required this.showable,
    required this.nativeFullScreen,
  });

  factory InterstitialNativeConfig.fromJson(Map<String, dynamic> json) => InterstitialNativeConfig(
    showable: json["showable"],
    nativeFullScreen: json["native_full_screen"],
  );

  Map<String, dynamic> toJson() => {
    "showable": showable,
    "native_full_screen": nativeFullScreen,
  };
}