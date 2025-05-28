import 'package:duitKu/common/widgets/templateCRUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:duitKu/common/widgets/apptextfield.dart';
import 'package:duitKu/common/widgets/button.dart';
import 'package:duitKu/common/widgets/text.dart';
import 'package:duitKu/pages/Card/notifier/card_notifier.dart';
import 'package:sizer/sizer.dart';

class AddCard extends ConsumerWidget {
  const AddCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardNotifier = ref.read(cardNotifierProvider.notifier);
    return Scaffold(
      body: SingleChildScrollView(
        child: TemplateCRUD(
          children: [
            SvgPicture.asset("assets/logo/card.svg", width: 80),
            SizedBox(height: 3.h),
            textCapriola(
              fontSize: 24,
              text: "Tambah Kartu",
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 6.h),
            apptextfield(
              logo: true,
              text: "Masukkan Nama Kartu kamu",
              func: (value) => cardNotifier.changeName(value),
            ),
            SizedBox(height: 3.h),
            apptextfield(
              logo: true,
              text: "Masukkan Saldo kamu",
              keyboardType: TextInputType.number,
              inputFormatters: [
                CurrencyInputFormatter(
                  mantissaLength: 0,
                  thousandSeparator: ThousandSeparator.Period,
                ),
              ],
              asset: "assets/logo/Rp.svg",
              widthSizebox: 10,
              func: (value) {
                String cleanedInput = value.replaceAll('.', '');
                cardNotifier.changeSaldo(double.tryParse(cleanedInput) ?? 0);
              },
            ),
            SizedBox(height: 4.h),
            button(
              height: 50,
              width: 100.w,
              colorBorder: Colors.transparent,
              borderWidth: 0,
              text: "Tambah",
              colorText: Colors.black,
              func: () {
                print("next");
                cardNotifier.addCard();
              },
            ),
          ],
        ),
      ),
    );
  }
}
