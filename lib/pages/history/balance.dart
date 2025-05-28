import 'package:duitKu/common/widgets/apptextfield.dart';
import 'package:duitKu/common/widgets/color.dart';
import 'package:duitKu/common/widgets/shimmer.dart';
import 'package:duitKu/main.dart';
import 'package:duitKu/pages/Transaction/edit_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:duitKu/common/utils/format.dart' show formatCurrency;
import 'package:duitKu/common/widgets/button.dart';
import 'package:duitKu/common/widgets/text.dart';
import 'package:duitKu/pages/application/notifier/application_notifier.dart';
import 'package:duitKu/pages/Card/notifier/cards_notifier.dart';
import 'package:duitKu/pages/Transaction/notifier/transaction_notifier.dart';
import 'package:sizer/sizer.dart';

class TotalBalance extends ConsumerWidget {
  final TabController tabController;
  const TotalBalance({required this.tabController, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCardId = ref.watch(selectedCardProvider).toString();
    final transaction = ref.watch(transactionNotifierProvider);
    final transactionNotifier = ref.read(transactionNotifierProvider.notifier);
    final currentFilter = ref.watch(transactionFilterNotifierProvider);
    final currentFilterNotifier = ref.read(
      transactionFilterNotifierProvider.notifier,
    );
    // Ambil data income & expense berdasarkan Tab yang dipilih
    final incomeProviders = [
      dailyIncomeProvider(selectedCardId),
      weeklyIncomeProvider(selectedCardId),
      monthlyIncomeProvider(selectedCardId),
      totalIncomeProvider(selectedCardId),
    ];
    final expenseProviders = [
      dailyExpenseProvider(selectedCardId),
      weeklyExpenseProvider(selectedCardId),
      monthlyExpenseProvider(selectedCardId),
      totalExpenseProvider(selectedCardId),
    ];

    final cardAsync = ref.watch(cardProvider(selectedCardId));
    return SizedBox(
      height: 140,
      width: 100.w,
      child: cardAsync.when(
        data: (card) {
          final selectedTab = ref.watch(selectTabProvider);
          final income = ref.watch(incomeProviders[selectedTab]);
          final expense = ref.watch(expenseProviders[selectedTab]);
          final totalIncome = ref.watch(totalIncomeProvider(selectedCardId));
          final totalExpense = ref.watch(totalExpenseProvider(selectedCardId));
          final totalBalance = ref.watch(totalBalanceProvider(selectedCardId));

          // final income = card.balance + totalIncome;
          String datenow =
              "${DateTime.now().day} "
              "${DateFormat('MMMM', "id_ID").format(DateTime.now())}";

          // Watch the filter to update UI accordingly

          return Container(
            decoration: boxDekor(
              color: Colors.white,
              borderWidth: 0,
              colorBorder: Colors.transparent,
              borderRadius: 20,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          textCapriola(
                            fontSize: 8,
                            text: datenow,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              totalBalance >= 1000000000 ||
                                      totalExpense >= 1000000000 ||
                                      totalIncome >= 1000000000
                                  ? textPoppins(
                                    fontSize: 16,
                                    text: "Rp${formatCurrency(income)}",
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  )
                                  : textPoppins(
                                    fontSize: 18,
                                    text: "Rp${formatCurrency(income)}",
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                              textPoppins(
                                text: "Pemasukan",
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              totalBalance >= 1000000000 ||
                                      totalExpense >= 1000000000 ||
                                      totalIncome >= 1000000000
                                  ? textPoppins(
                                    fontSize: 16,
                                    text: "Rp${formatCurrency(expense)}",
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  )
                                  : textPoppins(
                                    fontSize: 18,
                                    text: "Rp${formatCurrency(expense)}",
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                              textPoppins(
                                text: "Pengeluaran",
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    Colors
                                        .grey[200], // Background luar (abu-abu)
                                borderRadius: BorderRadius.circular(25),
                              ),
                              height: 20,
                              width: 200,
                              child: TabBar(
                                controller: tabController,
                                onTap:
                                    (value) => ref
                                        .read(selectTabProvider.notifier)
                                        .changeValue(value),
                                labelPadding: EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 0,
                                ),
                                dividerHeight: 0,
                                indicator: BoxDecoration(
                                  color: Colors.cyan[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                indicatorColor: Colors.transparent,
                                labelColor: Colors.teal,
                                unselectedLabelColor: Colors.teal,
                                labelStyle: TextStyle(fontSize: 8),
                                tabs: [
                                  Center(child: Text("Harian")),
                                  Center(child: Text("Mingguan")),
                                  Center(child: Text("Bulanan")),
                                  Center(child: Text("Semua Waktu")),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 50),
                          currentFilter.category == "Semua Kategori" &&
                                  currentFilter.date == Date.terbaru &&
                                  currentFilter.type == FilterType.all &&
                                  currentFilter.descriptionQuery == null
                              ? SizedBox()
                              : InkWell(
                                onTap:
                                    () => currentFilterNotifier.resetFilter(),
                                child: SvgPicture.asset(
                                  "assets/logo/x.svg",
                                  height: 15,
                                ),
                              ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                isScrollControlled: true,
                                builder:
                                    (context) => FilterBottomSheet(
                                      transactionNotifier: transactionNotifier,
                                    ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    currentFilter.category ==
                                                "Semua Kategori" &&
                                            currentFilter.date ==
                                                Date.terbaru &&
                                            currentFilter.type ==
                                                FilterType.all &&
                                            currentFilter.descriptionQuery ==
                                                null
                                        ? Colors.grey[200]
                                        : Colors.cyan[100],
                                borderRadius: BorderRadius.circular(25),
                              ),
                              height: 20,
                              width: 60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/logo/filter.svg",
                                    height: 7,
                                  ),
                                  SizedBox(width: 3),
                                  textCapriola(
                                    fontSize: 10,
                                    text: "Filter",
                                    color: Colors.teal,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading:
            () => ContainerShimmer(
              borderRadius: 20,
              baseColor: Colors.white,
              highlightColor: Colors.grey[500],
            ),
        error: (err, stack) {
          print(err);
          return Center(child: Text("Terjadi kesalahan: $err"));
        },
      ),
    );
  }
}

// Separate the bottom sheet content into its own widget
class FilterBottomSheet extends ConsumerStatefulWidget {
  final dynamic transactionNotifier;

  const FilterBottomSheet({super.key, required this.transactionNotifier});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  late TextEditingController _descriptionController;
  late Date date;
  late String kategori;
  late String? deskripsi;
  late FilterType selectType;
  @override
  void initState() {
    super.initState();
    // Initialize with current filter values
    final currentFilter = ref.read(transactionFilterNotifierProvider);

    date = currentFilter.date;
    kategori =
        currentFilter.category ??
        "Semua Kategori"; // Default to "Semua Kategori"
    deskripsi = currentFilter.descriptionQuery;
    selectType = currentFilter.type;
    _descriptionController = TextEditingController(text: deskripsi);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use the provider to maintain state
    final currentFilter = ref.watch(transactionFilterNotifierProvider);
    final currentFilterNotifier = ref.read(
      transactionFilterNotifierProvider.notifier,
    );
    return Container(
      height: 420,
      width: 100.w,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => navKey.currentState!.pop(),
                child: SvgPicture.asset("assets/logo/x.svg"),
              ),
              SizedBox(width: 5),
              textCapriola(
                fontSize: 16,
                text: "Filter Transaksi",
                color: Colors.black,
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textCapriola(text: "Deskripsi", color: Colors.black),
              apptextfield(
                text: "Masukkan deskripsi",
                width: 70.w,
                height: 40,
                fontSize: 12,
                controller: _descriptionController,
                colorHintT: Colors.white,
                color: AppColors.secondary,
                func: (value) {
                  deskripsi = value.isEmpty ? null : value;
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textCapriola(text: "Kategori", color: Colors.black),
              SizedBox(
                width: 70.w,
                height: 40,
                child: CustomDropDown(
                  color: AppColors.secondary,
                  colorText: Colors.white,
                  colorIcon: Colors.white,
                  fontSize: 12,
                  dropdownColor: AppColors.secondary,
                  value: kategori,
                  itemsList: categoriesFilter,
                  onChanged: (value) {
                    // Update filter with new category
                    setState(() {
                      kategori = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          textCapriola(text: "Jenis:", color: Colors.black),
          SizedBox(height: 5),
          Row(
            children:
                FilterType.values
                    .map(
                      (type) => Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: FilterChip(
                          label: textCapriola(
                            fontSize: 12,
                            text:
                                type == FilterType.all
                                    ? 'Semua'
                                    : type == FilterType.income
                                    ? 'Pemasukan'
                                    : 'Pengeluaran',
                            color:
                                currentFilter.type == type
                                    ? Colors.teal[800]!
                                    : Colors.black87,
                          ),
                          selected: selectType == type,
                          selectedColor: Colors.teal[100],
                          backgroundColor: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                selectType = type;
                              });
                            }
                          },
                        ),
                      ),
                    )
                    .toList(),
          ),
          SizedBox(height: 10),
          textCapriola(text: "Urutkan:", color: Colors.black),
          SizedBox(height: 5),
          // First row - Terbaru and Terlama
          Row(
            children: [
              Expanded(
                child: FilterButton(
                  label: 'Terlama',
                  isSelected: date == Date.terlama,
                  onTap: () {
                    // date = Date.terlama;
                    setState(() {
                      date = Date.terlama;
                    });
                  },
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: FilterButton(
                  label: 'Terbaru',
                  isSelected: date == Date.terbaru,
                  onTap: () {
                    setState(() {
                      date = Date.terbaru;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 30),

          // Second row - Terkecil and Terbesar
          Center(
            child: button(
              height: 40,
              width: 50.w,
              text: "Terapkan",
              color: AppColors.secondary,
              colorBorder: Colors.transparent,
              func: () {
                deskripsi =
                    _descriptionController.text == ""
                        ? null
                        : _descriptionController.text;

                currentFilterNotifier.setFilter(
                  date: date,
                  category: kategori,
                  descriptionQuery: deskripsi,
                  type: selectType,
                );
                print("deskripsi ${deskripsi}");
                print("date ${date}");
                print("kategori ${kategori}");
                print("type ${selectType}");

                // Close the modal
                navKey.currentState!.pop();
              },
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onDoubleTap;

  const FilterButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: textCapriola(
          fontSize: 12,
          text: label,
          color: isSelected ? Colors.teal[800]! : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
