import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duitKu/common/model/user.dart';
import 'package:duitKu/common/routes/app_routes_name.dart';
import 'package:duitKu/common/services/firebase.dart';
import 'package:duitKu/common/utils/constans.dart';
import 'package:duitKu/common/widgets/popup_messages.dart';
import 'package:duitKu/global.dart';
import 'package:duitKu/main.dart';
import 'package:duitKu/pages/Card/notifier/cards_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_notifier.g.dart';

@riverpod
class ObscureText extends _$ObscureText {
  @override
  bool build() {
    return true;
  }

  void change(bool newvalue) {
    state = !newvalue;
  }
}

@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  FutureOr<UserModel> build() => UserModel();

  void changeUser(String username) {
    final current = state.value ?? UserModel();
    state = AsyncData(current.copyWith(name: username));
  }

  void changeEmail(String email) {
    final   current = state.value ?? UserModel();
    state = AsyncData(current.copyWith(email: email));
  }

  void changePassword(String password) {
    final current = state.value ?? UserModel();
    state = AsyncData(current.copyWith(password: password));
  }

  void changeConfirmPassword(String password) {
    final current = state.value ?? UserModel();
    state = AsyncData(current.copyWith(confirmPassword: password));
  }

  Future<void> register(BuildContext context) async {
    final current = state.value;
    if (current == null) {
      return;
    }
    final username = current.name;
    final email = current.email;
    final password = current.password;
    final confirmPassword = current.confirmPassword;

    print("your username: $username");
    print("your email: $email");
    print("your password: $password");
    print("your rePassword: $confirmPassword");
    if (username.isEmpty) {
      toastInfo("Nama tidak boleh kosong");
      return;
    }
    if (username.length < 5) {
      toastInfo("Nama harus lebih dari 5 character");
      return;
    }

    if (email.isEmpty || !email.contains('@gmail.com')) {
      toastInfo("Email harus berupa gmail.com");
      return;
    }
    if (password.isEmpty || confirmPassword.isEmpty) {
      toastInfo("Password dan confirm password tidak boleh kosong");
      return;
    }

    if (password != confirmPassword) {
      toastInfo("Password dan confirm password tidak sama");
      return;
    }

    state = const AsyncLoading();

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (credential.user != null) {
        await credential.user!.sendEmailVerification();
        await credential.user!.updateDisplayName(username);

        final firebase = FirebaseService();
        await firebase.addUser(
          userId: credential.user!.uid,
          name: username,
          email: email,
        );

        toastInfo(
          "Silakan cek email $email untuk verifikasi",
          bgColor: Colors.blueAccent,
        );
        DefaultTabController.of(context).animateTo(0);

        state = AsyncData(current); // kembali ke data lama jika perlu
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          toastInfo("User tidak ditemukan. Silakan register terlebih dahulu.");
          break;
        case 'wrong-password':
          toastInfo("Password salah. Silakan coba lagi.");
          break;
        case 'invalid-email':
          toastInfo("Email tidak valid. Periksa kembali format email Anda.");
          break;
        case 'user-disabled':
          toastInfo("Akun Anda telah dinonaktifkan. Hubungi administrator.");
          break;
        case 'too-many-requests':
          toastInfo("Terlalu banyak percobaan login. Coba dalam 1-2 menit.");
          break;
        case 'operation-not-allowed':
          toastInfo("Metode login tidak diizinkan. Hubungi administrator.");
          break;
        case 'network-request-failed':
          toastInfo("Tidak ada koneksi internet. Periksa koneksi Anda.");
          break;
        case 'email-already-in-use':
          toastInfo("Email sudah digunakan. Gunakan email lain atau login.");
          break;
        case 'weak-password':
          toastInfo("Password terlalu lemah. Gunakan minimal 6 karakter.");
          break;
        default:
          toastInfo("Terjadi kesalahan: ${e.message ?? 'Unknown error'}");
      }
      state = AsyncError(e, StackTrace.current);
    } catch (e, st) {
      toastInfo("Kesalahan tidak terduga: $e");
      state = AsyncError(e, st);
    }
  }

  Future<void> login() async {
    final current = state.value;

    if (current == null) return;
    final email = current.email.trim();
    final password = current.password;

    if (email.isEmpty || password.isEmpty) {
      toastInfo("Email atau Password tidak boleh kosong");
      return;
    }

    state = const AsyncLoading();

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        await FirebaseAuth.instance.signOut();
        toastInfo(
          "Email belum terverifikasi. Cek email $email untuk verifikasi sebelum login.",
        );
        state = AsyncData(current); // Reset ke data lama
        return;
      }

      // Simpan data ke storage
      Global.storageService.setString(
        key: AppConstants.STORAGE_USER_PROFILE_KEY,
        value: user!.displayName ?? '',
      );
      Global.storageService.setString(
        key: AppConstants.STORAGE_USER_TOKEN_KEY,
        value: user.uid,
      );
      print("user id : ${user.uid}");
      // Set kartu pertama
      await ref
          .read(selectedCardProvider.notifier)
          .setFirstCardAfterLogin(user.uid);

      // Navigasi ke halaman berikutnya
      navKey.currentState?.pushNamedAndRemoveUntil('/setup', (route) => false);

      toastInfo(
        "Login Berhasil",
        bgColor: const Color.fromARGB(155, 68, 137, 255),
        icon: Icons.check_circle,
      );

      state = AsyncData(current); // Optional: reset kembali ke state aman
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          toastInfo("User tidak ditemukan. Silakan register terlebih dahulu.");
          break;
        case 'wrong-password':
          toastInfo("Password salah. Silakan coba lagi.");
          break;
        case 'invalid-email':
          toastInfo("Email tidak valid. Periksa kembali format email Anda.");
          break;
        case 'user-disabled':
          toastInfo("Akun Anda telah dinonaktifkan. Hubungi administrator.");
          break;
        case 'too-many-requests':
          toastInfo(
            "Terlalu banyak percobaan login. Coba lagi dalam 1-2 menit.",
          );
          break;
        case 'operation-not-allowed':
          toastInfo("Metode login tidak diizinkan. Hubungi administrator.");
          break;
        case 'network-request-failed':
          toastInfo("Tidak ada koneksi internet. Periksa koneksi Anda.");
          break;
        case 'email-already-in-use':
          toastInfo("Email sudah digunakan. Gunakan email lain atau login.");
          break;
        case 'weak-password':
          toastInfo("Password terlalu lemah. Gunakan minimal 6 karakter.");
          break;
        default:
          toastInfo("Terjadi kesalahan: ${e.message ?? 'Unknown error'}");
      }
      state = AsyncError(e, StackTrace.current);
    } catch (e, st) {
      toastInfo('Terjadi kesalahan saat login: $e');
      state = AsyncError(e, st);
    }
  }

  void logout() async {
    try {
      print("User logged out");
      await FirebaseAuth.instance.signOut();

      Global.storageService.clearUserData(); // Hapus data user dari storage
      toastInfo("Logout Berhasil", bgColor: Colors.blue);
      // Redirect ke halaman SignIn setelah logout
      navKey.currentState!.pushNamedAndRemoveUntil(
        AppRoutesName.SIGN_IN,
        (route) => false,
      );
    } catch (e) {
      print("Logout Error: $e");
      toastInfo("Logout Gagal");
    }
  }
}

// Provider untuk mengambil data user berdasarkan ID
final userProvider = StreamProvider.family<UserModel, String>((ref, userId) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .snapshots()
      .map((snapshot) => UserModel.fromFirestore(snapshot));
});
