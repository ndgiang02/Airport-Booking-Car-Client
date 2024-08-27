import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../constant/constant.dart';
import '../../controllers/phonenumber_controller.dart';
import '../../utils/themes/button.dart';
import '../../utils/themes/contant_colors.dart';

class OtpScreen extends StatelessWidget {
  String? phoneNumber;
  //String? verificationId;

  OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);

  final controller = Get.put(PhoneNumberController());
  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.background,
      body: SafeArea(
        child: Container(
          height: Get.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(login_background),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "Enter OTP".tr,
                          style: const TextStyle(letterSpacing: 0.60, fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                            width: 80,
                            child: Divider(
                              color: ConstantColors.blue1,
                              thickness: 3,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: PinCodeTextField(
                            length: 6,
                            appContext: context,
                            keyboardType: TextInputType.phone,
                            pinTheme: PinTheme(
                              fieldHeight: 50,
                              fieldWidth: 50,
                              activeColor: ConstantColors.textFieldBoarderColor,
                              selectedColor: ConstantColors.textFieldBoarderColor,
                              inactiveColor: ConstantColors.textFieldBoarderColor,
                              activeFillColor: Colors.white,
                              inactiveFillColor: Colors.white,
                              selectedFillColor: Colors.white,
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enableActiveFill: true,
                            cursorColor: ConstantColors.primary,
                            controller: textEditingController,
                            onCompleted: (v) async {},
                            onChanged: (value) {
                              debugPrint(value);
                            },
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: ButtonThem.buildButton(
                              context,
                              title: 'Done'.tr,
                              btnHeight: 50,
                              btnColor: ConstantColors.primary,
                              txtColor: Colors.white,
                              onPress: () async {
                                /*
                                FocusScope.of(context).unfocus();
                                if (textEditingController.text.length == 6) {
                                  ShowDialog.showLoader("Verify OTP");
                                  PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId.toString(), smsCode: textEditingController.text);
                                  await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
                                    Map<String, String> bodyParams = {
                                      'phone': phoneNumber.toString(),
                                      'user_cat': "customer",
                                    };
                                    await controller.phoneNumberIsExit(bodyParams).then((value) async {
                                      if (value == true) {
                                        Map<String, String> bodyParams = {
                                          'phone': phoneNumber.toString(),
                                          'user_cat': "customer",
                                        };
                                        await controller.getDataByPhoneNumber(bodyParams).then((value) {
                                          if (value != null) {
                                            if (value.success == "success") {
                                              ShowDialog.closeLoader();

                                              Preferences.setInt(Preferences.userId, value.data!.id!);
                                              Preferences.setString(Preferences.user, jsonEncode(value));
                                              Preferences.setString(Preferences.accesstoken, value.data!.accesstoken.toString());
                                              API.header['accesstoken'] = Preferences.getString(Preferences.accesstoken);
                                                Preferences.setBoolean(Preferences.isLogin, true);
                                                Get.offAll(HomeScreen());
                                              }
                                            } else {
                                              ShowDialog.showToast(value.error);
                                            }
                                          }
                                        });
                                      } else if(value == false){
                                        ShowDialog.closeLoader();
                                        Get.off(SignUpScreen(
                                          phoneNumber: phoneNumber.toString(),
                                        ));
                                      }
                                    });
                                  }).catchError((error) {
                                    ShowDialog.closeLoader();
                                    ShowDialog.showToast("Code is Invalid");
                                  });
                                } else {
                                  ShowDialog.showToast("Please Enter OTP");
                                }
                                */
                              },
                            ))
                      ],
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
    );
  }
}
