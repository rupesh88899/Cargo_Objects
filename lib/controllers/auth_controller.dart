import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../views/login_screen.dart';
import '../views/home_screen.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final Rx<User?> _user = Rx<User?>(null);
  final RxBool isLoading = false.obs;

  User? get user => _user.value;
  bool get isLoggedIn => _user.value != null;

  @override
  void onInit() {
    super.onInit();
    _user.bindStream(_auth.authStateChanges());
    ever<User?>(_user, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    Future.delayed(Duration.zero, () {
      if (user == null) {
        Get.offAll(() => LoginScreen());
      } else {
        Get.offAll(() => HomeScreen());
      }
    });
  }

  Future signInWithGoogle() async {
    try {
      isLoading.value = true;

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // user canceled login

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      Get.snackbar('Success', 'Logged in successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign in: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      Get.snackbar('Success', 'Logged out successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign out: $e');
    }
  }
}
