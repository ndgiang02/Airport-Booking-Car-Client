import 'package:customerapp/utils/themes/custom_dialog_box.dart';
import 'package:customerapp/utils/themes/textfield_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constant/constant.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'support'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFieldTheme.buildListTile(
                title: 'phone'.tr,
                icon: LineAwesomeIcons.phone_alt_solid,
                onPress: () {
                  CustomAlert.showCustomDialog(
                      context: context,
                      title: 'Hỗ trợ qua điện thoại',
                      content: 'Bạn có muốn gọi 113 không?',
                      callButtonText: 'Call',
                      onCallPressed: () {
                        const phoneNumber = "113";
                        launchUrl(Uri.parse("tel://$phoneNumber"));
                      });
                }),
            TextFieldTheme.buildListTile(
              title: 'email'.tr,
              icon: LineAwesomeIcons.mail_bulk_solid,
              onPress: () async {
                final String email = Constant.contactUsEmail;
                const String subject = 'Contact Us';
                const String body = 'Hello, I would like to...';

                final Uri emailUri = Uri(
                  scheme: 'mailto',
                  path: email,
                  query: Uri.encodeQueryComponent('subject=$subject&body=$body'),
                );

                if (await canLaunchUrl(emailUri)) {
                  await launchUrl(emailUri);
                } else {
                  throw 'Could not launch $emailUri';
                }
              },
            ),
            TextFieldTheme.buildListTile(
                title: 'facebook'.tr,
                icon: LineAwesomeIcons.address_book_solid,
                onPress: () {}),
          ],
        ),
      ),
    );
  }
}
