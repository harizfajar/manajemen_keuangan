import 'package:duitKu/common/widgets/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal
import 'package:duitKu/common/utils/format.dart';
import 'package:duitKu/common/widgets/alertDialog.dart';
import 'package:duitKu/common/widgets/button.dart';
import 'package:duitKu/common/widgets/text.dart';
import 'package:duitKu/pages/Transaction/notifier/transaction_notifier.dart';

class TransactionList extends ConsumerWidget {
  final String cardId;
  final String filter; // "daily", "weekly", "monthly", "lifetime"
  final bool? firstTrx;
  final bool? scroll;
  final double? paddLeft;
  final double? paddRight;

  const TransactionList({
    required this.cardId,
    required this.filter,
    this.paddLeft,
    this.paddRight,
    this.firstTrx,
    this.scroll = true,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionNotifier = ref.read(transactionNotifierProvider.notifier);
    final transactions =
        filter == "daily"
            ? ref.watch(dailyTransactionProvider(cardId))
            : filter == "weekly"
            ? ref.watch(weeklyTransactionProvider(cardId))
            : filter == "monthly"
            ? ref.watch(monthlyTransactionProvider(cardId))
            : ref.watch(lifetimeTransactionProvider(cardId));
    return transactions.isEmpty
        ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/logo/noTrx.svg"),
              textCapriola(
                fontSize: 16,
                text:
                    filter == "daily"
                        ? "Tidak ada transaksi hari ini"
                        : filter == "weekly"
                        ? "Tidak ada transaksi minggu ini"
                        : filter == "monthly"
                        ? "Tidak ada transaksi bulan ini"
                        : filter == "lifetime"
                        ? "Tidak ada transaksi sepanjang waktu"
                        : "Tidak ada transaksi",
                color: Colors.white,
              ),
            ],
          ),
        )
        : ListView.builder(
          shrinkWrap: true,
          physics:
              scroll == true
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(bottom: 100),

          itemCount:
              firstTrx == true
                  ? transactions.length > 2
                      ? 3
                      : transactions.length
                  : transactions.length,
          itemBuilder: (context, index) {
            final data = transactions[index];
            return Column(
              children: [
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: boxDekor(
                        color: Colors.white,
                        borderWidth: 0,
                        colorBorder: Colors.transparent,
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.only(
                          top: 20,
                          right: 10,
                          left: 10,
                        ),
                        tileColor:
                            Colors
                                .blue[50], // Set the background color of the tile
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder:
                                (context) => showDetailll(
                                  context,
                                  data,
                                  onPressYesDel: () async {
                                    transactionNotifier.deleteTransaction(
                                      data: data,
                                    );
                                  },
                                  content:
                                      "Apakah yakin ingin menghapus transaksi ini?",
                                  children: [
                                    SvgPicture.asset(
                                      data.category == "Gaji"
                                          ? "assets/logo/money.svg"
                                          : data.category == "Transportasi"
                                          ? "assets/logo/transportasi.svg"
                                          : data.category == "Belanja"
                                          ? "assets/logo/shopping.svg"
                                          : data.category == "Hiburan"
                                          ? "assets/logo/refresing.svg"
                                          : data.category == "Lainnya"
                                          ? "assets/logo/other3.svg"
                                          : "assets/logo/makanan.svg",
                                      color:
                                          data.category == "Lainnya"
                                              ? AppColors.primary
                                              : null,
                                      height: 50,
                                    ),
                                    textPoppins(
                                      fontWeight: FontWeight.w600,
                                      text:
                                          data.type == "income"
                                              ? "+Rp ${formatCurrency(data.amount)}"
                                              : "-Rp ${formatCurrency(data.amount)}",
                                      color:
                                          data.type == "income"
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                    const SizedBox(height: 10),
                                    textCapriola(
                                      fontSize: 10,
                                      text: "Kategori: ${data.category}",
                                      color: Colors.black,
                                    ),
                                    const SizedBox(height: 5),
                                    textCapriola(
                                      fontSize: 10,
                                      text: "Deskripsi: ${data.description}",
                                      color: Colors.black,
                                    ),
                                    const SizedBox(height: 5),
                                    textCapriola(
                                      fontSize: 10,
                                      text:
                                          "Tanggal: ${DateFormat('dd MMM yyyy', 'id_ID').format(data.date.toDate())}",
                                      color: Colors.black,
                                    ),
                                    const SizedBox(height: 5),
                                    textCapriola(
                                      fontSize: 10,
                                      text:
                                          "Jam: ${DateFormat(' HH:mm', 'id_ID').format(data.date.toDate())}",
                                      color: Colors.black,
                                    ),
                                    const SizedBox(height: 5),
                                    textCapriola(
                                      fontSize: 10,
                                      text:
                                          "Tipe: ${data.type == "income" ? "Pemasukan" : "Pengeluaran"}",
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                          );
                        },
                        leading: SvgPicture.asset(
                          data.category == "Gaji"
                              ? "assets/logo/money.svg"
                              : data.category == "Transportasi"
                              ? "assets/logo/transportasi.svg"
                              : data.category == "Belanja"
                              ? "assets/logo/shopping.svg"
                              : data.category == "Hiburan"
                              ? "assets/logo/refresing.svg"
                              : data.category == "Makanan"
                              ? "assets/logo/makanan.svg"
                              : "assets/logo/other.svg",
                          height: data.category == "Lainnya" ? 12 : 50,
                          color:
                              data.category == "Lainnya"
                                  ? AppColors.primary
                                  : null,
                        ),
                        title: textCapriola(
                          fontSize: 16,
                          text: data.category,
                          color: Colors.black,
                        ),
                        subtitle: textCapriola(
                          fontSize: 12,
                          text:
                              data.description.length > 28
                                  ? "${data.description.substring(0, 28)}..."
                                  : data.description,
                          color: Colors.grey,
                        ),
                        trailing: textPoppins(
                          fontWeight: FontWeight.w600,
                          text:
                              data.type == "income"
                                  ? "+Rp ${formatCurrency(data.amount)}"
                                  : "-Rp ${formatCurrency(data.amount)}",
                          color:
                              data.type == "income" ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: double.infinity,
                      height: 25,
                      decoration: boxDekor(
                        color: Colors.grey.shade300,
                        colorBorder: Colors.transparent,
                        borderRadius: 10,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              textCapriola(
                                fontSize: 10,
                                text: DateFormat(
                                  'dd MMM',
                                  "id_ID",
                                ).format(data.date.toDate()),
                                color: Colors.grey,
                              ),
                              textCapriola(
                                fontSize: 10,
                                text: DateFormat(
                                  'EEEE',
                                  'id_ID',
                                ).format(data.date.toDate()),
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
  }
}
