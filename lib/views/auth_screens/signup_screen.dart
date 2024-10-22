import 'package:customerapp/constant/constant.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../constant/show_dialog.dart';
import '../../controllers/signup_controller.dart';
import '../../utils/themes/button.dart';
import '../../utils/themes/contant_colors.dart';
import '../../utils/themes/textfield_theme.dart';
import 'login_screen.dart';

class SignUpScreen extends StatelessWidget {

  SignUpScreen({super.key});

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.background,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(loginBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "sign_up".tr.toUpperCase(),
                            style: const TextStyle(letterSpacing: 0.60, fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                              width: 80,
                              child: Divider(
                                color: ConstantColors.blue1,
                                thickness: 3,
                              )),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFieldTheme.boxBuildTextField(
                                  hintText: 'Name'.tr,
                                  controller: controller.nameController,
                                  textInputType: TextInputType.text,
                                  maxLength: 22,
                                  validators: (String? value) {
                                    if (value!.isNotEmpty) {
                                      return null;
                                    } else {
                                      return 'required'.tr;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ConstantColors.textFieldBoarderColor,
                                  ),
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(12))),
                              padding: const EdgeInsets.only(left: 10),
                              child: InternationalPhoneNumberInput(
                                onInputChanged: (PhoneNumber number) {
                                  controller.phoneNumber.value =
                                      number.phoneNumber.toString();
                                },
                                onInputValidated: (bool value) =>
                                controller.isPhoneValid.value = value,
                                ignoreBlank: true,
                                autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                                initialValue: PhoneNumber(isoCode: 'VN'),
                                inputDecoration: InputDecoration(
                                  hintText: 'phone number'.tr,
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                selectorConfig: const SelectorConfig(
                                    selectorType: PhoneInputSelectorType.DIALOG),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: TextFieldTheme.boxBuildTextField(
                              hintText: 'email'.tr,
                              controller: controller.emailController,
                              textInputType: TextInputType.emailAddress,
                              validators: (String? value) {
                                bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(value!);
                                if (!emailValid) {
                                  return 'email not valid'.tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Obx(() => TextFieldTheme.boxBuildTextField(
                                hintText: 'password'.tr,
                                controller: controller.passwordController,
                                textInputType: TextInputType.text,
                                obscureText: controller.isObscure.value,
                                validators: (String? value) {
                                  if (value!.length >= 6) {
                                    return null;
                                  } else {
                                    return 'Password required at least 6 characters'.tr;
                                  }
                                },
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isObscure.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    size: 20
                                  ),
                                  onPressed: () {
                                    controller.isObscure.value =
                                    !controller.isObscure.value;
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Obx( () =>TextFieldTheme.boxBuildTextField(
                                hintText: 'confirm_password'.tr,
                                controller: controller.conformPasswordController,
                                textInputType: TextInputType.text,
                                obscureText: controller.isObscure.value,
                                validators: (String? value) {
                                  if (controller.passwordController.value.text != value) {
                                    return 'Confirm password is invalid'.tr;
                                  } else {
                                    return null;
                                  }
                                },
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isObscure.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    size: 20
                                  ),
                                  onPressed: () {
                                    controller.isObscure.value =
                                    !controller.isObscure.value;
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: ButtonThem.buildButton(
                                context,
                                title: 'sign_up'.tr,
                                btnHeight: 45,
                                btnColor: ConstantColors.primary,
                                txtColor: Colors.white,
                                onPress: () async {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    Map<String, String> bodyParams = {
                                      'name': controller.nameController.text.trim(),
                                      'email': controller.emailController.text.trim(),
                                      'password': controller.passwordController.text.trim(),
                                      'mobile': controller.phoneNumber.value.trim(),
                                      'user_type': 'customer',
                                    };
                                    await controller.signUp(bodyParams).then((value) {
                                      if (value != null) {
                                        if (value.status == true) {
                                          controller.clearData();
                                          Get.to(() => LoginScreen());
                                        } else {
                                          ShowDialog.showToast(value.message);
                                        }
                                      }
                                    });
                                  }
                                },
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.black,
                        ),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(loginBackground),
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
                    text: 'Already have an account?'.tr,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                      Get.offAll(LoginScreen(),
                            duration: const Duration(milliseconds: 400),
                            transition: Transition.rightToLeft);
                      },
                  ),
                  const TextSpan(
                    text: ' \u200B\u200B\u200B',
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                  TextSpan(
                    text: 'login'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold, color: ConstantColors.primary),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.offAll(LoginScreen(),
                            duration: const Duration(milliseconds: 400), //duration of transitions, default 1 sec
                            transition: Transition.rightToLeft); //transition effect);
                      },
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
