class KalkulatorState {
  final String input;
  final String result;

  KalkulatorState({this.input = '', this.result = ''});
  KalkulatorState copyWith({String? input, String? result}) {
    return KalkulatorState(
      input: input ?? this.input,
      result: result ?? this.result,
    );
  }
}
