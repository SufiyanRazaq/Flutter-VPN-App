import 'package:get/get.dart';
import '../apis/apis.dart';
import '../helpers/pref.dart';
import '../models/vpn.dart';

class LocationController extends GetxController {
  List<Vpn> vpnList = Pref.vpnList;

  final RxBool isLoading = false.obs;
  Future<List<Vpn>> getVpnData() async {
    isLoading.value = true;

    try {
      vpnList = await APIs.getVPNServers();
      if (vpnList.isNotEmpty) {
        Pref.vpn = vpnList.first;
      } else {
        print("No VPN servers available.");
      }
    } catch (e) {
      print("Error fetching VPN data: $e");
      vpnList = [];
    }

    isLoading.value = false;
    return vpnList;
  }
}
