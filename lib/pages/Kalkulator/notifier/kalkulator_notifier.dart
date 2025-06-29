import 'package:duitKu/pages/Kalkulator/kalkulatorState.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'kalkulator_notifier.g.dart';

@riverpod
class KalkulatorNotifier extends _$KalkulatorNotifier {
  KalkulatorState build() => KalkulatorState();

  void append(String value) {
    final current = state.input;

    // Jika tombol operator ditekan
    if (['+', '-', 'x', '÷'].contains(value)) {
      // Cegah dua operator berurutan
      if (current.isEmpty) return;
      final lastChar = current.characters.last;
      if (['+', '-', 'x', '÷'].contains(lastChar)) {
        // Ganti operator sebelumnya
        state = state.copyWith(
          input: current.substring(0, current.length - 1) + value,
        );
      } else {
        // Tambahkan operator
        state = state.copyWith(input: current + value);
      }
      return;
    }

    // Jika angka ditekan
    if (RegExp(r'^\d$').hasMatch(value)) {
      // Temukan indeks operator terakhir
      final operatorMatch = RegExp(r'[+\-×÷]').allMatches(current);

      if (operatorMatch.isEmpty) {
        // Belum ada operator → format semua angka
        final cleaned = (current + value).replaceAll('.', '');
        final formatted = formatNumberInput(cleaned);
        state = state.copyWith(input: formatted);
      } else {
        // Format hanya angka setelah operator terakhir
        final lastOperatorIndex = operatorMatch.last.end;
        final left = current.substring(0, lastOperatorIndex);
        final right =
            current.substring(lastOperatorIndex).replaceAll('.', '') + value;
        final formattedRight = formatNumberInput(right);
        state = state.copyWith(input: left + formattedRight);
      }
    }
  }

  final _formatter = NumberFormat.decimalPattern('id');

  String formatNumberInput(String rawInput) {
    final cleaned = rawInput.replaceAll('.', '');
    if (RegExp(r'^\d+$').hasMatch(cleaned)) {
      final number = int.tryParse(cleaned);
      return number != null ? _formatter.format(number) : rawInput;
    }
    return rawInput;
  }

  void deleteLast() { 
    final current = state.input;
    if (current.isEmpty) return;

    // Hapus karakter terakhir
    final newInput = current.substring(0, current.length - 1);

    // Jika input kosong, reset ke default
    if (newInput.isEmpty) {
      state = KalkulatorState();
    } else {
      state = state.copyWith(input: newInput);
    }
  }

  void calculate() {
    try {
      final cleanInput = state.input
          .replaceAll('.', '') // hapus titik ribuan
          .replaceAll('x', '*')
          .replaceAll('÷', '/')
          .replaceAll(',', '.'); // ubah koma ke titik

      final parser = Parser();
      final expression = parser.parse(cleanInput);
      final result = expression.evaluate(EvaluationType.REAL, ContextModel());

      String formattedResult;
      if (result % 1 == 0) {
        formattedResult = _formatter.format(result.toInt());
      } else {
        formattedResult = result.toStringAsFixed(2).replaceAll('.', ',');
      }

      state = state.copyWith(result: formattedResult);
    } catch (e) {
      state = state.copyWith(result: '0');
    }
  }

  void clear() {
    state = KalkulatorState();
  }
}
