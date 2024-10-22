import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/walletscontroller.dart';
import '../../utils/themes/text_style.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({super.key});

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> {
  @override
  Widget build(BuildContext context) {
    final WalletController walletController = Get.put(WalletController());

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 5),
                Text(
                  'wallet'.tr,
                  style: CustomTextStyles.app.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      const Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Colors.black26,
                      ),
                    ],
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            )
          ],
        ),
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
      body: Obx(() {
        log('transaction: ${walletController.transactions}');
        if (walletController.transactions.isEmpty) {
          return Center(child: Text('no_information_wallet'.tr));
        } else {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  walletController.balance.value.toStringAsFixed(2),
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: walletController.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = walletController.transactions[index];
                    return ListTile(
                      title: Text(transaction.type),
                      subtitle: Text(transaction.date.toString()),
                      trailing: Text(
                        '\$${transaction.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: transaction.amount < 0
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          log('Top-up button pressed');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Top-up Wallet'),
                content: TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Enter amount',
                  ),
                  onChanged: (value) {},
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('cancel'.tr),
                  ),
                  TextButton(
                    onPressed: () {
                      // Thực hiện logic nạp tiền vào ví
                      Navigator.of(context).pop();
                    },
                    child: const Text('Top-up'),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Top-up Wallet',
        child: const Icon(Icons.add),
      ),
    );
  }
}
