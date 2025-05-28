import 'package:duitKu/common/widgets/templateCRUD.dart';
import 'package:duitKu/pages/Transaction/edit_transaction.dart';
import 'package:duitKu/pages/Transaction/notifier/transaction_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:duitKu/common/widgets/button.dart';
import 'package:duitKu/common/widgets/text.dart';
import 'package:duitKu/pages/Card/notifier/cards_notifier.dart';
import 'package:sizer/sizer.dart';

class AddTransaction extends ConsumerStatefulWidget {
  const AddTransaction({super.key});

  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends ConsumerState<AddTransaction> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transaction = ref.watch(transactionNotifierProvider);
    final transactionNotifier = ref.read(transactionNotifierProvider.notifier);
    final cardid = ref.watch(selectedCardProvider).toString();
    return Scaffold(
      body: SingleChildScrollView(
        child: TemplateCRUD(
          form: true,
          formKey: _formKey,
          children: [
            SvgPicture.asset("assets/logo/addtransaksi.svg", width: 90),
            SizedBox(height: 1.h),
            textCapriola(
              fontSize: 24,
              text: "Tambah Transaksi",
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 6.h),
            Align(
              alignment: Alignment.centerLeft,
              child: textCapriola(
                fontSize: 10,
                text: "Deskripsi",
                fontWeight: FontWeight.bold,
              ),
            ),
            appTextFormField(
              text: "Masukkan Deskripsi",
              validator:
                  (value) =>
                      value!.isEmpty ? "Deskripsi tidak boleh kosong" : null,
              func: (value) => _descriptionController.text = value,
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
              func: (value) {
                String cleanedInput = value.replaceAll('.', '');
                _amountController.text = cleanedInput;
              },
            ),
            SizedBox(height: 1.h),

            Align(
              alignment: Alignment.centerLeft,
              child: textCapriola(
                fontSize: 10,

                text: "Pilih Kategori",
                fontWeight: FontWeight.bold,
              ),
            ),
            CustomDropDown(
              value: transactionNotifier.selectedCategory,
              itemsList: transactionNotifier.categories,
              onChanged: (value) {
                transactionNotifier.changeCategory(value!);
              },
            ),
            SizedBox(height: 1.h),
            Align(
              alignment: Alignment.centerLeft,
              child: textCapriola(
                fontSize: 10,
                text: "Pilih Tipe ",
                fontWeight: FontWeight.bold,
              ),
            ),
            CustomDropDown(
              value: transactionNotifier.selectedType,
              itemsList: transactionNotifier.types,
              onChanged: (value) {
                transactionNotifier.changeType(value!);
              },
            ),
            SizedBox(height: 3.h),

            button(
              height: 50,
              width: 100.w,
              colorBorder: Colors.transparent,
              borderWidth: 0,
              text: transaction.isLoading ? "Tunggu..." : "Tambah",
              colorText: Colors.black,
              func: () {
                if (!_formKey.currentState!.validate()) {
                  print("Form tidak valid");
                  return;
                }
                print("add trx");
                transactionNotifier.addTransaction(
                  cardId: cardid,
                  description: _descriptionController.text,
                  amountController: _amountController.text,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDropDown extends StatelessWidget {
  final String value;
  final List<String> itemsList;
  final Color? dropdownColor;
  final ValueChanged<String?> onChanged;
  final String? hint;

  const CustomDropDown({
    required this.value,
    required this.itemsList,
    this.dropdownColor,
    required this.onChanged,
    this.hint,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,

          child: DropdownButton<String>(
            alignment: Alignment.bottomCenter,
            borderRadius: BorderRadius.circular(5),
            isExpanded: true,
            dropdownColor: dropdownColor ?? Colors.white,
            value: value,
            icon: Icon(Icons.keyboard_arrow_down),
            items:
                itemsList.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item == "income"
                          ? "Pemasukan"
                          : item == "expense"
                          ? "Pengeluaran"
                          : item,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Capriola',
                      ),
                    ),
                  );
                }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
