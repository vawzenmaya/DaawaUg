import 'dart:convert';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:toktok/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class User {
  final String username;
  final String fullNames;
  final String profilePic;
  final String biography;
  final String role;
  final String airtel;
  final String mtn;
  final String bankName;
  final String currency;
  final String accountNumber;
  final String accountName;

  User({
    required this.username,
    required this.fullNames,
    required this.profilePic,
    required this.biography,
    required this.role,
    required this.airtel,
    required this.mtn,
    required this.bankName,
    required this.currency,
    required this.accountNumber,
    required this.accountName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      fullNames: json['fullNames'],
      profilePic: json['profilePic'],
      biography: json['biography'],
      role: json['role'],
      airtel: json['airtel'] ?? '',
      mtn: json['mtn'] ?? '',
      bankName: json['bankname'] ?? '',
      currency: json['currency'] ?? '',
      accountNumber: json['accountnumber'] ?? '',
      accountName: json['accountname'] ?? '',
    );
  }
}

class DonatePage extends StatefulWidget {
  const DonatePage({super.key});

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  List<dynamic> users = [];
  List<dynamic> filteredUsers = [];
  TextEditingController searchController = TextEditingController();
  int _expandedIndex = -1;

  Future<void> fetchChannels() async {
    final response =
        await http.get(Uri.parse(ApiConfig.fetchChannelsforDonationUrl));

    if (response.statusCode == 200) {
      setState(() {
        users = (json.decode(response.body) as List)
            .map((data) => User.fromJson(data))
            .toList();
        filteredUsers = users;
      });
    } else {
      throw Exception('Failed to load channels');
    }
  }

  void _filterUsers() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredUsers = users.where((user) {
        return user.username.toLowerCase().contains(query) ||
            user.fullNames.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchChannels();
    searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterUsers);
    searchController.dispose();
    super.dispose();
  }

  void _toggleExpansion(int index) {
    setState(() {
      if (_expandedIndex == index) {
        _expandedIndex = -1;
      } else {
        _expandedIndex = index;
      }
    });
  }

  void _launchDialer(String ussdCode) async {
    final Uri dialUri = Uri(scheme: 'tel', path: ussdCode);

    if (await canLaunchUrl(dialUri)) {
      await launchUrl(dialUri);
    } else {
      throw 'Could not launch $ussdCode';
    }
  }

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(
          Icons.volunteer_activism,
          color: Colors.white,
        ),
        title: const Text(
          "Donate to a channel",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search for a channel',
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 25,
                ),
                labelStyle: TextStyle(color: Colors.grey),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent, width: 2.5),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredUsers.isEmpty
                ? Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/loading.json',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          const Text(
                            "No channels found",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];

                      return GestureDetector(
                        onTap: () {
                          _toggleExpansion(index);
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (ApiConfig.emptyProfilePicUrl ==
                                        user.profilePic)
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: const BoxDecoration(
                                          color: Colors.grey,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const ClipOval(
                                            child: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 50,
                                        )),
                                      )
                                    else
                                      Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          color: Colors.grey,
                                          image: DecorationImage(
                                            image:
                                                NetworkImage(user.profilePic),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (user.fullNames == "")
                                          const Text(
                                            "No Channel Name",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          )
                                        else
                                          Row(
                                            children: [
                                              Text(
                                                user.fullNames,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(width: 3),
                                              if (user.role == 'admin')
                                                const Icon(
                                                  Icons.verified,
                                                  color: Colors.yellow,
                                                  size: 15,
                                                )
                                              else if (user.role == 'channel')
                                                const Icon(
                                                  Icons.verified,
                                                  color: Colors.blue,
                                                  size: 15,
                                                )
                                            ],
                                          ),
                                        Text(
                                          "@${user.username}",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    if (_expandedIndex == index)
                                      const Icon(Icons.expand_less,
                                          color: Colors.white)
                                    else
                                      const Icon(Icons.expand_more,
                                          color: Colors.white)
                                  ],
                                ),
                                if (_expandedIndex == index)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      const Divider(),
                                      const Text(
                                        "About this channel",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 17),
                                      ),
                                      if (user.biography.isNotEmpty)
                                        ExpandableText(
                                          user.biography,
                                          style: const TextStyle(
                                              color: Colors.white),
                                          expandText: 'More',
                                          collapseText: 'Less',
                                          expandOnTextTap: true,
                                          collapseOnTextTap: true,
                                          maxLines: 2,
                                          linkColor: Colors.blueGrey,
                                        )
                                      else
                                        const Text(
                                          'No About',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      if (user.airtel.isNotEmpty ||
                                          user.mtn.isNotEmpty)
                                        const Divider(),
                                      if (user.airtel.isNotEmpty ||
                                          user.mtn.isNotEmpty)
                                        const Text(
                                          "Use Mobile Money",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 17),
                                        ),
                                      if (user.airtel.isNotEmpty ||
                                          user.mtn.isNotEmpty)
                                        const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          if (user.airtel.isNotEmpty)
                                            Column(
                                              children: [
                                                const Text(
                                                  "AIRTEL MONEY",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 100,
                                                  height: 50,
                                                  child: Image.asset(
                                                      "assets/images/airtel.webp"),
                                                ),
                                                const Text(
                                                  "1.\tDail the RED\t\t\t\t\t\t\t\t\t\n\t\t\t\tbutton below",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                const Text(
                                                  "2.\tEnter Amount:\t\t\t\t\t\t",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                const Text(
                                                  "e.g 5000",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const Text(
                                                  "3.\tEnter Reference:\t\t\t",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                const Text(
                                                  "e.g Donation",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const Row(
                                                  children: [
                                                    Text(
                                                      "4.\tEnter PIN: ",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      "e.g ****",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _launchDialer(
                                                        "*185*9*${user.airtel}#");
                                                  },
                                                  child: const Card(
                                                    color: Colors.red,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text(
                                                        "Use Airtel Money",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          if (user.mtn.isNotEmpty)
                                            Column(
                                              children: [
                                                const Text(
                                                  "MOBILE MONEY",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 100,
                                                  height: 50,
                                                  child: Image.asset(
                                                      "assets/images/mtn.jpeg"),
                                                ),
                                                const Text(
                                                  "1.\tDail the YELLOW\t\t\t\t\t\n\t\t\t\tbutton below",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                const Text(
                                                  "2.\tEnter Reason:\t\t\t\t\t\t\t\t\t\t",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                const Text(
                                                  "e.g Donation",
                                                  style: TextStyle(
                                                      color: Colors.yellow,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const Text(
                                                  "3.\tEnter Amount:\t\t\t\t\t\t\t\t\t",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                const Text(
                                                  "e.g 5000",
                                                  style: TextStyle(
                                                      color: Colors.yellow,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const Row(
                                                  children: [
                                                    Text(
                                                      "4. Enter PIN: ",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      "e.g *****",
                                                      style: TextStyle(
                                                          color: Colors.yellow,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _launchDialer(
                                                        "*165*3*${user.mtn}#");
                                                  },
                                                  child: const Card(
                                                    color: Colors.yellow,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text(
                                                        "Use Mobile Money",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                        ],
                                      ),
                                      if (user.bankName.isNotEmpty &&
                                          user.accountNumber.isNotEmpty &&
                                          user.accountName.isNotEmpty)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Divider(),
                                            const Text(
                                              "Use Bank Account",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Bank Name: ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  user.bankName,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Currency: ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                if (user.currency.isNotEmpty)
                                                  Text(
                                                    user.currency,
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  )
                                                else
                                                  const Text(
                                                    "Not Specified",
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Account Number: ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  user.accountNumber,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                const Spacer(),
                                                GestureDetector(
                                                  onTap: () {
                                                    _copyToClipboard(
                                                        user.accountNumber);
                                                  },
                                                  child: const Card(
                                                    color: Colors.white,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text(
                                                        "Copy",
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Account Name: ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  user.accountName,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                const Spacer(),
                                                GestureDetector(
                                                  onTap: () {
                                                    _copyToClipboard(
                                                        user.accountName);
                                                  },
                                                  child: const Card(
                                                    color: Colors.white,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text(
                                                        "Copy",
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        )
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
