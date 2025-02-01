import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn/apis/apis.dart';
import '../helpers/ad_helper.dart';
import '../helpers/pref.dart';
import '../models/vpn.dart';
import '../models/vpn_config.dart';
import '../services/vpn_engine.dart';

class HomeController extends GetxController {
  final Rx<Vpn> vpn = Pref.vpn.obs;
  final vpnState = VpnEngine.vpnDisconnected.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchVpnServers();

    vpnState.listen((state) {
      if (state == VpnEngine.vpnConnected) {
        print("VPN Connected: Showing Ad.");

        AdHelper.showInterstitialAd(onComplete: () {
          print("Ad shown successfully after VPN connected.");
        });
      }
    });
  }

  Future<void> _fetchVpnServers() async {
    if (Pref.vpnList.isNotEmpty) {
      if (vpn.value.hostname.isEmpty ||
          !await APIs.isServerReachable(vpn.value.hostname)) {
        vpn.value =
            await _findFirstReachableServer(Pref.vpnList) ?? Pref.vpnList.first;
      }
    } else {
      print("VPN List is empty. Fetch servers first.");
    }
  }

  Future<Vpn?> _findFirstReachableServer(List<Vpn> servers) async {
    for (Vpn server in servers) {
      if (await APIs.isServerReachable(server.hostname)) {
        return server;
      }
    }
    return null;
  }

  void connectToVpn() async {
    if (vpn.value.openVPNConfigDataBase64.isEmpty) {
      print('Select a Location by clicking \'Change Location\'');
      return;
    }

    if (vpnState.value == VpnEngine.vpnDisconnected) {
      final data = Base64Decoder().convert(vpn.value.openVPNConfigDataBase64);
      final config = Utf8Decoder().convert(data);
      final vpnConfig = VpnConfig(
          country: vpn.value.countryLong,
          username: 'vpn',
          password: 'vpn',
          config: config);

      vpnState.value = VpnEngine.vpnConnecting;

      await VpnEngine.startVpn(vpnConfig);
      vpnState.value = VpnEngine.vpnConnected;
    } else {
      await VpnEngine.stopVpn();

      vpnState.value = VpnEngine.vpnDisconnected;
    }
  }

  Color get getButtonColor {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return Colors.blue;
      case VpnEngine.vpnConnected:
        return Colors.green;
      default:
        return Colors.orangeAccent;
    }
  }

  String get getButtonText {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return 'Tap to Connect';
      case VpnEngine.vpnConnected:
        return 'Disconnect';
      default:
        return 'Connecting...';
    }
  }
}
