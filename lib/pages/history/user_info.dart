import 'package:duitKu/pages/sign_in/notifier/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:duitKu/common/widgets/text.dart';

class UserInfoWidget extends ConsumerWidget {
  final String userId;

  const UserInfoWidget({required this.userId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider(userId));

    return userAsync.when(
      data:
          (user) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textCapriola(fontSize: 8, text: "Haiii"),
              textCapriola(text: user.name),
            ],
          ),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) {
        print(err);
        return Text("Error: $err");
      },
    );
  }
}
