import 'dart:convert';
import 'dart:developer';
import 'package:csv/csv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:vpn/models/ip_details.dart';
import '../helpers/pref.dart';
import '../models/vpn.dart';

class APIs {
  static Future<bool> isServerReachable(String host) async {
    try {
      final response = await get(Uri.parse(host)).timeout(Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<List<Vpn>> getVPNServers() async {
    final List<Vpn> vpnList = [];

    try {
      final res = await get(Uri.parse('http://www.vpngate.net/api/iphone/'));

      if (res.statusCode != 200) {
        log('Error: Failed to fetch servers, status code: ${res.statusCode}');
        return [];
      }

      final csvString = res.body.split("#")[1].replaceAll('*', '');

      List<List<dynamic>> list = const CsvToListConverter().convert(csvString);

      final header = list[0];
      for (int i = 1; i < list.length - 1; ++i) {
        Map<String, dynamic> tempJson = {};
        for (int j = 0; j < header.length; ++j) {
          tempJson.addAll({header[j].toString(): list[i][j]});
        }

        if (tempJson['HostName'] != null &&
            tempJson['OpenVPN_ConfigData_Base64'] != null) {
          vpnList.add(Vpn.fromJson(tempJson));
        } else {
          log('Skipping invalid server data: $tempJson');
        }
      }
    } catch (e) {
      log('Error fetching or parsing servers: $e');
    }

    vpnList.shuffle();

    if (vpnList.isNotEmpty) Pref.vpnList = vpnList;

    return vpnList;
  }

  static Future<void> getIPDetails({required Rx<IPDetails> ipData}) async {
    try {
      final res = await get(Uri.parse('http://ip-api.com/json/'));
      final data = jsonDecode(res.body);
      log(data.toString());
      ipData.value = IPDetails.fromJson(data);
    } catch (e) {
      print(e.toString());
      log('\ngetIPDetailsE: $e');
    }
  }
}
