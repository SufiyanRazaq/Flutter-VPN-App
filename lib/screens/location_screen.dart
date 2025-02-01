import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';

import '../controllers/location_controller.dart';
import '../controllers/native_ad_controller.dart';
import '../helpers/ad_helper.dart';
import '../main.dart';
import '../widgets/vpn_card.dart';

class LocationScreen extends StatelessWidget {
  LocationScreen({super.key});

  final _controller = LocationController();
  final _adController = NativeAdController();

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (_controller.vpnList.isEmpty) _controller.getVpnData();

    _adController.ad = AdHelper.loadNativeAd(adController: _adController);

    return Obx(
      () => Scaffold(
        bottomNavigationBar:
            _adController.ad != null && _adController.adLoaded.isTrue
                ? SafeArea(
                    child: SizedBox(
                        height: 85, child: AdWidget(ad: _adController.ad!)),
                  )
                : null,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10, right: 10),
          child: FloatingActionButton(
              backgroundColor: const Color(0xFF4E54C8),
              onPressed: () => _controller.getVpnData(),
              child: const Icon(
                CupertinoIcons.refresh,
                color: Colors.white,
              )),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2B5876),
                Color(0xFF4E4376),
              ],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 36.0, left: 20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Select Server Location',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            hintText: 'Search for servers...',
                            hintStyle: const TextStyle(
                                color: Colors.white70, fontSize: 16),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${_controller.vpnList.length} Servers',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _controller.isLoading.value
                    ? _loadingWidget()
                    : _controller.vpnList.isEmpty
                        ? _noVPNFound()
                        : _vpnData(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _vpnData() => ListView.builder(
        itemCount: _controller.vpnList.length,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemBuilder: (ctx, i) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: VpnCard(vpn: _controller.vpnList[i]),
        ),
      );

  Widget _loadingWidget() => SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset('assets/lottie/loading.json',
                width: mq.width * .7),
            const Text(
              'Loading Servers...',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );

  Widget _noVPNFound() => const Center(
        child: Text(
          'Servers Not Found!',
          style: TextStyle(
              fontSize: 18, color: Colors.white70, fontWeight: FontWeight.bold),
        ),
      );
}
