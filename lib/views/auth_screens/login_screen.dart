import 'package:customerapp/views/auth_screens/signup_screen.dart';
import 'package:customerapp/views/navigation_screen/navigation_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/constant.dart';
import '../../controllers/login_controller.dart';
import '../../utils/themes/button.dart';
import '../../utils/themes/contant_colors.dart';
import '../../utils/themes/textfield_theme.dart';
import 'forgotpassword_screen.dart';
import 'mobilenumber_screen.dart';

class LoginScreen extends StatelessWidget {

  LoginScreen({super.key});

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  static final _phoneController = TextEditingController();
  static final _passwordController = TextEditingController();
  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ConstantColors.background,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(login_background),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "login_with_email".tr.toUpperCase(),
                      style: const TextStyle(letterSpacing: 0.60, fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                        width: 100,
                        child: Divider(
                          color: ConstantColors.blue1,
                          thickness: 3,
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Form(
                        key: _loginFormKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFieldTheme.boxBuildTextField(
                              hintText: 'Email'.tr,
                              controller: _phoneController,
                              textInputType: TextInputType.emailAddress,
                              contentPadding: EdgeInsets.zero,
                              prefixIcon: Icon(Icons.email),
                              validators: (String? value) {
                                if (value!.isNotEmpty) {
                                  return null;
                                } else {
                                  return 'required'.tr;
                                }
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: TextFieldTheme.boxBuildTextField(
                                hintText: 'password'.tr,
                                controller: _passwordController,
                                textInputType: TextInputType.text,
                                obscureText: false,
                                contentPadding: EdgeInsets.zero,
                                prefixIcon: Icon(Icons.lock_outline),
                                validators: (String? value) {
                                  if (value!.isNotEmpty) {
                                    return null;
                                  } else {
                                    return 'required'.tr;
                                  }
                                },
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: ButtonThem.buildButton(
                                  context,
                                  title: 'login'.tr,
                                  btnHeight: 50,
                                  btnColor: ConstantColors.primary,
                                  txtColor: Colors.white,
                                  onPress: () async {
                                    /*
                                    FocusScope.of(context).unfocus();
                                    if (_loginFormKey.currentState!.validate()) {
                                      Map<String, String> bodyParams = {
                                        'email': _phoneController.text.trim(),
                                        'mdp': _passwordController.text,
                                        'user_cat': "customer",
                                      };
                                      await controller.loginAPI(bodyParams).then((value) {
                                        if (value != null) {
                                          if (value.success == "Success") {
                                            Preferences.setInt(Preferences.userId, value.data!.id!);
                                            Preferences.setString(Preferences.user, jsonEncode(value));
                                            _phoneController.clear();
                                            _passwordController.clear();
                                              Preferences.setBoolean(Preferences.isLogin, true);
                                              Get.offAll(HomeScreen(),
                                                  duration: const Duration(milliseconds: 400),
                                                  //duration of transitions, default 1 sec
                                                  transition: Transition.rightToLeft);
                                          } else {
                                            ShowDialog.showToast(value.error);
                                          }
                                        }
                                      });
                                    }

                                     */
                                    Get.off(()=> NavigationPage(),
                                        duration: const Duration(milliseconds: 400), //duration of transitions, default 1 sec
                                    transition: Transition.rightToLeft);
                                  },
                                )),
                            Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: ButtonThem.buildBorderButton(
                                  context,
                                  title: "login_with_phone_number".tr,
                                  btnHeight: 50,
                                  btnColor: Colors.white,
                                  txtColor: ConstantColors.primary,
                                  onPress: () {
                                    FocusScope.of(context).unfocus();
                                    Get.to(() => (MobileNumberScreen(isLogin: true)),
                                        duration: const Duration(milliseconds: 400), //duration of transitions, default 1 sec
                                        transition: Transition.rightToLeft);
                                  },
                                  btnBorderColor: ConstantColors.primary,
                                )),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => (ForgotPasswordScreen()),
                                    duration: const Duration(milliseconds: 400), //duration of transitions, default 1 sec
                                    transition: Transition.rightToLeft);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Center(
                                  child: Text(
                                    "forgot".tr,
                                    style: TextStyle(color: ConstantColors.primary, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(login_background),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Don’t have an account yet?'.tr,
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(() => (MobileNumberScreen(isLogin: false)),
                              duration: const Duration(milliseconds: 400), //duration of transitions, default 1 sec
                              transition: Transition.rightToLeft); //transition effect);
                        },
                    ),
                    TextSpan(
                      text: ' \u200B\u200B\u200B',
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    TextSpan(
                      text: 'sign_up'.tr,
                      style: TextStyle(fontWeight: FontWeight.bold, color: ConstantColors.primary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(() => (
                              SignUpScreen(phoneNumber: '000',
                              )),
                              duration: const Duration(milliseconds: 400), //duration of transitions, default 1 sec
                              transition: Transition.rightToLeft); //transition effect);
                        },
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
