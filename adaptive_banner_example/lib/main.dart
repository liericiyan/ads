// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  // List<String> testDeviceIds = ['B7655A8D010E8F25844ACB84F3B9CBC7'];
  // RequestConfiguration configuration =
  // RequestConfiguration(testDeviceIds: testDeviceIds);
  // MobileAds.instance.updateRequestConfiguration(configuration);
  runApp(const MaterialApp(
    home: AdaptiveBannerExample(),
  ));
}

/// A simple app that loads an adaptive banner ad.
class AdaptiveBannerExample extends StatefulWidget {
  const AdaptiveBannerExample({super.key});

  @override
  AdaptiveBannerExampleState createState() => AdaptiveBannerExampleState();
}

class AdaptiveBannerExampleState extends State<AdaptiveBannerExample> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  Orientation? _currentOrientation;

  // final String _adUnitId = Platform.isAndroid
  //     ? 'ca-app-pub-3940256099942544/9214589741'
  //     : 'ca-app-pub-3940256099942544/2435281174';
  // final String _adUnitId = Platform.isAndroid
  //     ? 'ca-app-pub-8211126797345278/4962171077'
  //     : 'ca-app-pub-6347756925167370/1601025467';
  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-8211126797345278/7877507827'
      : 'ca-app-pub-6347756925167370/1601025467';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Adaptive Banner Example',
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Adaptive Banner Example'),
            ),
            body: OrientationBuilder(
              builder: (context, orientation) {
                if (_currentOrientation != orientation) {
                  _isLoaded = false;
                  _loadAd();
                  _currentOrientation = orientation;
                }

                return Stack(
                  children: [
                    if (_bannerAd != null && _isLoaded)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SafeArea(
                          child: SizedBox(
                            width: _bannerAd!.size.width.toDouble(),
                            height: _bannerAd!.size.height.toDouble(),
                            child: AdWidget(ad: _bannerAd!),
                          ),
                        ),
                      )
                  ],
                );
              },
            )));
  }

  /// Loads and shows a banner ad.
  ///
  /// Dimensions of the ad are determined by the width of the screen.
  void _loadAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.sizeOf(context).width.truncate());

    if (size == null) {
      // Unable to get width of anchored banner.
      return;
    }

    BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    ).load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
