// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$obscureTextHash() => r'2d52f2903245d9c115dae9ea104e76c60c69dbee';

/// See also [ObscureText].
@ProviderFor(ObscureText)
final obscureTextProvider =
    AutoDisposeNotifierProvider<ObscureText, bool>.internal(
      ObscureText.new,
      name: r'obscureTextProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$obscureTextHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ObscureText = AutoDisposeNotifier<bool>;
String _$userNotifierHash() => r'2e932ed5f3e318254975a4a22ce0f65ad4edf7ad';

/// See also [UserNotifier].
@ProviderFor(UserNotifier)
final userNotifierProvider =
    AutoDisposeAsyncNotifierProvider<UserNotifier, UserModel>.internal(
      UserNotifier.new,
      name: r'userNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$userNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserNotifier = AutoDisposeAsyncNotifier<UserModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
