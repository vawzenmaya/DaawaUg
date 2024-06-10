import 'package:flutter/material.dart';
import 'package:toktok/widgets/input_text_widget.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DonatePageState createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  TextEditingController donationTextEditingController = TextEditingController();
  bool isGiveOnceActive = true;
  int selectedAmount = 50;
  final List<int> giveOnceAmounts = [1000, 500, 250, 100, 50, 20];
  final List<int> giveMonthlyAmounts = [200, 100, 50, 30, 20, 10];

  List<int> get donationAmounts => isGiveOnceActive ? giveOnceAmounts : giveMonthlyAmounts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Donate Now',
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Give Once
              Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isGiveOnceActive = true;
                      selectedAmount = giveOnceAmounts[4]; // Default to 50
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isGiveOnceActive ? Colors.orange : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: const TextStyle(fontSize: 18.0),
                  ),
                  child: Text(
                    'GIVE ONCE',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: isGiveOnceActive ? Colors.white : Colors.orange,
                    ),
                  ),
                ),
              ),
        
              // Give Monthly
              Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isGiveOnceActive = false;
                      selectedAmount = giveMonthlyAmounts[4]; // Default to 20
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isGiveOnceActive ? Colors.white : Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: const TextStyle(fontSize: 18.0),
                  ),
                  child: Text(
                    'GIVE MONTHLY',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: isGiveOnceActive ? Colors.green : Colors.white,
                    ),
                  ),
                ),
              ),
        
              // Donation Amount Buttons
              GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              children: donationAmounts.map((amount) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedAmount = amount;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedAmount == amount
                        ? (isGiveOnceActive ? Colors.orange : Colors.green)
                        : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                    textStyle: const TextStyle(fontSize: 16.0),
                  ),
                  child: Text(
                    '\$$amount',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: selectedAmount == amount
                          ? Colors.white
                          : (isGiveOnceActive ? Colors.orange : Colors.green),
                    ),
                  ),
                );
              }).toList(),
            ),
        
        
              const SizedBox(
                height: 10,
              ),
        
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(
                  textEditingController: donationTextEditingController,
                  lableString: "Enter Amount",
                  iconData: Icons.money_outlined,
                  isObscure: false,
                ),
              ),
        
              // Description
              Text(
                'Thank you for your Donation',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
              ),
        
              // Donate Button
              Container(
                margin: const EdgeInsets.only(top: 32.0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isGiveOnceActive ? Colors.orange : Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: const TextStyle(fontSize: 20.0),
                  ),
                  child: Text(
                    'DONATE \$$selectedAmount ${isGiveOnceActive ? 'TODAY' : 'MONTHLY'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900),
                  ),
                ),
              ),
        
              // Security Notice
              Container(
                margin: const EdgeInsets.only(top: 16.0),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, size: 16.0),
                    SizedBox(width: 4.0),
                    Text('100% Safe & Secure', style: TextStyle(fontSize: 12.0)),
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
