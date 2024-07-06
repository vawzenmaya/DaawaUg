import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:toktok/api_config.dart';
import 'package:toktok/pages/inbox_page/chat_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class ProfileDonation extends StatefulWidget {
  final String userId;
  final String username;
  final String fullNames;
  final String profilePic;
  final String role;

  const ProfileDonation({
    super.key,
    required this.userId,
    required this.username,
    required this.fullNames,
    required this.profilePic,
    required this.role,
  });
  @override
  State<ProfileDonation> createState() => _ProfileDonationState();
}

class _ProfileDonationState extends State<ProfileDonation> {
  String airtel = "";
  String mtn = "";
  String bankName = "";
  String currency = "";
  String accountNumber = "";
  String accountName = "";

  Future<void> fetchPaymentInfo() async {
    final response = await http.post(
      Uri.parse(ApiConfig.fetchPaymentInfomationUrl),
      body: {'userid': widget.userId},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        airtel = data['airtel'];
        mtn = data['mtn'];
        bankName = data['bankname'];
        currency = data['currency'];
        accountNumber = data['accountnumber'];
        accountName = data['accountname'];
      });
    } else {
      throw Exception('Failed to load payment info');
    }
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
  void initState() {
    super.initState();
    fetchPaymentInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (ApiConfig.emptyProfilePicUrl == widget.profilePic)
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: const ClipOval(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              )
            else
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.grey,
                    image: DecorationImage(
                      image: NetworkImage(widget.profilePic),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            const SizedBox(width: 10),
            Flexible(
              child: GestureDetector(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      if (widget.fullNames.isNotEmpty)
                        Flexible(
                          child: Text(
                            widget.fullNames,
                            style: const TextStyle(color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      else if (widget.fullNames.isEmpty &&
                          (widget.role == "admin" || widget.role == "channel"))
                        const Text(
                          "No Channel Name",
                          style: TextStyle(color: Colors.red),
                        )
                      else if (widget.fullNames.isEmpty &&
                          widget.role == "user")
                        const Text(
                          "No Profile Name",
                          style: TextStyle(color: Colors.red),
                        ),
                      const SizedBox(width: 3),
                      if (widget.fullNames.isNotEmpty && widget.role == "admin")
                        const Icon(Icons.verified,
                            color: Colors.yellow, size: 15)
                      else if (widget.fullNames.isNotEmpty &&
                          widget.role == "channel")
                        const Icon(Icons.verified,
                            color: Colors.blue, size: 15),
                      const SizedBox(height: 3),
                    ]),
                    Text(
                      "@${widget.username}",
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(ChatPage(
                    userId: widget.userId,
                    username: widget.username,
                    fullNames: widget.fullNames,
                    profilePic: widget.profilePic,
                    role: widget.role));
              },
              icon: const Icon(
                Icons.chat,
                color: Colors.black,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (airtel != "" ||
                mtn != "" ||
                (bankName != "" && accountNumber != "" && accountName != ""))
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (airtel != "" || mtn != "")
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 25,
                                    width: 50,
                                    child:
                                        Image.asset("assets/images/mobile.png"),
                                  ),
                                  const SizedBox(width: 10),
                                  if (airtel != "" && mtn != "")
                                    const Text(
                                      "Donate with Airtel or MTN",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    )
                                  else if (airtel != "" && mtn == "")
                                    const Text(
                                      "Donate with Airtel Money",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    )
                                  else if (airtel == "" && mtn != "")
                                    const Text(
                                      "Donate with Mobile Money",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                ],
                              ),
                              if (airtel != "") const SizedBox(height: 10),
                              if (airtel != "")
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 30,
                                          width: 50,
                                          child: Image.asset(
                                              "assets/images/airtel.webp"),
                                        ),
                                        const SizedBox(width: 5),
                                        const Text(
                                          "How to donate with Airtel Money",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "1. Dail the ",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        Text(
                                          "RED",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          " below.",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "2. Enter Amount: ",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        Text(
                                          "e.g 5000",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "3. Enter Reference: ",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        Text(
                                          "e.g Donation",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "4. Enter your 4 digits airtel money PIN: ",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        Text(
                                          "e.g ****",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              _launchDialer("*185*9*$airtel#");
                                            },
                                            child: const Card(
                                              color: Colors.red,
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Use Airtel Money",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              if (mtn != "") const SizedBox(height: 10),
                              if (mtn != "")
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 30,
                                          width: 50,
                                          child: Image.asset(
                                              "assets/images/mtn.jpeg"),
                                        ),
                                        const SizedBox(width: 5),
                                        const Text(
                                          "How to donate with Mobile Money",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "1. Dail the ",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        Text(
                                          "YELLOW",
                                          style: TextStyle(
                                              color: Colors.amber,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          " below.",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "2. Enter Reason: ",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        Text(
                                          "e.g Donation",
                                          style: TextStyle(
                                              color: Colors.amber,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "3. Enter Amount: ",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        Text(
                                          "e.g 5000",
                                          style: TextStyle(
                                              color: Colors.amber,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "4. Enter your 5 digits mobile money PIN: ",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        Text(
                                          "e.g *****",
                                          style: TextStyle(
                                              color: Colors.amber,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              _launchDialer("*165*3*$mtn#");
                                            },
                                            child: const Card(
                                              color: Colors.amber,
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Use Mobile Money",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    if ((airtel != "" || mtn != "") &&
                        bankName != "" &&
                        accountNumber != "" &&
                        accountName != "")
                      const SizedBox(height: 5),
                    if ((airtel != "" || mtn != "") &&
                        bankName != "" &&
                        accountNumber != "" &&
                        accountName != "")
                      const Divider(),
                    if ((airtel != "" || mtn != "") &&
                        bankName != "" &&
                        accountNumber != "" &&
                        accountName != "")
                      const SizedBox(height: 5),
                    if (bankName != "" &&
                        accountNumber != "" &&
                        accountName != "")
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 35,
                                    width: 50,
                                    child: Image.asset(
                                        "assets/images/bankaccount.png"),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "Donate with Bank Account",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.account_balance,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    "Bank Name:  ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    bankName,
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.attach_money,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    "Currency:  ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  if (currency == "Not Specified")
                                    const Text(
                                      "Not Specified",
                                      style: TextStyle(color: Colors.amber),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  else
                                    Text(
                                      currency,
                                      style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.confirmation_number,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    "Account Number:  ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    accountNumber,
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      _copyToClipboard(accountNumber);
                                    },
                                    child: const Card(
                                      color: Colors.blue,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(8, 6, 8, 6),
                                        child: Text(
                                          "Copy",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    "Account Name:  ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    accountName,
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      _copyToClipboard(accountName);
                                    },
                                    child: const Card(
                                      color: Colors.blue,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(8, 6, 8, 6),
                                        child: Text(
                                          "Copy",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          )
                        ],
                      )
                  ],
                ),
              )
            else
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "@${widget.username} has no any donation payment method set.\nPlease contact the channel.",
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ))
          ],
        ),
      ),
    );
  }
}
