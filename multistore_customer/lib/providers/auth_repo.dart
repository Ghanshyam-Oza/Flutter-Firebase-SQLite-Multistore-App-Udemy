import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  static Future<void> signUpWithEmailAndPassword(email, password) async {
    final auth = FirebaseAuth.instance;
    await auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> signInWithEmailAndPassword(email, password) async {
    final auth = FirebaseAuth.instance;
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> sendEmailVerification() async {
    User user = FirebaseAuth.instance.currentUser!;
    try {
      await user.sendEmailVerification();
    } catch (err) {
      print(err);
    }
  }

  static get uid {
    User user = FirebaseAuth.instance.currentUser!;
    return user.uid;
  }

  static Future<void> updateUserName(storeName) async {
    User user = FirebaseAuth.instance.currentUser!;
    await user.updateDisplayName(storeName);
  }

  static Future<void> updateProfileImage(storeLogo) async {
    User user = FirebaseAuth.instance.currentUser!;
    await user.updatePhotoURL(storeLogo);
  }

  static Future<void> updateUserData() async {
    await FirebaseAuth.instance.currentUser!.reload();
  }

  static Future<bool> checkEmailVerification() async {
    try {
      bool emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      return emailVerified == true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  static Future<void> logOut() async {
    final auth = FirebaseAuth.instance;
    await auth.signOut();
  }

  static Future<void> sendPasswordResetEmail(email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (err) {
      print(err);
    }
  }

  static Future<bool> checkOldPassword(email, password) async {
    AuthCredential authCredential =
        EmailAuthProvider.credential(email: email, password: password);

    try {
      var credentialResult = await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(authCredential);

      return credentialResult.user != null;
    } catch (err) {
      print(err);
      return false;
    }
  }

  static Future<void> updateUserPassword(newPwd) async {
    User user = FirebaseAuth.instance.currentUser!;

    try {
      await user.updatePassword(newPwd);
    } catch (err) {
      print(err);
    }
  }
}
