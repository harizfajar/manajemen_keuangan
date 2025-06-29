import 'package:duitKu/common/widgets/templateAPP.dart';
import 'package:duitKu/global.dart';
import 'package:duitKu/pages/Card/notifier/cards_notifier.dart';
import 'package:duitKu/pages/Transaction/transaction_list.dart';
import 'package:duitKu/pages/history/balance.dart';
import 'package:duitKu/pages/application/notifier/application_notifier.dart';
import 'package:duitKu/pages/sign_in/notifier/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class History extends ConsumerStatefulWidget {
  const History({super.key});

  @override
  ConsumerState<History> createState() => _HistoryState();
}

class _HistoryState extends ConsumerState<History>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Update controller ke Riverpod
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(selectTabProvider.notifier).changeValue(_tabController.index);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabController.index = ref.read(selectTabProvider);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardid = ref.watch(selectedCardProvider);
    final userId = Global.storageService.getUserId();
    return TemplateAPP(
      userId: userId,
      content: [
        TotalBalance(tabController: _tabController),
        SizedBox(height: 10),
        Expanded(
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: TabBarView(
              controller: _tabController,
              children: [
                TransactionList(cardId: cardid.toString(), filter: "daily"),
                TransactionList(cardId: cardid.toString(), filter: "weekly"),
                TransactionList(cardId: cardid.toString(), filter: "monthly"),
                TransactionList(cardId: cardid.toString(), filter: "lifetime"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
