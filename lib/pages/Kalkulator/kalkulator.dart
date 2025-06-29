import 'package:duitKu/common/widgets/color.dart';
import 'package:duitKu/common/widgets/text.dart';
import 'package:duitKu/pages/Kalkulator/notifier/kalkulator_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Kalkulator extends ConsumerWidget {
  const Kalkulator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(kalkulatorNotifierProvider);

    final buttons = [
      ['7', '8', '9', '⌫'],
      ['4', '5', '6', '÷'],
      ['1', '2', '3', 'x'],
      ['0', ',', '-', '+'],
      ['=', "C"],
    ];

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back, color: Colors.white),
                ),
                SizedBox(width: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: textPoppins(
                    text: 'Kalkulator',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      state.input,
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      state.result,
                      style: TextStyle(fontSize: 48, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white),
            Expanded(
              child: Column(
                children:
                    buttons.map((row) {
                      return Expanded(
                        flex: 0,
                        child: Row(
                          children:
                              row.map((label) {
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: buildButton(label, ref),
                                  ),
                                );
                              }).toList(),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildButton(String label, WidgetRef ref) {
  return ElevatedButton(
    onPressed: () {
      if (label == '=') {
        ref.read(kalkulatorNotifierProvider.notifier).calculate();
      } else if (label == 'C') {
        ref.read(kalkulatorNotifierProvider.notifier).clear();
      } else if (label == "⌫") {
        ref.read(kalkulatorNotifierProvider.notifier).deleteLast();
      } else {
        ref.read(kalkulatorNotifierProvider.notifier).append(label);
      }
    },
    child: Text(label, style: TextStyle(fontSize: 20)),
  );
}
