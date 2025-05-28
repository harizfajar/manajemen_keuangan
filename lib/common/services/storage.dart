import 'package:duitKu/common/utils/constans.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  SharedPreferences? _pref;

  Future<StorageService> init() async {
    _pref = await SharedPreferences.getInstance();
    return this;
  }

  // Menyimpan data
  Future<void> setString({String key = "", String value = ""}) async {
    await _pref!.setString(key, value);
  }

  // Mengambil data
  String getString(String key) {
    return _pref!.getString(key) ?? "";
  }

  // Menghapus data
  Future<void> remove(String key) async {
    await _pref!.remove(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _pref!.setBool(key, value);
  }

  bool getDeviceFisrtOpen() {
    return _pref!.getBool(AppConstants.STORAGE_DEVICE_OPEN_FIRST_KEY) ?? false;
  }

  bool isLoggedIn() {
    return getString(AppConstants.STORAGE_USER_PROFILE_KEY).isNotEmpty;
  }

  bool setAfterLogin() {
    return _pref!.getBool(AppConstants.STORAGE_DEVICE_HOME) ?? false;
  }

  bool isSetup() {
    return getString(AppConstants.STORAGE_DEVICE_SETUP).isNotEmpty;
  }

  String getUserId() {
    return getString(AppConstants.STORAGE_USER_TOKEN_KEY);
  }

  String getCard() {
    return getString(AppConstants.STORAGE_CARDS_KEY);
  }

  // Hapus data user saat logout
  Future<void> clearUserData() async {
    await _pref!.remove(AppConstants.STORAGE_USER_PROFILE_KEY);
    await _pref!.remove(AppConstants.STORAGE_USER_TOKEN_KEY);
    await _pref!.remove(AppConstants.STORAGE_DEVICE_SETUP);
    await _pref!.remove(AppConstants.STORAGE_CARDS_KEY);
    await _pref!.remove(AppConstants.STORAGE_DEVICE_HOME);

    print("User data cleared");

    print("✅ User data cleared!");

    // Cek apakah data benar-benar terhapus
    print(
      "STORAGE_USER_PROFILE_KEY: ${_pref!.getString(AppConstants.STORAGE_USER_PROFILE_KEY)}",
    ); // Harus null
    print(
      "STORAGE_USER_TOKEN_KEY: ${_pref!.getString(AppConstants.STORAGE_USER_TOKEN_KEY)}",
    ); // Harus null
    print(
      "STORAGE_CARDS_KEY: ${_pref!.getString(AppConstants.STORAGE_CARDS_KEY)}",
    ); // Harus null
    print(
      "STORAGE_DEVICE_SETUP: ${_pref!.getBool(AppConstants.STORAGE_DEVICE_SETUP)}",
    ); // Harus false atau null
    print(
      "STORAGE_DEVICE_HOME: ${_pref!.getBool(AppConstants.STORAGE_DEVICE_HOME)}",
    ); // Harus false atau null
  }
}
