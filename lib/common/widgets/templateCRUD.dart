import 'package:duitKu/common/widgets/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class TemplateCRUD extends ConsumerWidget {
  final List<Widget> children;
  final bool form;
  final GlobalKey<FormState>? formKey;

  const TemplateCRUD({
    super.key,
    required this.children,
    this.form = false,
    this.formKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return form == true
        ? Form(
          key: formKey,
          child: Container(
            height: 100.h,
            width: 100.w,
            decoration: BoxDecoration(gradient: AppColors.primaryGradient),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  ),
                ),
                Positioned(
                  top: 16,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        )
        : Container(
          height: 100.h,
          width: 100.w,
          decoration: BoxDecoration(gradient: AppColors.primaryGradient),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              ),
              Positioned(
                top: 16,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
  }
}
