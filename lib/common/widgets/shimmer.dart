import 'package:flutter/material.dart';
import 'package:duitKu/common/widgets/color.dart';
import 'package:shimmer/shimmer.dart';

class ContainerShimmer extends StatelessWidget {
  final double? marginRight;
  final double? marginLeft;
  final double? marginTop;
  final double? marginBottom;
  final double? height;
  final double? width;
  final Color? baseColor;
  final Color? highlightColor;
  final double? borderRadius;
  const ContainerShimmer({
    this.marginRight,
    this.marginBottom,
    this.marginLeft,
    this.marginTop,
    this.height,
    this.width,
    this.baseColor,
    this.highlightColor,
    this.borderRadius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: marginRight ?? 16,
        left: marginLeft ?? 0,
        top: marginTop ?? 0,
        bottom: marginBottom ?? 0,
      ),
      child: Shimmer.fromColors(
        baseColor: baseColor ?? AppColors.primary,
        highlightColor: highlightColor ?? AppColors.secondary,
        child: Container(
          width: width ?? 50,
          height: height ?? 0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
        ),
      ),
    );
  }
}
