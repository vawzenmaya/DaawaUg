import 'package:flutter/material.dart';

class PrivacyPoliciesPage extends StatelessWidget {
  const PrivacyPoliciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy for DaawaTok',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Last Updated: 05. Sept. 2024',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Welcome to DaawaTok! This Privacy Policy describes how Develop with Effect ("we", "our", "us") collects, uses, and shares information about you when you use our mobile application, DaawaTok ("the App").',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '1. Information We Collect',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We collect the following types of information:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'a. Personal Information:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'When you register for an account or use certain features of the App, we may collect personal information such as:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '- Name\n- Email address\n- Phone number\n- Date of birth\n- Profile picture\n- User-generated content (e.g., videos, comments)',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'b. Automatically Collected Information:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'We may also collect information automatically when you use the App, including:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '- Device information (e.g., IP address, device ID, operating system)\n- Usage data (e.g., how you interact with the App, features used)\n- Location data (with your permission)\n- Cookies and similar tracking technologies',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '2. How We Use Your Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We use your information for the following purposes:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '- To provide and improve the App\n- To personalize your experience\n- To communicate with you about your account and the App\n- To send you promotional offers and updates (with your consent)\n- To analyze usage patterns and improve the App\'s performance\n- To ensure compliance with our Terms of Service',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '3. How We Share Your Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We may share your information with third parties in the following situations:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '- With your consent: We may share your information with third parties when you give us your explicit consent.\n- Service providers: We may share your information with third-party service providers who help us operate the App (e.g., hosting, analytics).\n- Legal requirements: We may disclose your information if required by law or in response to legal requests (e.g., subpoenas).\n- Business transfers: If we are involved in a merger, acquisition, or sale of assets, your information may be transferred as part of that transaction.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '4. Data Security',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We take reasonable measures to protect your information from unauthorized access, loss, misuse, or alteration. However, no method of transmission over the internet or electronic storage is 100% secure, and we cannot guarantee absolute security.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '5. Your Choices',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'You have the following rights regarding your information:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '- Access and correction: You can access and update your personal information through your account settings.\n- Data deletion: You can request the deletion of your account and personal information by contacting us at [Insert Contact Email].\n- Opt-out: You can opt-out of receiving promotional communications by following the unsubscribe instructions in the messages or by adjusting your account settings.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '6. Children\'s Privacy',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'DaawaTok is not intended for use by children under the age of 13. If we become aware that we have collected personal information from children under 13, we will take steps to delete such information promptly.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '7. International Data Transfers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Your information may be transferred to and processed in countries outside of your own, including countries that may not have the same data protection laws as your country of residence. By using the App, you consent to the transfer of your information to these countries.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '8. Changes to This Privacy Policy',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We may update this Privacy Policy from time to time. If we make significant changes, we will notify you by posting the new policy on the App and updating the "Effective Date" at the top of this document. Your continued use of the App after any changes signifies your acceptance of the updated Privacy Policy.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '9. Contact Us',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'If you have any questions or concerns about this Privacy Policy or your data, please contact us at:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Develop with Effect\nEmail: daawatokug@gmail.com',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
