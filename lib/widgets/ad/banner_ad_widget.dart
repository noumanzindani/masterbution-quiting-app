import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../config.dart';
import '../../services/ad_service.dart';

/// A self-censoring banner. It renders `SizedBox.shrink()` whenever the tested
/// [AdPolicy] (via `adService.canShowAds()`) says ads are disallowed — e.g. a
/// no-ad route or an active post-lapse cooldown — so it is safe to drop onto
/// any screen. Only place it on non-crisis screens regardless (defence in
/// depth): here, the dashboard and settings.
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    if (adService.canShowAds()) _load();
  }

  void _load() {
    final ad = BannerAd(
      adUnitId: AdService.bannerUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, _) => ad.dispose(),
      ),
    );
    _ad = ad;
    ad.load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Re-check the policy at paint time so a cooldown that starts after load
    // (e.g. right after logging a lapse) still hides the banner.
    if (!_loaded || _ad == null || !adService.canShowAds()) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      width: _ad!.size.width.toDouble(),
      height: _ad!.size.height.toDouble(),
      child: AdWidget(ad: _ad!),
    );
  }
}
