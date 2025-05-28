import 'package:duitKu/common/utils/format.dart';
import 'package:duitKu/common/widgets/color.dart';
import 'package:duitKu/common/widgets/templateAPP.dart';
import 'package:duitKu/common/widgets/text.dart';
import 'package:duitKu/global.dart';
import 'package:duitKu/pages/Card/notifier/cards_notifier.dart';
import 'package:duitKu/pages/Transaction/transaction_list.dart';
import 'package:duitKu/pages/application/notifier/application_notifier.dart';
import 'package:duitKu/pages/beranda/piechart.dart';
import 'package:duitKu/pages/sign_in/notifier/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Beranda extends ConsumerWidget {
  const Beranda({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = Global.storageService.getUserId();
    final UserNotifier = ref.watch(userNotifierProvider.notifier);
    final cardid = ref.watch(selectedCardProvider);
    final cardAsync = ref.watch(cardProvider(cardid.toString()));
    final obscure = ref.watch(obscureBalanceNotifierProvider);
    final obscureNotifier = ref.read(obscureBalanceNotifierProvider.notifier);
    final selectedIndex = ref.watch(bottombarIndexProvider);
    final selectedIndexNotifier = ref.read(bottombarIndexProvider.notifier);
    return TemplateAPP(
      userId: userId,
      userNotifier: UserNotifier,
      Content: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 5),
                    child: cardAsync.when(
                      loading: () => Center(child: CircularProgressIndicator()),
                      error:
                          (error, stackTrace) =>
                              Center(child: Text("Error: $error")),
                      data:
                          (data) => Stack(
                            children: [
                              Positioned(
                                top: 15,
                                child: Text(
                                  "Saldo Sekarang",
                                  style: TextStyle(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 40,
                                child: Text(
                                  obscure
                                      ? "Rp ${formatCurrency(data.balance)}"
                                      : "************",
                                  style: TextStyle(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 35,
                                child: IconButton(
                                  onPressed: () {
                                    obscureNotifier.changeValue(!obscure);
                                  },
                                  icon:
                                      obscure
                                          ? Icon(
                                            Icons.remove_red_eye_outlined,
                                            color: AppColors.secondary,
                                          )
                                          : SvgPicture.asset(
                                            "assets/logo/eye_hide.svg",
                                            width: 20,
                                          ),
                                ),
                              ),
                            ],
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textPoppins(
                        fontSize: 18,
                        text: "Catatan Finansial",
                        fontWeight: FontWeight.bold,
                      ),
                      textPoppins(
                        fontSize: 16,
                        text: "Cashflow",
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                CatatanFinansialPieChartContent(),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textPoppins(
                        fontSize: 18,
                        text: "Transaksi Terbaru",
                        fontWeight: FontWeight.bold,
                      ),
                      GestureDetector(
                        onTap: () => selectedIndexNotifier.changeValue(1),
                        child: textPoppins(fontSize: 14, text: "Lihat Semua"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                TransactionList(
                  paddLeft: 0,
                  paddRight: 0,
                  scroll: false,
                  cardId: cardid.toString(),
                  filter: "monthly",
                  firstTrx: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
