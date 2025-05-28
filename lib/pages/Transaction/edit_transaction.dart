import 'package:duitKu/common/utils/format.dart';
import 'package:duitKu/common/widgets/templateCRUD.dart';
import 'package:duitKu/pages/Transaction/notifier/transaction_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:duitKu/common/model/transactions.dart';
import 'package:duitKu/common/widgets/button.dart';
import 'package:duitKu/common/widgets/color.dart';
import 'package:duitKu/common/widgets/text.dart';
import 'package:duitKu/pages/Card/notifier/cards_notifier.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class EditTransaction extends ConsumerStatefulWidget {
  final TransactionModel transactionData;
  const EditTransaction({required this.transactionData, super.key});

  @override
  _EditTransactionState createState() => _EditTransactionState();
}

class _EditTransactionState extends ConsumerState<EditTransaction> {
  final _formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  @override
  void initState() {
    super.initState();
    final transactionNotifier = ref.read(transactionNotifierProvider.notifier);
    final amount = widget.transactionData.amount;
    amountController.text = formatCurrency(amount);
    descriptionController.text = widget.transactionData.description;
    transactionNotifier.selectedCategory = widget.transactionData.category;
    transactionNotifier.selectedType = widget.transactionData.type;
    transactionNotifier.selectedDateTime = widget.transactionData.date.toDate();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    amountController.dispose();
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
            SizedBox(
              width: 130,
              height: 100,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    right: 30,
                    child: SvgPicture.asset(
                      "assets/logo/addtransaksi.svg",
                      width: 90,
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 0,
                    child: SvgPicture.asset(
                      "assets/logo/editpencil.svg",
                      width: 70,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            textCapriola(
              fontSize: 24,
              text: "Edit Transaksi",
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 50),
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
              controller: descriptionController,
              validator:
                  (value) =>
                      value!.isEmpty ? "Deskripsi tidak boleh kosong" : null,
              func: (value) => descriptionController.text = value,
            ),
            SizedBox(height: 10),
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
              controller: amountController,
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
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: textCapriola(
                fontSize: 10,

                text: "Tanggal Transaksi",
                fontWeight: FontWeight.bold,
              ),
            ),
            InkWell(
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: transactionNotifier.selectedDateTime,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  locale: Locale('id', 'ID'),
                );

                if (pickedDate != null) {
                  final combinedDateTime = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    transactionNotifier.selectedDateTime.hour,
                    transactionNotifier.selectedDateTime.minute,
                  );
                  transactionNotifier.changeDateTime(combinedDateTime);
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: textCapriola(
                  text: DateFormat(
                    "EEEE, dd MMMM yyyy",
                    "id",
                  ).format(transactionNotifier.selectedDateTime),
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: textCapriola(
                fontSize: 10,
                text: "Jam Transaksi",
                fontWeight: FontWeight.bold,
              ),
            ),
            InkWell(
              onTap: () async {
                final pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(
                    transactionNotifier.selectedDateTime,
                  ),
                );

                if (pickedTime != null) {
                  final combinedDateTime = DateTime(
                    transactionNotifier.selectedDateTime.year,
                    transactionNotifier.selectedDateTime.month,
                    transactionNotifier.selectedDateTime.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );
                  transactionNotifier.changeDateTime(combinedDateTime);
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: textCapriola(
                  text:
                      "${transactionNotifier.selectedDateTime.hour.toString().padLeft(2, '0')}:"
                      "${transactionNotifier.selectedDateTime.minute.toString().padLeft(2, '0')}",
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 10),

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
            SizedBox(height: 10),
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
            SizedBox(height: 25),
            button(
              height: 50,
              width: 100.w,
              colorBorder: Colors.transparent,
              borderWidth: 0,
              text: transaction.isLoading ? "Tunggu..." : "Ubah",
              colorText: Colors.black,
              func: () {
                if (!_formKey.currentState!.validate()) {
                  print("Form tidak valid");
                  return;
                }
                transactionNotifier.editTransaction(
                  cardId: cardid,
                  transactionId: widget.transactionData.id,
                  description: descriptionController.text,
                  amountC: amountController.text,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget appTextFormField({
  String? text,
  Color? color,
  Color? colorHint,
  bool showSuffixIcon = false,
  bool obscureText = false,
  double? fontSize,
  int? maxLines,
  TextEditingController? controller,
  Function()? onPressed,
  Function(String?)? validator,
  Function(String)? func,
  TextInputType? keyboardType,
  List<TextInputFormatter>? formatter,
  bool assets = false,
}) {
  return TextFormField(
    controller: controller,
    onChanged: func,
    keyboardType: keyboardType,
    maxLines: maxLines,
    inputFormatters: formatter,
    style: TextStyle(
      fontFamily: "Capriola",
      fontSize: fontSize,
      color: colorHint,
    ),
    decoration: InputDecoration(
      prefixIcon:
          assets == true
              ? Container(
                margin: EdgeInsets.all(15),
                child: SvgPicture.asset("assets/logo/Rp.svg"),
              )
              : Icon(Icons.edit_document, color: colorHint),

      errorStyle: TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontFamily: "Capriola",
      ),
      isDense: true,
      filled: true,
      fillColor: color ?? Colors.white,
      hintText: text ?? "Enter your email",
      hintStyle: TextStyle(
        fontSize: fontSize ?? 14,
        fontFamily: "Capriola",
        color: colorHint,
      ),
      suffixIcon:
          showSuffixIcon
              ? IconButton(
                onPressed: onPressed,
                icon: Icon(
                  color: AppColors.primary,
                  obscureText == false
                      ? Icons.remove_red_eye
                      : Icons.visibility_off,
                ),
              )
              : null,
      border: OutlineInputBorder(borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
    ),
    validator: validator as FormFieldValidator<String>?,
  );
}

class CustomDropDown extends StatelessWidget {
  final String value;
  final List<String> itemsList;
  final Color? dropdownColor;
  final ValueChanged<String?> onChanged;
  final String? hint;
  final Color? color;
  final Color? colorText;
  final double? fontSize;
  final Color? colorIcon;

  const CustomDropDown({
    required this.value,
    required this.itemsList,
    this.dropdownColor,
    required this.onChanged,
    this.hint,
    this.color,
    this.colorText,
    this.colorIcon,
    this.fontSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color ?? Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            alignment: Alignment.bottomCenter,
            borderRadius: BorderRadius.circular(10),
            isExpanded: true,
            dropdownColor: dropdownColor ?? Colors.white,
            value: value,
            icon: Icon(Icons.keyboard_arrow_down, color: colorIcon),
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
                      style: TextStyle(
                        fontSize: fontSize ?? 14,
                        fontFamily: 'Capriola',
                        color: colorText ?? Colors.black,
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
