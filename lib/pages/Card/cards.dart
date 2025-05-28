import 'package:duitKu/pages/Card/notifier/card_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:duitKu/common/routes/app_routes_name.dart';
import 'package:duitKu/common/utils/format.dart';
import 'package:duitKu/common/widgets/alertDialog.dart';
import 'package:duitKu/common/widgets/button.dart';
import 'package:duitKu/common/widgets/color.dart';
import 'package:duitKu/common/widgets/shimmer.dart';
import 'package:duitKu/common/widgets/text.dart';
import 'package:duitKu/main.dart';
import 'package:duitKu/pages/Card/notifier/cards_notifier.dart';

class CardList extends ConsumerWidget {
  final String userId;

  const CardList({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardsAsync = ref.watch(cardsProvider(userId));
    final selectedCardId = ref.watch(selectedCardProvider);
    final cardNotifier = ref.read(cardNotifierProvider.notifier);

    // return FutureBuilder(
    //   future: Future.delayed(Duration(seconds: 10)), // ⏱️ Delay 10 detik
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState != ConnectionState.done) {
    //       // ⏳ Tampilkan shimmer dulu selama 10 detik
    //       return ListView.builder(
    //         scrollDirection: Axis.horizontal,
    //         padding: EdgeInsets.symmetric(horizontal: 10),
    //         itemCount: 3,
    //         itemBuilder: (context, index) {
    //           return ContainerShimmer();
    //         },
    //       );
    //     }

    return cardsAsync.when(
      data: (cards) {
        // // Jika user baru login dan tidak ada kartu yang dipilih sebelumnya
        // if (selectedCardId == null && cards.isNotEmpty) {
        //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     selectedCardNotifier.resetToFirstCard(cards.first.id);
        //   });
        // }
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 10),
          itemCount: cards.length + 1, // Tambah 1 untuk tombol "Add Card"
          itemBuilder: (context, index) {
            if (index == cards.length) {
              return GestureDetector(
                onTap: () {
                  print("Tambah kartu baru");
                  navKey.currentState!.pushNamed("/addcard");
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: SvgPicture.asset("assets/logo/add.svg", width: 30),
                    ),
                    textCapriola(
                      fontSize: 8,
                      text: "Add Card",
                      color: Colors.black,
                    ),
                  ],
                ),
              );
            }

            final card = cards[index];
            final cardId = card.id;
            final firstWord = card.cardName.split(" ").first;
            final isSelected = selectedCardId == cardId;
            final cardName = card.cardName;
            double balance = card.balance;
            String balanceFilter = formatCurrency(balance);

            return GestureDetector(
              onTap: () {
                ref.read(selectedCardProvider.notifier).selectCard(cardId);
                print("Kartu dipilih: $cardId");
              },
              onLongPress: () async {
                await showDialog(
                  context: context,
                  builder:
                      (context) => showDetailll(
                        context,
                        card,
                        onTapEdit: () {
                          navKey.currentState!.pop();
                          navKey.currentState!.pushNamed(
                            AppRoutesName.EDITCARD,
                            arguments: card,
                          );
                        },
                        content:
                            "Apakah yakin ingin menghapus kartu $cardName?",
                        onPressYesDel: () async {
                          cardNotifier.deleteCard(
                            cardName: cardName,
                            cardId: cardId,
                            userId: userId,
                          );
                        },
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/logo/card2.svg",
                                height: 70,
                              ),
                              SizedBox(width: 20),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  textCapriola(
                                    fontSize: 20,
                                    text: cardName,
                                    color: Colors.black,
                                  ),
                                  textCapriola(
                                    fontSize: 20,
                                    text: "Rp $balanceFilter",
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                );

                // await showDialog(
                //   context: context,
                //   builder:
                //       (context) => DeleteConfirmationDialog(
                //         content: "Apakah anda yakin ingin menghapus card ini?",
                //         onPressYes: () async {
                //           final firebase = FirebaseService();
                //           toastInfo(
                //             "Kartu $cardName Berhasil dihapus",
                //             bgColor: Colors.blue,
                //           );
                //           await firebase.deleteCard(userId, cardId);
                //           // Tutup dialog dulu
                //           Navigator.of(context).pop();
                //           // Ambil semua kartu yang tersisa
                //           final totalCards = await firebase.totalCards(userId);
                //           print("total kartu ${totalCards.docs.length}");
                //           if (totalCards.docs.isEmpty) {
                //             // Jika tidak ada kartu tersisa, arahkan ke halaman setup kartu
                //             navKey.currentState!.pushNamedAndRemoveUntil(
                //               "/setup",
                //               (route) => false,
                //             );
                //           } else {
                //             // Kalau masih ada kartu, atur salah satu sebagai selected
                //             await ref
                //                 .read(selectedCardProvider.notifier)
                //                 .setFirstCardAfterLogin(userId);
                //           }
                //         },
                //       ),
                // );
              },
              child: Container(
                width: 50,
                margin: EdgeInsets.only(right: 16),
                decoration: boxDekor(
                  color: isSelected ? AppColors.primary : AppColors.secondary,
                  borderWidth: 0,
                  colorBorder: Colors.transparent,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      child: SvgPicture.asset("assets/logo/card2.svg"),
                    ),
                    textCapriola(fontSize: 8, text: firstWord),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading:
          () => ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemCount: 3,
            itemBuilder: (context, index) {
              return ContainerShimmer();
            },
          ),

      error: (err, stack) {
        print("Error cards: $err");
        return Center(
          child: Text("Error: $err", style: TextStyle(color: Colors.red)),
        );
      },
    );
  }
}
