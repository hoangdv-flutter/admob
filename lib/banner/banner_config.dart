class BannerConfig {
  bool showable;
  bool collapsible;

  BannerConfig({
    required this.showable,
    required this.collapsible,
  });

  factory BannerConfig.fromJson(Map<String, dynamic> json) => BannerConfig(
        showable: json["showable"],
        collapsible: json["collapsible"],
      );

  Map<String, dynamic> toJson() => {
        "showable": showable,
        "collapsible": collapsible,
      };
}
