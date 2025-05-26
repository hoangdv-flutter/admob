class AdLoaderListener {
  final Function()? onAdFailedToLoad;

  final Function()? onAdConsume;

  final Function()? onAdStartShow;

  final Function()? onAdClosed;

  final Function()? onAdFailedToShow;

  final Function()? onAdClick;

  Function()? onInterPassed;

  bool _triggerFailedToLoad = false;

  void triggerAdsFailedToLoad() {
    if (_triggerFailedToLoad) return;
    _triggerFailedToLoad = true;
    onAdFailedToLoad?.call();
  }

  AdLoaderListener(
      {this.onAdFailedToLoad,
      this.onInterPassed,
      this.onAdConsume,
      this.onAdStartShow,
      this.onAdClosed,
      this.onAdFailedToShow,
      this.onAdClick, });

  AdLoaderListener copyWith({
    Function()? onAdFailedToLoad,
    Function()? onAdConsume,
    Function()? onAdStartShow,
    Function()? onAdClosed,
    Function()? onAdFailedToShow,
    Function()? onInterPassed,
    Function()? onAdClick,

    bool? triggerFailedToLoad,
  }) {
    return AdLoaderListener(
      onAdFailedToLoad: onAdFailedToLoad ?? this.onAdFailedToLoad,
      onAdConsume: onAdConsume ?? this.onAdConsume,
      onAdStartShow: onAdStartShow ?? this.onAdStartShow,
      onAdClosed: onAdClosed ?? this.onAdClosed,
      onAdFailedToShow: onAdFailedToShow ?? this.onAdFailedToShow,
      onInterPassed: onInterPassed ?? this.onInterPassed,
      onAdClick: onAdClick ?? this.onAdClick
    );
  }
}
