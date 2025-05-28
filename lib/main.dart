import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:duitKu/common/routes/routes.dart';
import 'package:duitKu/common/widgets/splash.dart';
import 'package:duitKu/global.dart';
import 'package:duitKu/pages/welcome/welcome.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  await Global.init();
  runApp(const ProviderScope(child: MainApp()));
}

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, typescreen) {
        return MaterialApp(
          locale: Locale('id'),
          supportedLocales: const [Locale('id')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          navigatorKey: navKey,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder:
                  (context) => FutureBuilder<Widget>(
                    future: AppPages.getPageForRoute(settings),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        final home = Global.storageService.setAfterLogin();
                        if (home) {
                          return const Splash();
                        } else {
                          return Scaffold(
                            body: Center(child: CircularProgressIndicator()),
                          );
                        }
                      }
                      if (snapshot.hasError) {
                        return Scaffold(
                          body: Center(child: Text("Error: ${snapshot.error}")),
                        );
                      }
                      return snapshot.data ?? const Welcome();
                    },
                  ),
            );
          },
        );
      },
    );
  }
}
