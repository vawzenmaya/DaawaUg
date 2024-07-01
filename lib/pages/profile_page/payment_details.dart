import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok/api_config.dart';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails({super.key});

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _airtelMerchantCodeController =
      TextEditingController();
  final TextEditingController _mtnMerchantCodeController =
      TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  String _currency = 'Not Specified';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userid = prefs.getString('userID');
      if (userid != null) {
        final response = await http.post(
          Uri.parse(ApiConfig.fetchPaymentDetailsUrl),
          body: {'userid': userid},
        );

        if (response.statusCode == 200) {
          final userData = json.decode(response.body);
          setState(() {
            _airtelMerchantCodeController.text = userData['airtel'];
            _mtnMerchantCodeController.text = userData['mtn'];
            _bankNameController.text = userData['bankname'];
            _currency = userData['currency'];
            _accountNumberController.text = userData['accountnumber'];
            _accountNameController.text = userData['accountname'];
          });
        } else {
          Get.snackbar(
            'Error',
            'Failed to fetch your data',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Network Error',
        'Check your internet connection',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> _saveChanges() async {
    try {
      if (_formKey.currentState!.validate()) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userid = prefs.getString('userID');
        if (userid != null) {
          final response = await http.post(
            Uri.parse(ApiConfig.updatePaymentDetailsUrl),
            body: {
              'userid': userid,
              'airtel': _airtelMerchantCodeController.text,
              'mtn': _mtnMerchantCodeController.text,
              'bankname': _bankNameController.text,
              'currency': _currency,
              'accountnumber': _accountNumberController.text,
              'accountname': _accountNameController.text,
            },
          );

          final responseData = json.decode(response.body);
          if (response.statusCode == 200 &&
              responseData['status'] == 'success') {
            Get.back();
            Get.snackbar('Success', 'Payments updated successfully',
                snackPosition: SnackPosition.TOP, backgroundColor: Colors.grey);
          } else {
            if (responseData['status'] == 'error') {
              Get.snackbar(
                'Sorry',
                responseData['message'] ?? 'Failed to update payments',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP,
              );
            } else {
              Get.snackbar(
                'Error',
                'Failed to update payments',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP,
              );
            }
          }
        }
      }
    } catch (e) {
      Get.snackbar(
        'Network Error',
        'Check your internet connection',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Payment Details",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 35,
                          width: 50,
                          child: Image.asset("assets/images/MTNandAirtel.jpg"),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Mobile Money",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _airtelMerchantCodeController,
                      keyboardType: TextInputType.number,
                      maxLength: 25,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                      decoration: const InputDecoration(
                        labelText: 'Enter Airtel Merchant ID',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 2.5),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _mtnMerchantCodeController,
                      keyboardType: TextInputType.number,
                      maxLength: 25,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                      decoration: const InputDecoration(
                        labelText: 'Enter MTN Merchant ID',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 2.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        SizedBox(
                          height: 35,
                          width: 50,
                          child: Image.asset("assets/images/bankaccount.png"),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Bank Account",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _bankNameController,
                      maxLength: 25,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                      decoration: const InputDecoration(
                        labelText: 'Enter Bank Name',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 2.5),
                        ),
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: _currency,
                      items: ['Not Specified', 'UGX', 'USD', 'EUR', 'GBP']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _currency = newValue!;
                        });
                      },
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                      decoration: const InputDecoration(
                        labelText: 'Select Currency',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 2.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _accountNumberController,
                      keyboardType: TextInputType.number,
                      maxLength: 25,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                      decoration: const InputDecoration(
                        labelText: 'Enter Account Number',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 2.5),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _accountNameController,
                      maxLength: 50,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                      decoration: const InputDecoration(
                        labelText: 'Enter Account Name',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 2.5),
                        ),
                      ),
                      onChanged: (value) {
                        _accountNameController.value = TextEditingValue(
                          text: value.toUpperCase(),
                          selection: _accountNameController.selection,
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
