// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionNotifierHash() =>
    r'91b820836f0ac2813e3063df82fda40f31f8ca34';

/// See also [TransactionNotifier].
@ProviderFor(TransactionNotifier)
final transactionNotifierProvider = AutoDisposeNotifierProvider<
  TransactionNotifier,
  AsyncValue<TransactionModel>
>.internal(
  TransactionNotifier.new,
  name: r'transactionNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$transactionNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TransactionNotifier =
    AutoDisposeNotifier<AsyncValue<TransactionModel>>;
String _$transactionFilterNotifierHash() =>
    r'd1bc2d52e32a93da63122bb575df81fb0b33f099';

/// See also [TransactionFilterNotifier].
@ProviderFor(TransactionFilterNotifier)
final transactionFilterNotifierProvider = AutoDisposeNotifierProvider<
  TransactionFilterNotifier,
  TransactionFilter
>.internal(
  TransactionFilterNotifier.new,
  name: r'transactionFilterNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$transactionFilterNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TransactionFilterNotifier = AutoDisposeNotifier<TransactionFilter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
