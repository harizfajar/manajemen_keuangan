import 'package:duitKu/common/widgets/color.dart';
import 'package:duitKu/common/widgets/text.dart';
import 'package:duitKu/pages/Card/cards.dart';
import 'package:duitKu/pages/history/user_info.dart';
import 'package:duitKu/pages/sign_in/notifier/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class TemplateAPP extends ConsumerWidget {
  final UserNotifier? userNotifier;
  final String? userId;
  final List<Widget>? Content;
  const TemplateAPP({super.key, this.userNotifier, this.userId, this.Content});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: Stack(
              children: [
                Container(
                  color: Colors.transparent,
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: AppColors.verticalGradient,
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 40,
                  child: GestureDetector(
                    onTap: () {
                      print("logout");
                      userNotifier!.logout();
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/logo/logo.svg", width: 25),
                        SizedBox(width: 1.h),
                        textCapriola(fontSize: 16, text: "uangQ"),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 40,
                  child: UserInfoWidget(userId: userId!),
                ),
                Positioned(
                  top: 105,
                  left: 0,
                  right: 0,
                  child: SizedBox(height: 55, child: CardList(userId: userId!)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                border: Border(
                  top: BorderSide(width: 10, color: AppColors.secondary),
                  left: BorderSide(color: AppColors.secondary, width: 10),
                  right: BorderSide(color: AppColors.secondary, width: 10),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),

                child: Column(children: Content!),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
