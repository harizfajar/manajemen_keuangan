import 'package:duitKu/common/widgets/templateCRUD.dart';
import 'package:duitKu/pages/Transaction/edit_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:duitKu/common/model/cards.dart';
import 'package:duitKu/common/utils/format.dart';
import 'package:duitKu/common/widgets/button.dart';
import 'package:duitKu/common/widgets/popup_messages.dart';
import 'package:duitKu/common/widgets/text.dart';
import 'package:duitKu/pages/Card/notifier/card_notifier.dart';
import 'package:sizer/sizer.dart';

class EditCardPage extends ConsumerStatefulWidget {
  final CardModel card;

  const EditCardPage({super.key, required this.card});

  @override
  ConsumerState<EditCardPage> createState() => _EditCardPageState();
}

class _EditCardPageState extends ConsumerState<EditCardPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _balanceController;
  String? cardid;

  @override
  void initState() {
    super.initState();

    cardid = widget.card.id;
    _nameController = TextEditingController(text: widget.card.cardName);
    _balanceController = TextEditingController(
      text: formatCurrency(widget.card.balance),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: TemplateCRUD(
          form: true,
          formKey: _formKey,
          children: [
            SizedBox(
              width: 130,
              height: 100,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    right: 30,
                    child: SvgPicture.asset("assets/logo/card2.svg", width: 90),
                  ),
                  Positioned(
                    bottom: 30,
                    right: 25,
                    child: SvgPicture.asset(
                      "assets/logo/editpencil.svg",
                      width: 70,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.h),
            textCapriola(
              fontSize: 24,
              text: "Edit Kartu",
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 6.h),
            Align(
              alignment: Alignment.centerLeft,
              child: textCapriola(
                fontSize: 10,
                text: "Nama Kartu",
                fontWeight: FontWeight.bold,
              ),
            ),
            appTextFormField(
              text: "Masukkan Nama Kartu",
              controller: _nameController,
              validator:
                  (value) =>
                      value!.isEmpty ? "Deskripsi tidak boleh kosong" : null,
            ),
            SizedBox(height: 1.h),
            Align(
              alignment: Alignment.centerLeft,
              child: textCapriola(
                fontSize: 10,
                text: "Jumlah Saldo",
                fontWeight: FontWeight.bold,
              ),
            ),
            appTextFormField(
              text: "Masukkan Jumlah Saldo",
              controller: _balanceController,
              assets: true,
              keyboardType: TextInputType.number,
              formatter: [
                CurrencyInputFormatter(
                  mantissaLength: 0,
                  thousandSeparator: ThousandSeparator.Period,
                ),
              ],

              validator:
                  (value) =>
                      value!.isEmpty ? "Jumlah tidak boleh kosong" : null,
            ),

            SizedBox(height: 3.h),

            button(
              height: 50,
              width: 100.w,
              colorBorder: Colors.transparent,
              borderWidth: 0,
              text: "Edit",
              colorText: Colors.black,
              func: () {
                if (_formKey.currentState!.validate()) {
                  final nama = _nameController.text;
                  final cleanBalanceText = _balanceController.text.replaceAll(
                    ".",
                    "",
                  );
                  final balance = double.tryParse(cleanBalanceText) ?? 0;
                  if (nama.length > 8 || nama.length < 3) {
                    toastInfo(
                      "Nama Kartu Minimal 3 Karakter dan Maksimal 8 Karakter",
                    );
                    return;
                  }
                  if (balance < 0) {
                    toastInfo("Saldo minimal minimal 0");
                    return;
                  }
                  ref
                      .read(cardNotifierProvider.notifier)
                      .updateCard(cardId: cardid, nama: nama, saldo: balance);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
