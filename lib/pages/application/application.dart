import 'package:duitKu/common/routes/app_routes_name.dart';
import 'package:duitKu/pages/beranda/beranda.dart';
import 'package:duitKu/pages/history/history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:duitKu/common/utils/constans.dart';
import 'package:duitKu/common/widgets/button.dart';
import 'package:duitKu/common/widgets/color.dart';
import 'package:duitKu/global.dart';
import 'package:duitKu/pages/application/notifier/application_notifier.dart';
import 'package:google_fonts/google_fonts.dart';

class Application extends ConsumerStatefulWidget {
  const Application({super.key});

  @override
  ConsumerState<Application> createState() => _ApplicationState();
}

class _ApplicationState extends ConsumerState<Application>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Global.storageService.setBool(AppConstants.STORAGE_DEVICE_HOME, true);
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(bottombarIndexProvider);
    print("bottombar $selectedIndex");
    final selectab = ref.watch(selectTabProvider);
    print("selecttab $selectab");

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: [Beranda(), History(), Text("Settings")],
      ),
      floatingActionButton: IconButton(
        icon: Container(
          padding: EdgeInsets.all(10),
          height: 50,
          width: 50,
          decoration: boxDekor(
            color: Colors.white,
            borderRadius: 10,
            colorBorder: Colors.transparent,
          ),
          child: SvgPicture.asset("assets/logo/add.svg"),
        ),
        onPressed:
            () => Navigator.pushNamed(context, AppRoutesName.ADDTRANSACTION),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: AppColors.secondary,
          child: ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: SizedBox(
              height: 70,
              child: BottomNavigationBar(
                backgroundColor: Colors.white, // Penting agar radius terlihat
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppColors.secondary,
                unselectedItemColor: Colors.grey,
                currentIndex: selectedIndex,
                selectedLabelStyle: GoogleFonts.capriola(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: GoogleFonts.capriola(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                onTap: (value) {
                  ref.read(bottombarIndexProvider.notifier).changeValue(value);
                },
                items: [
                  BottomNavBarItemCust(),
                  BottomNavBarItemCust(
                    assets: "assets/logo/history.svg",
                    label: "History",
                  ),
                  BottomNavBarItemCust(
                    assets: "assets/logo/lainnya.svg",
                    label: "Lainnya",
                    height: 34,
                    activeHeight: 38,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem BottomNavBarItemCust({
    String? assets,
    String? label,
    double? height,
    double? activeHeight,
  }) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        assets ?? "assets/logo/beranda.svg",
        color: Colors.grey,
        height: height ?? 30,
      ),
      activeIcon: SvgPicture.asset(
        assets ?? "assets/logo/beranda.svg",
        height: activeHeight ?? 35,
        color: AppColors.secondary,
      ),
      label: label ?? "Beranda",
    );
  }
}
