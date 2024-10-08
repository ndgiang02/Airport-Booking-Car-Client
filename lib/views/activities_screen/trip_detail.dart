import 'package:customerapp/utils/themes/text_style.dart';
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

    Color getStatusColor(String status) {
      switch (status) {
        case 'completed':
          return Colors.green;
        case 'accepted':
          return Colors.orange;
        case 'cancelled':
          return Colors.red;
        default:
          return Colors.black;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Details'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
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
                _buildInfoRow(Icons.abc, 'status'.tr, trip.tripStatus ?? '', statusColor: getStatusColor(trip.tripStatus ?? '')),
                const SizedBox(height: 12),
                _buildAmountRow(trip.totalAmount),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.wallet, 'payment method'.tr, trip.payment ?? ''),
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
                      title: 'cancel_trip'.tr,
                      content: 'are_you_sure_cancel'.tr,
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
                        Get.back();
                      },
                    );
                  } : () {},
                  enabled: trip.tripStatus == 'requested',
                  disabledBtnColor: Colors.white,
                  disabledTxtColor: Colors.grey,
                  disabledBorderColor: Colors.grey,
                ),
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

}
