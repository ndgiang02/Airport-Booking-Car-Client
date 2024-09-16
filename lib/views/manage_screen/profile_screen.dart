import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/constant.dart';
import '../../constant/show_dialog.dart';
import '../../controllers/profile_controller.dart';
import '../../models/user_model.dart';
import '../../utils/preferences/preferences.dart';
import '../../utils/themes/button.dart';
import '../../utils/themes/contant_colors.dart';
import '../../utils/themes/custom_dialog_box.dart';
import '../../utils/themes/reponsive.dart';
import '../../utils/themes/textfield_theme.dart';
import '../auth_screens/login_screen.dart';

class MyProfileScreen extends StatelessWidget {
  MyProfileScreen({super.key});

  final GlobalKey<FormState> _passwordKey = GlobalKey();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetX<MyProfileController>(
        init: MyProfileController(),
        builder: (myProfileController) {
          return Scaffold(
            backgroundColor: Colors.grey[300],
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: Responsive.height(25, context),
                        width: Responsive.width(100, context),
                        decoration: BoxDecoration(
                            color: ConstantColors.primary,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(25.0),
                              bottomRight: Radius.circular(25.0),
                            )),
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
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: const EdgeInsets.only(top: 30),
                          height: 200,
                          width: 160,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    meme,
                                    fit: BoxFit.cover,
                                    height: 60,
                                    width: 60,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          buildShowDetails(
                            subtitle: myProfileController.name.toString(),
                            title: "Full Name",
                            iconData: Icons.person_outline,
                            isEditIcon: true,
                            onPress: () {
                              buildAlertChangeData(
                                context,
                                onSubmitBtn: () {
                                  if (nameController.text.isNotEmpty) {
                                    Map<String, String> bodyParams = {
                                      'id_user':
                                          Preferences.getInt(Preferences.userId)
                                              .toString(),
                                      'user_type':
                                          myProfileController.userType.value,
                                      'name': nameController.text,
                                    };
                                    myProfileController
                                        .updateName(bodyParams)
                                        .then((value) {
                                      if (value != null) {
                                        if (value["success"] == "success") {
                                          UserModel userModel =
                                              Constant.getUserData();
                                          userModel.data!.name =
                                              value['data']['name'];
                                          Preferences.setString(
                                              Preferences.user,
                                              jsonEncode(userModel.toJson()));
                                          myProfileController.getUsrData();
                                          ShowDialog.showToast(
                                              value['message']);
                                          Get.back();
                                        } else {
                                          ShowDialog.showToast(value['error']);
                                          Get.back();
                                        }
                                      }
                                    });
                                  } else {
                                    ShowDialog.showToast("Please Enter Name");
                                  }
                                },
                                controller: nameController,
                                title: "Full Name",
                                iconData: Icons.person_outline,
                                validators: (String? name) {
                                  return null;
                                },
                              );
                            },
                          ),
                          buildShowDetails(
                            subtitle: myProfileController.mobile.toString(),
                            title: 'phone'.tr,
                            iconData: Icons.phone,
                            isEditIcon: false,
                            onPress: () {},
                          ),
                          buildShowDetails(
                            subtitle: myProfileController.email.toString(),
                            title: "email".tr,
                            iconData: Icons.email_outlined,
                            isEditIcon: false,
                            onPress: () {},
                          ),
                          buildShowDetails(
                            title: "password".tr,
                            subtitle: "chang_password".tr,
                            iconData: Icons.lock_outline,
                            isEditIcon: true,
                            onPress: () {
                              buildAlertChangePassword(
                                context,
                                myProfileController: myProfileController,
                              );
                            },
                          ),
                          buildShowDetails(
                            title: 'delete'.tr,
                            subtitle: 'delete_account'.tr,
                            isEditIcon: false,
                            iconData: Icons.delete,
                            onPress: () async {
                              await CustomAlert.showCustomDialog(
                                  context: context,
                                  title: 'yes'.tr,
                                  content:
                                      'Are_you_sure_you_want_to_delete_account?'
                                          .tr,
                                  callButtonText: 'delete'.tr,
                                  onCallPressed: () {
                                    myProfileController
                                        .deleteAccount()
                                        .then((value) {
                                      if (value != null) {
                                        if (value["status"] == true) {
                                          ShowDialog.showToast(
                                              "Account Delete");
                                          Get.back();
                                          Preferences.clearSharPreference();
                                          Get.offAll(() => LoginScreen());
                                        }
                                      }
                                    });
                                  });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  buildShowDetails({
    required String title,
    required String subtitle,
    required bool isEditIcon,
    required IconData iconData,
    required Function()? onPress,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: ListTile(
          leading: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: ConstantColors.primary.withOpacity(0.08),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(iconData, size: 20, color: Colors.black),
                    )),
              ),
            ],
          ),
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          subtitle: Text(subtitle),
          onTap: onPress,
          trailing: Visibility(
            visible: isEditIcon,
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    ic_edit,
                    width: 20,
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildAlertChangeData(
    BuildContext context, {
    required String title,
    required TextEditingController controller,
    required IconData iconData,
    required String? Function(String?) validators,
    required Function() onSubmitBtn,
  }) {
    return Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: 20),
      radius: 6,
      title: "Change Information",
      titleStyle: const TextStyle(
        fontSize: 20,
      ),
      content: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldTheme.boxBuildTextField(
                hintText: title,
                controller: controller,
                validators: validators),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                ButtonThem.buildButton(context,
                    title: "Save",
                    btnColor: ConstantColors.primary,
                    txtColor: Colors.white,
                    onPress: onSubmitBtn,
                    btnHeight: 40,
                    btnWidthRatio: 0.3),
                const SizedBox(
                  width: 15,
                ),
                ButtonThem.buildButton(context,
                    title: "Cancel",
                    btnHeight: 40,
                    btnWidthRatio: 0.3,
                    btnColor: ConstantColors.blue1,
                    txtColor: Colors.black,
                    onPress: () => Get.back()),
              ],
            )
          ],
        ),
      ),
    );
  }

  buildAlertChangePassword(
    BuildContext context, {
    required MyProfileController myProfileController,
  }) {
    return Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: 20),
      radius: 6,
      title: "Change Password",
      titleStyle: const TextStyle(
        fontSize: 20,
      ),
      content: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _passwordKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldTheme.boxBuildTextField(
                hintText: "Current Password",
                obscureText: false,
                controller: currentPasswordController,
                validators: (valve) {
                  if (valve!.isNotEmpty) {
                    return null;
                  } else {
                    return "*required";
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFieldTheme.boxBuildTextField(
                hintText: "New Password",
                obscureText: false,
                controller: newPasswordController,
                validators: (valve) {
                  if (valve!.isNotEmpty) {
                    return null;
                  } else {
                    return "*required";
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFieldTheme.boxBuildTextField(
                hintText: "Confirm Password",
                obscureText: false,
                controller: confirmPasswordController,
                validators: (valve) {
                  if (valve == newPasswordController.text) {
                    return null;
                  } else {
                    return "Password Field do not match  !!";
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  ButtonThem.buildButton(
                    context,
                    title: "Save",
                    btnColor: ConstantColors.primary,
                    txtColor: Colors.white,
                    btnHeight: 40,
                    btnWidthRatio: 0.3,
                    onPress: () {
                      if (_passwordKey.currentState!.validate()) {
                        Map<String, String> bodyParams = {
                          'id_user':
                              Preferences.getInt(Preferences.userId).toString(),
                          'user_type': myProfileController.userType.value,
                          'old_password': currentPasswordController.text,
                          'new_password': newPasswordController.text,
                        };
                        myProfileController
                            .updatePassword(bodyParams)
                            .then((value) {
                          if (value != null) {
                            if (value['status'] == true) {
                              ShowDialog.showToast(
                                  "Password change successfully");
                              Get.back();
                            } else {
                              ShowDialog.showToast(value['error']);
                            }
                          }
                        });
                      }
                    },
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  ButtonThem.buildButton(context,
                      title: "Cancel",
                      btnHeight: 40,
                      btnWidthRatio: 0.3,
                      btnColor: ConstantColors.blue1,
                      txtColor: Colors.black,
                      onPress: () => Get.back()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
