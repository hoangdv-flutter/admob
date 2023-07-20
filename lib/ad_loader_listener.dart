class AdLoaderListener {
  final Function()? onAdFailedToLoad;

  final Function()? onAdConsume;

  final Function()? onAdStartShow;

  final Function()? onAdClosed;

  final Function()? onAdFailedToShow;

  final Function()? onInterPassed;

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
      this.onAdFailedToShow});
}
