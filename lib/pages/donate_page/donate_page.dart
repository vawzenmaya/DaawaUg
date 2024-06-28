import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Needed for Clipboard

class DonatePage extends StatefulWidget {
  // ignore: use_super_parameters
  const DonatePage({Key? key}) : super(key: key);

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  bool _isSuluhuExpanded = false;
  bool _isMansorExpanded = false;

  // Constants for Airtel and MTN labels
  static const String airtelLabel = "Airtel:";
  static const String mtnLabel = "MTN:";
  static const String bankLabel = "Bank Acc:";

  // Phone numbers
  static const String airtelNumberSuluhu = "0755788381";
  static const String mtnNumberSuluhu = "0762540123";
  static const String bankSuluhu = "2535468903";
  static const String airtelNumberMansor = "0755788381";
  static const String mtnNumberMansor = "0787018472";
  static const String bankMansor = "1028377589";

  // Function to copy a given text to clipboard
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard: $text'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Donate Now",
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage("assets/suluhu.jpg"),
                      radius: 25,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Suluhu Daawa",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(_isSuluhuExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right),
                      onPressed: () {
                        setState(() {
                          _isSuluhuExpanded = !_isSuluhuExpanded;
                        });
                      },
                    ),
                  ],
                ),
                if (_isSuluhuExpanded)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "$airtelLabel $airtelNumberSuluhu",
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                _copyToClipboard(airtelNumberSuluhu);
                              },
                              child: const Text('Copy Airtel'),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "$mtnLabel $mtnNumberSuluhu",
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                _copyToClipboard(mtnNumberSuluhu);
                              },
                              child: const Text('Copy MTN'),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "$bankLabel $bankSuluhu",
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                _copyToClipboard(bankSuluhu);
                              },
                              child: const Text('Copy Bank Acc'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage("assets/kasule.jpg"),
                      radius: 25,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Mansor",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(_isMansorExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right),
                      onPressed: () {
                        setState(() {
                          _isMansorExpanded = !_isMansorExpanded;
                        });
                      },
                    ),
                  ],
                ),
                if (_isMansorExpanded)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "$airtelLabel $airtelNumberMansor",
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                _copyToClipboard(airtelNumberMansor);
                              },
                              child: const Text('Copy Airtel'),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "$mtnLabel $mtnNumberMansor",
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                _copyToClipboard(mtnNumberMansor);
                              },
                              child: const Text('Copy MTN'),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "$bankLabel $bankMansor",
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                _copyToClipboard(bankMansor);
                              },
                              child: const Text('Copy MTN'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
