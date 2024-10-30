import 'package:customerapp/utils/themes/text_style.dart';
import 'package:customerapp/views/activities_screen/drivermap_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../constant/show_dialog.dart';
import '../../controllers/activities_controller.dart';
import '../../models/trip_model.dart';
import '../../utils/themes/button.dart';
import '../../utils/themes/custom_dialog_box.dart';

class TripDetail extends StatelessWidget {
  const TripDetail({super.key});

  @override
  Widget build(BuildContext context) {

    final ActivitiesController controller = Get.put(ActivitiesController());
    final Trip trip = Get.arguments;
    String scheduledTime = DateFormat('HH:mm, dd/MM').format(trip.scheduledTime!);
    //String returnTime = DateFormat('HH:mm, dd/MM').format(trip.returnTime!);
    return Scaffold(
      appBar: AppBar(
        title: Text('detail'.tr, style: CustomTextStyles.header.copyWith(color: Colors.white),),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(Icons.location_on, 'from'.tr, trip.fromAddress ?? ''),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.flag, 'to'.tr, trip.toAddress ?? ''),
                const SizedBox(height: 12),
                const Divider(thickness: 1.5, color: Colors.grey),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.access_time, 'scheduled time'.tr, scheduledTime),
                //const SizedBox(height: 12),
               // _buildInfoRow(Icons.access_time, 'return'.tr, returnTime),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.abc, 'status'.tr, _getStatusInfo(trip.tripStatus)['statusText'] ?? '', statusColor: _getStatusInfo(trip.tripStatus)['textColor'] ?? ''),
                const SizedBox(height: 12),
                _buildAmountRow(trip.totalAmount),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.wallet, 'payment method'.tr, _getPaymentInfo(trip.payment) ?? ''),
                const SizedBox(height: 24),
                ButtonThem.buildBorderButton(
                  context,
                  title: 'cancel'.tr,
                  btnBorderColor: Colors.redAccent,
                  btnColor: Colors.white,
                  txtColor: Colors.redAccent,
                  onPress: trip.tripStatus == 'requested' ? () async {
                    CustomAlert.showCustomDialog(
                      context: context,
                      title: 'cancel'.tr,
                      content: 'Do you want to cancel the trip?'.tr,
                      callButtonText: 'yes'.tr,
                      onCallPressed: () async {
                        Map<String, dynamic> bodyParams = {
                          'id': trip.id,
                        };
                        await controller.canceledTrip(bodyParams).then((value) {
                          if (value != null) {
                            if (value['status'] == true) {
                              ActivitiesController activitiesController = Get.find();
                              activitiesController.shouldRefresh(true);
                              Get.back();
                            } else {
                              ShowDialog.showToast(value['message']);
                            }
                          }
                        });
                        Get.back(result: 'canceled');
                      },
                    );
                  } : () {},
                  enabled: trip.tripStatus == 'requested',
                  disabledBtnColor: Colors.white,
                  disabledTxtColor: Colors.grey,
                  disabledBorderColor: Colors.grey,
                ),
                if (trip.tripStatus == 'accepted') ...[
                  const SizedBox(height: 12),
                  ButtonThem.buildBorderButton(
                    context,
                    title: 'detail'.tr,
                    btnBorderColor: Colors.redAccent,
                    btnColor: Colors.white,
                    txtColor: Colors.redAccent,
                    onPress: () async {
                     // controller.startListeningToDriverLocation(trip.driverId!);
                      Get.to(() => DriverMapScreen(), arguments: trip);
                    },
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value, {Color? iconColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor ?? Colors.blue, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: CustomTextStyles.header),
              Text(value, style: CustomTextStyles.body),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value, {Color? statusColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blue, size: 20),
            const SizedBox(width: 12),
            Text(title, style: CustomTextStyles.normal),
            const Text(': ', style: CustomTextStyles.normal),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: statusColor != null
                ? CustomTextStyles.normal.copyWith(color: statusColor)
                : CustomTextStyles.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildAmountRow(double? totalAmount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.add, color: Colors.blue, size: 20),
            const SizedBox(width: 12),
            Text('amount'.tr, style: CustomTextStyles.normal),
            const Text(': ', style: CustomTextStyles.normal),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                totalAmount != null ? NumberFormat('#,###').format(totalAmount) : '0.00',
                style: CustomTextStyles.normal,
              ),
              const SizedBox(width: 2),
              Image.asset('assets/icons/dong.png', width: 16.0, height: 16.0),
            ],
          ),
        ),
      ],
    );
  }

  _getPaymentInfo(String? payment) {
    switch (payment) {
      case 'cash':
        return 'cash'.tr;
      case 'wallet':
        return 'wallet'.tr;
      default:
        return 'Không xác định';
    }
  }

  Map<String, dynamic> _getStatusInfo(String? status) {
    switch (status) {
      case 'requested':
        return {
          'backgroundColor': Colors.blue[100]!,
          'textColor': Colors.blue,
          'statusText': 'requested'.tr,
        };
      case 'accepted':
        return {
          'backgroundColor': Colors.orange[100]!,
          'textColor': Colors.orange,
          'statusText': 'accepted'.tr,
        };
      case 'completed':
        return {
          'backgroundColor': Colors.green[100]!,
          'textColor': Colors.green,
          'statusText': 'completed'.tr,
        };
      case 'cancelled':
        return {
          'backgroundColor': Colors.red[100]!,
          'textColor': Colors.red,
          'statusText': 'canceled'.tr,
        };
      case 'in_progress':
        return {
          'backgroundColor': Colors.white38,
          'textColor': Colors.black,
          'statusText': 'in_progress'.tr,
        };
      default:
        return {
          'backgroundColor': Colors.grey[100]!,
          'textColor': Colors.grey,
          'statusText': 'Không xác định',
        };
    }
  }


}
