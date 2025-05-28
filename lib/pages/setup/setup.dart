import 'package:duitKu/pages/Card/notifier/card_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:duitKu/common/widgets/apptextfield.dart';
import 'package:duitKu/common/widgets/button.dart';
import 'package:duitKu/common/widgets/color.dart';
import 'package:duitKu/common/widgets/text.dart';
import 'package:sizer/sizer.dart';

class Setup extends ConsumerWidget {
  const Setup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final card = ref.watch(cardNotifierProvider);
    final cardNotifier = ref.read(cardNotifierProvider.notifier);
    return Scaffold(
      body: Container(
        height: 100.h,
        width: 100.w,
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/logo/card.svg", width: 50),
              SizedBox(height: 3.h),
              textCapriola(
                fontSize: 24,
                text: "Siapkan Kartu Kamu",
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
                asset: "assets/logo/Rp.svg",
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter(
                    mantissaLength: 0,
                    thousandSeparator: ThousandSeparator.Period,
                  ),
                ],
                func: (value) {
                  String filteredValue = value.replaceAll(".", "");
                  cardNotifier.changeSaldo(double.tryParse(filteredValue) ?? 0);
                },
              ),
              SizedBox(height: 4.h),
              button(
                height: 50,
                width: 100.w,
                colorBorder: Colors.transparent,
                borderWidth: 0,
                text: "Lanjutkan",
                colorText: Colors.black,
                func: () {
                  print("Next");
                  cardNotifier.addCard();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
