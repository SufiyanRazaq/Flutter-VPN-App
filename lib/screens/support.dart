import 'dart:ui';
import 'package:flutter/material.dart';

class VPNHelpSupportScreen extends StatefulWidget {
  @override
  _VPNHelpSupportScreenState createState() => _VPNHelpSupportScreenState();
}

class _VPNHelpSupportScreenState extends State<VPNHelpSupportScreen> {
  List<Map<String, String>> faqs = [
    {
      'question': 'How do I connect to the VPN?',
      'answer':
          'To connect, simply open the app and press the "Connect" button on the main screen.'
    },
    {
      'question': 'How do I change my VPN server?',
      'answer':
          'Navigate to the "Server Selection" screen, choose a server, and press "Connect."'
    },
    {
      'question': 'Why is my connection slow?',
      'answer':
          'Connection speed can be affected by various factors, including server location and network congestion.'
    },
  ];
  List<bool> _expandedFAQ = [];

  @override
  void initState() {
    super.initState();
    _expandedFAQ = List.generate(faqs.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                          'Help & Support',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildSupportSection(
                    title: 'FAQs',
                    content: buildFAQsList(),
                  ),
                  buildSupportSection(
                    title: 'Troubleshooting Guides',
                    content: Column(
                      children: [
                        buildGuideTile(
                          icon: Icons.network_check,
                          title: 'Network Issues',
                          onTap: () {},
                        ),
                        buildGuideTile(
                          icon: Icons.security,
                          title: 'Connection Problems',
                          onTap: () {},
                        ),
                        buildGuideTile(
                          icon: Icons.speed,
                          title: 'Slow Speed',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  buildSupportSection(
                    title: 'Contact Support',
                    content: Column(
                      children: [
                        buildContactOption(
                          icon: Icons.email,
                          title: 'Email Support',
                          onTap: () {},
                        ),
                        buildContactOption(
                          icon: Icons.phone,
                          title: 'Call Support',
                          onTap: () {},
                        ),
                        buildContactOption(
                          icon: Icons.chat,
                          title: 'Live Chat',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSupportSection({required String title, required Widget content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  content,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFAQsList() {
    return Column(
      children: faqs.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, String> faq = entry.value;
        return ExpansionTile(
          onExpansionChanged: (expanded) {
            setState(() {
              _expandedFAQ[index] = expanded;
            });
          },
          title: Text(
            faq['question']!,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          iconColor: Colors.white,
          collapsedIconColor: Colors.white70,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                faq['answer']!,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget buildGuideTile(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: const Icon(Icons.arrow_forward, color: Colors.white70),
      onTap: onTap,
    );
  }

  Widget buildContactOption(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: const Icon(Icons.arrow_forward, color: Colors.white70),
      onTap: onTap,
    );
  }
}
