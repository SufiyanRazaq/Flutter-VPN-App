import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../apis/apis.dart';
import '../helpers/config.dart';
import '../models/ip_details.dart';

class NetworkTestScreen extends StatefulWidget {
  const NetworkTestScreen({super.key});

  @override
  _NetworkTestScreenState createState() => _NetworkTestScreenState();
}

class _NetworkTestScreenState extends State<NetworkTestScreen> {
  final ipData = IPDetails.fromJson({}).obs;
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    APIs.getIPDetails(ipData: ipData);
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: Config.bannerAd,
      size: AdSize.mediumRectangle,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          setState(() {
            _isBannerAdLoaded = false;
          });
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        backgroundColor: Color.fromARGB(255, 36, 85, 117),
        title: Text(
          "Connection Details",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
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
            Expanded(
              child: Obx(
                () => ListView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(16.0),
                  children: [
                    _networkCard(
                      title: 'IP Address',
                      subtitle: ipData.value.query.isNotEmpty
                          ? ipData.value.query
                          : 'Fetching...',
                      icon: CupertinoIcons.location_solid,
                      iconColor: Color(0xFF4E4376),
                    ),
                    _networkCard(
                      title: 'Internet Provider',
                      subtitle: ipData.value.isp.isNotEmpty
                          ? ipData.value.isp
                          : 'Fetching...',
                      icon: Icons.business,
                      iconColor: Color(0xFF4E4376),
                    ),
                    _networkCard(
                      title: 'Location',
                      subtitle: ipData.value.country.isNotEmpty
                          ? '${ipData.value.city}, ${ipData.value.regionName}, ${ipData.value.country}'
                          : 'Fetching...',
                      icon: CupertinoIcons.location,
                      iconColor: Color(0xFF4E4376),
                    ),
                    _networkCard(
                      title: 'Pin-code',
                      subtitle: ipData.value.zip.isNotEmpty
                          ? ipData.value.zip
                          : 'Fetching...',
                      icon: CupertinoIcons.location_solid,
                      iconColor: Color(0xFF4E4376),
                    ),
                    _networkCard(
                      title: 'Timezone',
                      subtitle: ipData.value.timezone.isNotEmpty
                          ? ipData.value.timezone
                          : 'Fetching...',
                      icon: CupertinoIcons.time,
                      iconColor: Color(0xFF4E4376),
                    ),
                    if (_isBannerAdLoaded)
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(vertical: 16.0),
                        height: _bannerAd!.size.height.toDouble(),
                        width: _bannerAd!.size.width.toDouble(),
                        child: AdWidget(ad: _bannerAd!),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _networkCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                iconColor.withOpacity(0.8),
                iconColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
