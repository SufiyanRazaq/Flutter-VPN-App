import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../apis/apis.dart';
import '../helpers/pref.dart';
import '../models/vpn.dart';
import '../controllers/location_controller.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final _locationController = LocationController();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.repeat(reverse: true);

    _navigateToHomeWithBackgroundFetch();
  }

  Future<void> _navigateToHomeWithBackgroundFetch() async {
    List<Vpn> serverData = Pref.vpnList;

    if (serverData.isEmpty) {
      serverData = await _locationController.getVpnData();
    }

    if (serverData.isNotEmpty && Pref.vpn.hostname.isNotEmpty) {
      final isValid = await APIs.isServerReachable(Pref.vpn.hostname);
      if (!isValid) {
        Pref.vpn =
            await _findFirstReachableServer(serverData) ?? serverData.first;
      }
    }
    Future.delayed(const Duration(seconds: 5), () {
      Get.off(() => HomeScreen(serverData: serverData));
    });
  }

  Future<Vpn?> _findFirstReachableServer(List<Vpn> servers) async {
    for (Vpn server in servers) {
      if (await APIs.isServerReachable(server.hostname)) {
        return server;
      }
    }
    return null;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 6),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2B5876),
                  Color(0xFF4E4376),
                ],
                stops: [
                  0.0,
                  1.0,
                ],
              ),
            ),
          ),
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 220,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Fast VPN',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 3,
                      shadows: [
                        Shadow(
                          blurRadius: 15.0,
                          color: Colors.black54,
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Fast & Secure Connection',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const SpinKitSpinningLines(
                    color: Colors.white,
                    size: 50.0,
                  ),
                ],
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: Text(
                'Connecting the World',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white60,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
