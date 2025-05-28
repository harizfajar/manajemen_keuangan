import 'dart:math';
import 'package:duitKu/common/utils/format.dart';
import 'package:duitKu/common/widgets/button.dart';
import 'package:duitKu/common/widgets/color.dart';
import 'package:duitKu/common/widgets/text.dart';
import 'package:duitKu/pages/Card/notifier/cards_notifier.dart';
import 'package:duitKu/pages/beranda/notifier/beranda_notifier.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tuple/tuple.dart';

class CatatanFinansialPieChartContent extends ConsumerWidget {
  const CatatanFinansialPieChartContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardId = ref.watch(selectedCardProvider);
    final indexPage = ref.watch(indexPageNotiferProvider);
    final indexPageNotifier = ref.read(indexPageNotiferProvider.notifier);
    print(indexPage);

    final monthlyDataPengeluaran = ref.watch(
      monthlyCostByCategoryProvider(Tuple2(cardId.toString(), "expense")),
    );
    final monthlyDataPemasukkan = ref.watch(
      monthlyCostByCategoryProvider(Tuple2(cardId.toString(), "income")),
    );
    final cmparisonCost = ref.watch(
      monthlyCostTotalProvider(cardId.toString()),
    );
    final controllerPage = PageController(initialPage: 0);
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: 460,
      width: width,
      decoration: boxDekor(
        color: Colors.white,
        colorBorder: Colors.white,
        borderWidth: 0,
      ),
      child: Column(
        children: [
          BuildMonthDropdown(ref),
          SizedBox(height: 10),
          SizedBox(
            height: 350,
            child: PageView(
              controller: controllerPage,
              onPageChanged: (value) => indexPageNotifier.changeValue(value),
              children: [
                _buildChartPage(
                  monthlyDataPengeluaran,
                  "Pengeluaran",
                  context,
                  indexPage,
                ),
                _buildChartPage(
                  monthlyDataPemasukkan,
                  "Pemasukan",
                  context,
                  indexPage,
                ),
                _buildChartPage(cmparisonCost, "Cashflow", context, indexPage),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  controllerPage.previousPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: AppColors.secondary,
                ),
              ),
              SmoothPageIndicator(
                controller: controllerPage,
                count: 3,
                effect: WormEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  activeDotColor: AppColors.secondary,
                ),
              ),
              IconButton(
                onPressed: () {
                  controllerPage.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                icon: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildChartPage(
  AsyncValue<Map<String, double>> data,
  String label,
  BuildContext context,
  int page,
) {
  return data.when(
    data: (data) {
      if (data.isEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/logo/noTrx.svg",
              width: 70,
              height: 70,
              color: AppColors.secondary,
            ),
            page == 0
                ? textCapriola(
                  fontSize: 14,
                  text: "Tidak ada pengeluaran bulan ini",
                  color: AppColors.secondary,
                )
                : page == 1
                ? textCapriola(
                  fontSize: 14,
                  text: "Tidak ada pemasukkan bulan ini",
                  color: AppColors.secondary,
                )
                : SizedBox(),
          ],
        );
      }
      double total = 0;
      if (label == "Cashflow") {
        final income = data['Income'] ?? 0;
        final expense = data['Expense'] ?? 0;
        total = income - expense;
      } else {
        total = data.values.fold(0.0, (a, b) => a + b);
      }
      return Center(
        child:
            data['Income'] != 0 && data["Expense"] != 0
                ? Stack(
                  children: [
                    buildPieChartWithIcons(data),
                    Positioned(
                      top: 135,
                      right: 10.w,
                      left: 10.w,
                      child: Container(
                        width: 194,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10,
                          children: [
                            textPoppins(
                              text: "Total \n$label",
                              textAlign: TextAlign.center,
                              color: AppColors.secondary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),

                            textPoppins(
                              text: "IDR ${formatCurrency(total / 1000)} RB",

                              color:
                                  label == "Pengeluaran" || total < 0
                                      ? Colors.red
                                      : Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/logo/noTrx.svg",
                      width: 70,
                      height: 70,
                      color: AppColors.secondary,
                    ),
                    textCapriola(
                      fontSize: 14,
                      text: "Tidak ada cashflow bulan ini",
                      color: AppColors.secondary,
                    ),
                  ],
                ),
      );
    },
    error: (e, _) => Center(child: Text("Error bangg:$e")),
    loading: () => Center(child: CircularProgressIndicator()),
  );
}

Widget buildPieChartWithIcons(Map<String, double> data) {
  final total = data.values.fold(0.0, (a, b) => a + b);
  final radius = 150.0;

  double currentAngle = -90;

  final iconWidgets = <Widget>[];

  for (final entry in data.entries) {
    final sweepAngle = (entry.value / total) * 360;
    final midAngle = currentAngle + sweepAngle / 2;
    currentAngle += sweepAngle;

    final radian = midAngle * pi / 180;
    final offsetRadius = radius / 1; // posisi ikon di luar tengah lingkaran
    final dx = radius + offsetRadius * cos(radian) + 16;
    final dy = radius + offsetRadius * sin(radian) + 16;

    final iconPath = categoryIcons[entry.key];

    if (iconPath != null) {
      iconWidgets.add(
        Positioned(
          left: dx,
          top: dy,
          child: SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
            color:
                iconPath == "assets/logo/other3.svg"
                    ? AppColors.secondary
                    : null,
          ),
        ),
      );
    }
  }

  final sections =
      data.entries.map((entry) {
        final value = entry.value;
        final percentage = (value / total) * 100;
        return PieChartSectionData(
          value: value,
          // color: AppColors.secondary,
          color: getCategoryColor(entry.key),
          title: '${percentage.toStringAsFixed(0)}%',
          radius: 30,
          titleStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        );
      }).toList();

  return Stack(
    children: [
      Container(
        width: radius * 2 + 60,
        height: radius * 2 + 60,
        child: PieChart(
          PieChartData(
            centerSpaceRadius: 100,
            sectionsSpace: 2,
            startDegreeOffset: -90,
            sections: sections,
          ),
        ),
      ),
      ...iconWidgets,
    ],
  );
}

Color getCategoryColor(String category) {
  switch (category) {
    case 'Income':
      return Colors.green;
    case 'Expense':
      return Colors.red;
    default:
      return AppColors.secondary;
  }
}

final categoryIcons = {
  'Makanan': 'assets/logo/makanan.svg',
  'Belanja': 'assets/logo/shopping.svg',
  'Transportasi': 'assets/logo/transportasi.svg',
  'Lainnya': 'assets/logo/other3.svg',
  'Hiburan': 'assets/logo/refresing.svg',
  'Gaji': 'assets/logo/money.svg',
};

List<DateTime> getMonthList() {
  final now = DateTime.now();
  return List.generate(5, (i) => DateTime(now.year, now.month - i));
}

Widget BuildMonthDropdown(WidgetRef ref) {
  final selected = ref.watch(selectedMonthNotifierProvider);
  final monthList = getMonthList();

  // Cari instance yang cocok dari list
  final matchingSelected = monthList.firstWhere(
    (m) => m.year == selected.year && m.month == selected.month,
    orElse: () => monthList.first,
  );

  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: SizedBox(
      width: 200,
      height: 35,
      child: DropdownButtonFormField<DateTime>(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 10, right: 5),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.secondary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.secondary),
          ),
        ),
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: AppColors.secondary,
          fontWeight: FontWeight.w600,
        ),
        value: matchingSelected,
        icon: Icon(Icons.keyboard_arrow_down),
        onChanged: (value) {
          if (value != null) {
            ref.read(selectedMonthNotifierProvider.notifier).changeMonth(value);
          }
        },
        items:
            monthList.map((date) {
              final label = DateFormat.yMMMM("id_ID").format(date);
              return DropdownMenuItem(value: date, child: Text(label));
            }).toList(),
      ),
    ),
  );
}
