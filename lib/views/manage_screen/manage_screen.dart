import 'package:customerapp/utils/themes/text_style.dart';
import 'package:customerapp/views/introduction/introduction.dart';
import 'package:customerapp/views/manage_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../constant/constant.dart';
import '../../controllers/manage_controller.dart';
import '../../utils/preferences/preferences.dart';
import '../../utils/themes/contant_colors.dart';
import '../../utils/themes/custom_dialog_box.dart';
import '../../utils/themes/reponsive.dart';
import '../../utils/themes/textfield_theme.dart';
import '../auth_screens/login_screen.dart';
import '../localization_screens/localization_screen.dart';
import '../support_screens/support_screen.dart';
import '../termpolicy_screen/term_policy_screen.dart';

class ManageScreen extends StatelessWidget {
  ManageScreen({super.key});

  final ManageController controller = Get.put(ManageController());

  String? name =  Preferences.getString(Preferences.userName);
  String? email =  Preferences.getString(Preferences.userEmail);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'account'.tr,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      child: Center(
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image(image: AssetImage(meme)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () => Get.to(() => MyProfileScreen()),
                          child: ClipOval(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  ic_edit,
                                  color: ConstantColors.primary,
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  name!,
                  style: CustomTextStyles.header,
                ),
                Text(
                  email!,
                  style: CustomTextStyles.body,
                ),
                SizedBox(
                  height: 15,
                ),
                TextFieldTheme.buildListTile(
                  title: 'intro'.tr,
                  icon: LineAwesomeIcons.info_circle_solid,
                  onPress: () {
                    Get.to(() => IntroductionScreen());
                  },
                  endIcon: true,
                ),
                TextFieldTheme.buildListTile(
                  title: 'term_policy'.tr,
                  icon: LineAwesomeIcons.terminal_solid,
                  onPress: () {
                    Get.to(() => TermsOfServiceScreen());
                  },
                  endIcon: true,
                ),
                TextFieldTheme.buildListTile(
                  title: 'support'.tr,
                  icon: LineAwesomeIcons.hands_helping_solid,
                  onPress: () {
                    Get.to(() => SupportScreen());
                  },
                  endIcon: true,
                ),
                TextFieldTheme.buildListTile(
                  title: 'chang_language'.tr,
                  icon: LineAwesomeIcons.language_solid,
                  onPress: () async {
                    bool? languageChanged = await Get.to(
                      () => LocalizationScreen(),
                    );
                    if (languageChanged == true) {
                      controller.update();
                    }
                  },
                  endIcon: true,
                ),
                TextFieldTheme.buildListTile(
                  title: 'share'.tr,
                  icon: LineAwesomeIcons.share_square,
                  onPress: () {
                    Clipboard.setData(
                            ClipboardData(text: "https://yourapp.link"))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('copy'.tr)),
                      );
                    });
                  },
                  endIcon: true,
                ),
                Divider(
                  indent: Responsive.width(100, context) * 0.05,
                  endIndent: Responsive.width(100, context) * 0.05,
                ),
                TextFieldTheme.buildListTile(
                  title: 'sign_out'.tr,
                  icon: LineAwesomeIcons.sign_out_alt_solid,
                  onPress: () {
                    CustomAlert.showCustomDialog(
                        context: context,
                        title: 'sign_out'.tr,
                        content: 'are_want_to_logout'.tr,
                        callButtonText: 'sign_out'.tr,
                        onCallPressed: () {
                          Preferences.clearSharPreference();
                          Get.offAll(LoginScreen());
                        });
                  },
                  endIcon: false,
                ),
              ],
            ),
          ),
        ));
  }
}
