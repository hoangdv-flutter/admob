part of 'full_screen_native_loader.dart';

class MediumNativeAdsBanner extends StatefulWidget {
  final Stream<NativeAdLoaderState>? adStreamLoader;

  final double adSize;

  final EdgeInsetsGeometry? margin;

  final EdgeInsetsGeometry? padding;

  const MediumNativeAdsBanner(
      {Key? key,
      this.adStreamLoader,
      required this.adSize,
      this.margin,
      this.padding})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MediumNativeAdsBannerState();
}

class _MediumNativeAdsBannerState extends NormalNativeAdState {
  late final _premiumCubit = PremiumCubit();


  @override
  void dispose() {
    _premiumCubit.close();
    super.dispose();
  }

  @override
  String get nativeAdFactory => NativeAdsFactory.fullScreenNativeAd;
}
