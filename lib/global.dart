import 'package:duitKu/common/services/storage.dart';
import 'package:duitKu/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Global {
  static late StorageService storageService;
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    tz.initializeTimeZones();
    final jakarta = tz.getLocation('Asia/Jakarta');
    tz.setLocalLocation(jakarta);
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await initializeDateFormatting('id_ID', null);

    storageService = await StorageService().init();
  }
}
