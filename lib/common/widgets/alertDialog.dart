import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:duitKu/common/routes/app_routes_name.dart';
import 'package:duitKu/common/widgets/button.dart';
import 'package:duitKu/common/widgets/text.dart';
import 'package:duitKu/common/widgets/color.dart';
import 'package:duitKu/main.dart';
import 'package:sizer/sizer.dart';

class DeleteConfirmationDialog extends ConsumerWidget {
  final dynamic data;
  final String? title;
  final String? content;
  final Function()? onPressYes;

  const DeleteConfirmationDialog({
    super.key,
    this.data,
    this.title,
    this.content,
    this.onPressYes,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: textCapriola(
        fontSize: 20,
        text: title ?? "Konfirmasi",
        color: AppColors.primary,
      ),
      content: textCapriola(
        fontSize: 14,
        text: content ?? "",
        color: Colors.black,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: textCapriola(fontSize: 14, text: "Batal", color: Colors.blue),
        ),
        TextButton(
          onPressed: onPressYes!,
          child: textCapriola(fontSize: 14, text: "Ya", color: Colors.red),
        ),
      ],
    );
  }
}

Widget showDetailll(
  BuildContext context,
  dynamic data, {
  Function()? onPressYesDel,
  String? asset,
  String? content,
  Function()? onTapEdit,
  List<Widget>? children,
}) {
  return Dialog(
    insetPadding: EdgeInsets.zero, // hilangkan padding default
    backgroundColor: Colors.transparent, // biar transparan kalau mau
    child: Container(
      width: 95.w, // full lebar
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Title Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => navKey.currentState!.pop(),
                child: SvgPicture.asset("assets/logo/x.svg"),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      navKey.currentState!.pop();
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return DeleteConfirmationDialog(
                            data: data,
                            content: content,
                            onPressYes: onPressYesDel,
                          );
                        },
                      );
                    },
                    child: SvgPicture.asset("assets/logo/delete.svg"),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap:
                        onTapEdit ??
                        () {
                          navKey.currentState!.pop();
                          navKey.currentState!.pushNamed(
                            AppRoutesName.EDITTRANSACTION,
                            arguments: data,
                          );
                        },
                    child: SvgPicture.asset("assets/logo/edit.svg"),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          /// Content
          Container(
            width: double.infinity,
            decoration: boxDekor(
              color: AppColors.secondary.withOpacity(0.3),
              borderWidth: 0,
              colorBorder: Colors.transparent,
              borderRadius: 20,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children!,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
